import AVFoundation

/// Combines the encoded video with a music track.
///
/// * The video samples are copied untouched (passthrough, no re-encode).
/// * The audio is placed in an `AVMutableComposition` from `audioStart`,
///   trimmed to the video duration, read through `AVAssetReaderAudioMixOutput`
///   with an `AVMutableAudioMix` volume ramp (1 → 0 over the last `fadeOut`),
///   and re-encoded to AAC-LC 44.1 kHz stereo by `AVAssetWriter`.
///
/// `AVAssetExportSession` is not used because its passthrough preset ignores
/// audio mixes and every other preset re-encodes the video as well.
enum AudioMuxer {
  static func mux(
    videoURL: URL,
    audioURL: URL,
    audioStart: CMTime,
    fadeOut: CMTime,
    duration: CMTime,
    outputURL: URL
  ) async throws {
    let videoAsset = AVURLAsset(url: videoURL)
    let audioAsset = AVURLAsset(
      url: audioURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])

    guard let videoTrack = try await videoAsset.loadTracks(withMediaType: .video).first else {
      throw EncoderError.encoder("Encoded video has no video track")
    }
    let sourceAudio: AVAssetTrack
    let audioDuration: CMTime
    do {
      guard let track = try await audioAsset.loadTracks(withMediaType: .audio).first else {
        throw EncoderError.audio("The audio file contains no audio track")
      }
      sourceAudio = track
      audioDuration = try await audioAsset.load(.duration)
    } catch let error as EncoderError {
      throw error
    } catch {
      throw EncoderError.audio("Cannot read audio file: \(error.localizedDescription)")
    }

    // 1. Trim: [audioStart, audioStart + min(duration, remaining audio)).
    let available = CMTimeSubtract(audioDuration, audioStart)
    guard available > .zero else {
      throw EncoderError.audio("audioStart is beyond the end of the audio file")
    }
    let composition = AVMutableComposition()
    guard
      let compAudio = composition.addMutableTrack(
        withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
    else { throw EncoderError.audio("Cannot create audio composition track") }
    do {
      try compAudio.insertTimeRange(
        CMTimeRange(start: audioStart, duration: CMTimeMinimum(duration, available)),
        of: sourceAudio, at: .zero)
    } catch {
      throw EncoderError.audio("Cannot trim audio: \(error.localizedDescription)")
    }

    // 2. Fade: linear volume ramp over the last `fadeOut` of the *video*.
    let mix = AVMutableAudioMix()
    let params = AVMutableAudioMixInputParameters(track: compAudio)
    if fadeOut > .zero {
      let fade = CMTimeMinimum(fadeOut, duration)
      params.setVolumeRamp(
        fromStartVolume: 1, toEndVolume: 0,
        timeRange: CMTimeRange(start: CMTimeSubtract(duration, fade), duration: fade))
    }
    mix.inputParameters = [params]

    // 3. Readers: video passthrough, audio decoded to PCM through the mix.
    let videoReader = try AVAssetReader(asset: videoAsset)
    let videoOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: nil)
    videoOutput.alwaysCopiesSampleData = false
    videoReader.add(videoOutput)

    let audioReader: AVAssetReader
    do {
      audioReader = try AVAssetReader(asset: composition)
    } catch {
      throw EncoderError.audio("Cannot read audio: \(error.localizedDescription)")
    }
    let audioOutput = AVAssetReaderAudioMixOutput(
      audioTracks: [compAudio],
      audioSettings: [
        AVFormatIDKey: kAudioFormatLinearPCM,
        AVSampleRateKey: 44_100,
        AVNumberOfChannelsKey: 2,
        AVLinearPCMBitDepthKey: 16,
        AVLinearPCMIsFloatKey: false,
        AVLinearPCMIsBigEndianKey: false,
        AVLinearPCMIsNonInterleaved: false,
      ])
    audioOutput.audioMix = mix
    audioReader.add(audioOutput)
    audioReader.timeRange = CMTimeRange(start: .zero, duration: duration)

