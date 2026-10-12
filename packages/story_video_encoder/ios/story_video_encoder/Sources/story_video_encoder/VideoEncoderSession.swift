import AVFoundation
import Accelerate
import CoreVideo

/// One MP4 being encoded with AVAssetWriter on a private serial queue.
///
/// Frames arrive as RGBA8888; they are swizzled to BGRA (the native format
/// of the H.264 hardware encoder's pixel buffer pool) with vImage and
/// appended at `index / fps` — timestamps never depend on render speed.
/// With music, the video is written to a temporary file first and the audio
/// is added by `AudioMuxer` in `finish`.
final class VideoEncoderSession {
  let id: Int
  private let config: SessionConfig
  private let queue: DispatchQueue
  private let videoURL: URL

  private var writer: AVAssetWriter?
  private var input: AVAssetWriterInput?
  private var adaptor: AVAssetWriterInputPixelBufferAdaptor?
  private var framesAppended: Int64 = 0
  private var closed = false
  private var finished = false

  init(id: Int, config: SessionConfig) {
    self.id = id
    self.config = config
    self.queue = DispatchQueue(label: "StoryVideoEncoder.\(id)", qos: .userInitiated)
    self.videoURL =
      config.audioURL == nil
      ? config.outputURL
      : URL(fileURLWithPath: config.outputURL.path + ".video.tmp.mp4")
  }

  func start(_ done: @escaping (Error?) -> Void) {
    run(done) { try self.setUp() }
  }

  func addFrame(index: Int64, rgba: Data, _ done: @escaping (Error?) -> Void) {
    run(done) { try self.append(index: index, rgba: rgba) }
  }

  func finish(_ done: @escaping (Error?, String?) -> Void) {
    queue.async {
      do {
        guard !self.closed, let writer = self.writer, let input = self.input else {
          throw EncoderError.invalidSession("Session \(self.id) is closed")
        }
        guard self.framesAppended > 0 else { throw EncoderError.encoder("No frames were added") }
        self.closed = true
        let duration = CMTime(value: self.framesAppended, timescale: self.config.fps)
        input.markAsFinished()
        // The last frame lasts 1/fps: the file is exactly frameCount/fps long.
        writer.endSession(atSourceTime: duration)
        let finished = DispatchSemaphore(value: 0)
        writer.finishWriting { finished.signal() }
        finished.wait()
        guard writer.status == .completed else {
          throw EncoderError.encoder(
            "Writing the video failed: \(writer.error?.localizedDescription ?? "unknown")")
        }
        self.release()
        self.finished = true  // from here on errors are handled below
        guard let audioURL = self.config.audioURL else {
          return done(nil, self.config.outputURL.path)
        }
        let config = self.config
        let videoURL = self.videoURL
        Task {
          do {
            try await AudioMuxer.mux(
              videoURL: videoURL,
              audioURL: audioURL,
              audioStart: CMTime(value: config.audioStartUs, timescale: 1_000_000),
              fadeOut: CMTime(value: config.fadeOutUs, timescale: 1_000_000),
              duration: duration,
              outputURL: config.outputURL)
            try? FileManager.default.removeItem(at: videoURL)
            done(nil, config.outputURL.path)
          } catch {
            try? FileManager.default.removeItem(at: videoURL)
            try? FileManager.default.removeItem(at: config.outputURL)
            done(error, nil)
          }
        }
      } catch {
        self.fail()
        done(error, nil)
      }
    }
  }

  func cancel(_ done: @escaping () -> Void) {
    queue.async {
      self.fail()
      done()
    }
  }

  // MARK: - Session queue

  private func run(_ done: @escaping (Error?) -> Void, _ block: @escaping () throws -> Void) {
    queue.async {
      do {
        if self.closed { throw EncoderError.invalidSession("Session \(self.id) is closed") }
        try block()
        done(nil)
      } catch {
        self.fail()
        done(error)
      }
    }
  }