    // 4. Writer.
    try? FileManager.default.removeItem(at: outputURL)
    let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
    let formatHint = try await videoTrack.load(.formatDescriptions).first
    let videoInput = AVAssetWriterInput(
      mediaType: .video, outputSettings: nil, sourceFormatHint: formatHint)
    videoInput.expectsMediaDataInRealTime = false
    let audioInput = AVAssetWriterInput(
      mediaType: .audio,
      outputSettings: [
        AVFormatIDKey: kAudioFormatMPEG4AAC,
        AVSampleRateKey: 44_100,
        AVNumberOfChannelsKey: 2,
        AVEncoderBitRateKey: 192_000,
      ])
    audioInput.expectsMediaDataInRealTime = false
    writer.add(videoInput)
    writer.add(audioInput)

    guard videoReader.startReading() else {
      throw EncoderError.encoder(
        "Cannot read encoded video: \(videoReader.error?.localizedDescription ?? "")")
    }
    guard audioReader.startReading() else {
      throw EncoderError.audio(
        "Cannot decode audio: \(audioReader.error?.localizedDescription ?? "")")
    }
    guard writer.startWriting() else {
      throw EncoderError.encoder(
        "Cannot write \(outputURL.lastPathComponent): \(writer.error?.localizedDescription ?? "")")
    }
    writer.startSession(atSourceTime: .zero)

    // Pump both tracks concurrently; AVAssetWriter interleaves them.
    await pump([(videoOutput, videoInput), (audioOutput, audioInput)], writer: writer)

    if videoReader.status == .failed || audioReader.status == .failed {
      writer.cancelWriting()
      if audioReader.status == .failed {
        throw EncoderError.audio(
          "Decoding audio failed: \(audioReader.error?.localizedDescription ?? "")")
      }
      throw EncoderError.encoder(
        "Reading video failed: \(videoReader.error?.localizedDescription ?? "")")
    }
    writer.endSession(atSourceTime: duration)
    await writer.finishWriting()
    guard writer.status == .completed else {
      throw EncoderError.encoder(
        "Writing the MP4 failed: \(writer.error?.localizedDescription ?? "unknown")")
    }
  }

  /// Copies every sample of each output into its input whenever the writer
  /// is ready for more, and returns when all tracks are done.
  private static func pump(
    _ pairs: [(AVAssetReaderOutput, AVAssetWriterInput)], writer: AVAssetWriter
  ) async {
    let pump = SamplePump(pairs: pairs, writer: writer)
    await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
      pump.run { continuation.resume() }
    }
  }
}

/// AVFoundation objects are not `Sendable`; each one here is only touched
/// from its own serial queue, which is what the unchecked conformance asserts.
private final class SamplePump: @unchecked Sendable {
  private let pairs: [(AVAssetReaderOutput, AVAssetWriterInput)]
  private let writer: AVAssetWriter

  init(pairs: [(AVAssetReaderOutput, AVAssetWriterInput)], writer: AVAssetWriter) {
    self.pairs = pairs
    self.writer = writer
  }

  func run(_ done: @escaping @Sendable () -> Void) {
    let group = DispatchGroup()
    for (index, (output, input)) in pairs.enumerated() {
      group.enter()
      var finished = false
      let queue = DispatchQueue(label: "StoryVideoEncoder.mux.\(index)")
      input.requestMediaDataWhenReady(on: queue) { [self] in
        while (input.isReadyForMoreMediaData || writer.status == .failed) && !finished {
          if writer.status != .failed, let sample = output.copyNextSampleBuffer(),
            input.append(sample)
          {
            continue
          }
          // End of track, or an error (the caller checks reader/writer status).
          finished = true
          input.markAsFinished()
          group.leave()
        }
      }
    }
    group.notify(queue: .global(), execute: done)
  }
}