  private func setUp() throws {
    if let audioURL = config.audioURL,
      !FileManager.default.fileExists(atPath: audioURL.path)
    {
      throw EncoderError.audio("Audio file not found: \(audioURL.path)")
    }
    if let audioURL = config.audioURL {
      try Self.validateAudio(
        audioURL, start: CMTime(value: config.audioStartUs, timescale: 1_000_000))
    }
    let fm = FileManager.default
    try? fm.createDirectory(
      at: config.outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
    try? fm.removeItem(at: config.outputURL)
    try? fm.removeItem(at: videoURL)

    let writer: AVAssetWriter
    do {
      writer = try AVAssetWriter(outputURL: videoURL, fileType: .mp4)
    } catch {
      throw EncoderError.encoder("Cannot create \(videoURL.path): \(error.localizedDescription)")
    }
    let settings: [String: Any] = [
      AVVideoCodecKey: AVVideoCodecType.h264,
      AVVideoWidthKey: config.width,
      AVVideoHeightKey: config.height,
      AVVideoCompressionPropertiesKey: [
        AVVideoAverageBitRateKey: config.bitRate,
        AVVideoExpectedSourceFrameRateKey: Int(config.fps),
        AVVideoMaxKeyFrameIntervalKey: Int(config.fps),
        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
        AVVideoAllowFrameReorderingKey: false,
      ] as [String: Any],
      AVVideoColorPropertiesKey: [
        AVVideoColorPrimariesKey: AVVideoColorPrimaries_ITU_R_709_2,
        AVVideoTransferFunctionKey: AVVideoTransferFunction_ITU_R_709_2,
        AVVideoYCbCrMatrixKey: AVVideoYCbCrMatrix_ITU_R_709_2,
      ],
    ]
    guard writer.canApply(outputSettings: settings, forMediaType: .video) else {
      throw EncoderError.unsupportedSize(
        "H.264 cannot encode \(config.width)x\(config.height) @ \(config.fps) fps")
    }
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
    input.expectsMediaDataInRealTime = false
    let adaptor = AVAssetWriterInputPixelBufferAdaptor(
      assetWriterInput: input,
      sourcePixelBufferAttributes: [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
        kCVPixelBufferWidthKey as String: config.width,
        kCVPixelBufferHeightKey as String: config.height,
        kCVPixelBufferIOSurfacePropertiesKey as String: [:] as [String: Any],
      ])
    guard writer.canAdd(input) else {
      throw EncoderError.unsupportedSize("AVAssetWriter rejected the video settings")
    }
    writer.add(input)
    guard writer.startWriting() else {
      throw EncoderError.unsupportedSize(
        "Cannot start encoding \(config.width)x\(config.height): "
          + (writer.error?.localizedDescription ?? "unknown error"))
    }
    writer.startSession(atSourceTime: .zero)
    self.writer = writer
    self.input = input
    self.adaptor = adaptor
  }

  private func append(index: Int64, rgba: Data) throws {
    guard let writer = writer, let input = input, let adaptor = adaptor else {
      throw EncoderError.invalidSession("Session \(id) is closed")
    }
    let expected = config.width * config.height * 4
    guard rgba.count == expected else {
      throw EncoderError.encoder("Frame has \(rgba.count) bytes, expected \(expected)")
    }
    // Backpressure: wait (on this background queue) until the encoder can
    // take more data. The Dart future completes only after this returns.
    let deadline = Date().addingTimeInterval(10)
    while !input.isReadyForMoreMediaData {
      if writer.status == .failed { break }
      if Date() > deadline { throw EncoderError.encoder("Encoder stalled for 10 s") }
      usleep(2_000)
    }
    guard writer.status == .writing else {
      throw EncoderError.encoder(
        "Encoder failed: \(writer.error?.localizedDescription ?? "status \(writer.status.rawValue)")")
    }
    guard let pool = adaptor.pixelBufferPool else {
      throw EncoderError.encoder("No pixel buffer pool")
    }
    var pixelBuffer: CVPixelBuffer?
    guard CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBuffer) == kCVReturnSuccess,
      let buffer = pixelBuffer
    else {
      throw EncoderError.encoder("Cannot allocate a pixel buffer")
    }
    try Self.copyRgbaToBgra(rgba, into: buffer, width: config.width, height: config.height)
    let time = CMTime(value: index, timescale: config.fps)
    guard adaptor.append(buffer, withPresentationTime: time) else {
      throw EncoderError.encoder(
        "Appending frame \(index) failed: \(writer.error?.localizedDescription ?? "unknown")")
    }
    framesAppended += 1
  }

  /// Fails fast (before any frame is rendered) when the audio file has no
  /// audio track or `audioStart` lies beyond its end.
  private static func validateAudio(_ url: URL, start: CMTime) throws {
    final class Outcome: @unchecked Sendable { var error: Error? }
    let outcome = Outcome()
    let done = DispatchSemaphore(value: 0)
    Task {
      do {
        let asset = AVURLAsset(url: url)
        if try await asset.loadTracks(withMediaType: .audio).isEmpty {
          throw EncoderError.audio("The audio file contains no audio track")
        }
        if try await asset.load(.duration) <= start {
          throw EncoderError.audio("audioStart is beyond the end of the audio file")
        }
      } catch let error as EncoderError {
        outcome.error = error
      } catch {
        outcome.error = EncoderError.audio("Cannot read audio file: \(error.localizedDescription)")
      }
      done.signal()
    }
    done.wait()
    if let error = outcome.error { throw error }
  }

  /// RGBA → BGRA swizzle straight into the (possibly row-padded) buffer.
  private static func copyRgbaToBgra(_ rgba: Data, into buffer: CVPixelBuffer, width: Int, height: Int)
    throws
  {
    CVPixelBufferLockBaseAddress(buffer, [])
    defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
    guard let base = CVPixelBufferGetBaseAddress(buffer) else {
      throw EncoderError.encoder("Pixel buffer has no base address")
    }
    var dst = vImage_Buffer(
      data: base, height: vImagePixelCount(height), width: vImagePixelCount(width),
      rowBytes: CVPixelBufferGetBytesPerRow(buffer))
    let error: vImage_Error = rgba.withUnsafeBytes { raw in
      var src = vImage_Buffer(
        data: UnsafeMutableRawPointer(mutating: raw.baseAddress!),
        height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: width * 4)
      let map: [UInt8] = [2, 1, 0, 3]  // R G B A -> B G R A
      return vImagePermuteChannels_ARGB8888(&src, &dst, map, vImage_Flags(kvImageNoFlags))
    }
    if error != kvImageNoError { throw EncoderError.encoder("vImage error \(error)") }
  }

  private func release() {
    writer = nil
    input = nil
    adaptor = nil
  }

  /// Stops everything and deletes partial output. Idempotent; never touches
  /// the output of a successfully finished session.
  private func fail() {
    closed = true
    if finished { return }
    if let writer = writer, writer.status == .writing { writer.cancelWriting() }
    release()
    try? FileManager.default.removeItem(at: videoURL)
    try? FileManager.default.removeItem(at: config.outputURL)
  }
}
