package dev.gkcoding.lifethreads.story_video_encoder

import android.media.AudioFormat
import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMuxer
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * Adds the music track after the video has been encoded.
 *
 * * AAC source, no fade: compressed AAC frames are copied with
 *   MediaExtractor → MediaMuxer, starting at `audioStart` and stopping at the
 *   video duration (AAC frames are ~21 ms, so the cut is frame-accurate
 *   enough). No re-encoding, so this is very fast.
 * * Fade requested (or a non-AAC source such as MP3/WAV): the source is
 *   decoded to PCM, trimmed sample-accurately, multiplied by a linear gain
 *   ramp over the last `fadeOut`, and re-encoded to AAC-LC into a temporary
 *   `.m4a`, which is then copied in as above.
 *
 * In both cases the final MP4 is written by interleaving the (already
 * encoded) video samples with the audio samples by timestamp.
 */
internal object AudioMuxer {
    private const val TIMEOUT_US = 10_000L
    private const val AAC = MediaFormat.MIMETYPE_AUDIO_AAC

    /** Fails fast in `start` when the audio file is missing or has no audio. */
    fun validateSource(path: String, startUs: Long) {
        if (!File(path).isFile) audioError("Audio file not found: $path")
        val extractor = MediaExtractor()
        try {
            extractor.setDataSource(path)
            val format = extractor.getTrackFormat(findAudioTrack(extractor))
            if (format.containsKey(MediaFormat.KEY_DURATION) && startUs >= format.getLong(MediaFormat.KEY_DURATION)) {
                audioError("audioStart is beyond the end of the audio file")
            }
        } catch (e: EncoderException) {
            throw e
        } catch (e: Exception) {
            audioError("Cannot read audio file: ${e.message}", e)
        } finally {
            extractor.release()
        }
    }

    fun deleteTemporaryFiles(outputPath: String) {
        File(fadedPath(outputPath)).delete()
    }

    fun muxWithAudio(
        videoPath: String,
        audioPath: String,
        audioStartUs: Long,
        fadeOutUs: Long,
        durationUs: Long,
        outputPath: String,
    ) {
        val needsTranscode = fadeOutUs > 0 || sourceMime(audioPath) != AAC
        if (!needsTranscode) {
            remux(videoPath, audioPath, audioStartUs, durationUs, outputPath)
            return
        }
        val faded = fadedPath(outputPath)
        try {
            transcodeWithFade(audioPath, audioStartUs, durationUs, fadeOutUs, faded)
            remux(videoPath, faded, 0L, durationUs, outputPath)
        } finally {
            File(faded).delete()
        }
    }

    private fun fadedPath(outputPath: String) = "$outputPath.audio.tmp.m4a"

    private fun sourceMime(path: String): String? {
        val extractor = MediaExtractor()
        try {
            extractor.setDataSource(path)
            return extractor.getTrackFormat(findAudioTrack(extractor)).getString(MediaFormat.KEY_MIME)
        } finally {
            extractor.release()
        }
    }

    private fun findAudioTrack(extractor: MediaExtractor): Int {
        for (i in 0 until extractor.trackCount) {
            val mime = extractor.getTrackFormat(i).getString(MediaFormat.KEY_MIME) ?: continue
            if (mime.startsWith("audio/")) return i
        }
        audioError("The audio file contains no audio track")
    }

    // ---------------------------------------------------------------- remux

    /**
     * Writes [outputPath] = video track of [videoPath] + the AAC track of
     * [audioPath] from [audioStartUs] for at most [durationUs].
     */
    private fun remux(videoPath: String, audioPath: String, audioStartUs: Long, durationUs: Long, outputPath: String) {
        val video = MediaExtractor()
        val audio = MediaExtractor()
        var muxer: MediaMuxer? = null
        var started = false
        try {
            video.setDataSource(videoPath)
            val videoTrack = (0 until video.trackCount).first {
                video.getTrackFormat(it).getString(MediaFormat.KEY_MIME)!!.startsWith("video/")
            }
            video.selectTrack(videoTrack)
            val videoFormat = video.getTrackFormat(videoTrack)

            try {
                audio.setDataSource(audioPath)
            } catch (e: Exception) {
                audioError("Cannot read audio file: ${e.message}", e)
            }
            val audioTrack = findAudioTrack(audio)
            audio.selectTrack(audioTrack)
            val audioFormat = audio.getTrackFormat(audioTrack)
            // One AAC frame = 1024 samples; a frame must end by the video's end.
            val audioFrameUs = 1024L * 1_000_000L / audioFormat.getInteger(MediaFormat.KEY_SAMPLE_RATE)
            if (audioStartUs > 0) audio.seekTo(audioStartUs, MediaExtractor.SEEK_TO_PREVIOUS_SYNC)

            File(outputPath).delete()
            val m = MediaMuxer(outputPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
            muxer = m
            val outVideo = m.addTrack(videoFormat)
            val outAudio = try {
                m.addTrack(audioFormat)
            } catch (e: Exception) {
                audioError("MP4 cannot hold this audio format: ${e.message}", e)
            }
            m.start()
            started = true

            val buffer = ByteBuffer.allocateDirect(maxSampleSize(videoFormat, audioFormat))
            val info = MediaCodec.BufferInfo()
            // Audio timestamps are rebased so the first copied frame is t = 0.
            var audioBaseUs = -1L
            var videoDone = false
            var audioDone = false
            while (!videoDone || !audioDone) {
                val vTime = if (videoDone) Long.MAX_VALUE else video.sampleTime
                if (vTime < 0) { videoDone = true; continue }
                var aTime = Long.MAX_VALUE
                if (!audioDone) {
                    val t = audio.sampleTime
                    if (t < 0) { audioDone = true; continue }
                    if (audioBaseUs < 0) audioBaseUs = maxOf(t, 0L)
                    aTime = t - audioBaseUs
                    if (aTime + audioFrameUs > durationUs) { audioDone = true; continue }
                }
                // Interleave by timestamp so players can stream the file.
                val fromVideo = vTime <= aTime
                val extractor = if (fromVideo) video else audio
                buffer.clear()
                val size = extractor.readSampleData(buffer, 0)
                if (size < 0) {
                    if (fromVideo) videoDone = true else audioDone = true
                    continue
                }
                info.set(0, size, if (fromVideo) vTime else aTime.coerceAtLeast(0L), sampleFlags(extractor))
                m.writeSampleData(if (fromVideo) outVideo else outAudio, buffer, info)
                extractor.advance()
            }
            m.stop()
            started = false
        } catch (e: EncoderException) {
            File(outputPath).delete()
            throw e
        } catch (e: Exception) {
            File(outputPath).delete()
            throw EncoderException(EncoderException.ENCODER_FAILURE, "Muxing failed: ${e.message}", e)
        } finally {
            video.release()
            audio.release()
            try {
                if (started) muxer?.stop()
            } catch (_: Exception) {}
            try { muxer?.release() } catch (_: Exception) {}
        }
    }

    private fun sampleFlags(extractor: MediaExtractor): Int =
        if (extractor.sampleFlags and MediaExtractor.SAMPLE_FLAG_SYNC != 0) MediaCodec.BUFFER_FLAG_KEY_FRAME else 0

    private fun maxSampleSize(vararg formats: MediaFormat): Int {
        var size = 2 * 1024 * 1024 // generous default for 1080p I-frames
        for (f in formats) {
            if (f.containsKey(MediaFormat.KEY_MAX_INPUT_SIZE)) {
                size = maxOf(size, f.getInteger(MediaFormat.KEY_MAX_INPUT_SIZE))
            }
        }
        return size
    }

    // ------------------------------------------------------- transcode + fade

    /**
     * Decodes [audioPath] from [startUs], keeps exactly [durationUs] of PCM,
     * applies a linear fade over the last [fadeOutUs] (0 = no fade) and
     * encodes it as AAC-LC into an `.m4a` at [outPath].
     */
    private fun transcodeWithFade(audioPath: String, startUs: Long, durationUs: Long, fadeOutUs: Long, outPath: String) {
        val extractor = MediaExtractor()
        var decoder: MediaCodec? = null
        var encoder: MediaCodec? = null
        var muxer: MediaMuxer? = null
        var muxerStarted = false
        try {
            extractor.setDataSource(audioPath)
            val track = findAudioTrack(extractor)
            extractor.selectTrack(track)
            val inputFormat = extractor.getTrackFormat(track)
            if (startUs > 0) extractor.seekTo(startUs, MediaExtractor.SEEK_TO_PREVIOUS_SYNC)

            val dec = MediaCodec.createDecoderByType(inputFormat.getString(MediaFormat.KEY_MIME)!!)
            decoder = dec
            dec.configure(inputFormat, null, null, 0)
            dec.start()

            File(outPath).delete()
            val mux = MediaMuxer(outPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
            muxer = mux
            var muxTrack = -1

            var sampleRate = inputFormat.getInteger(MediaFormat.KEY_SAMPLE_RATE)
            var channels = inputFormat.getInteger(MediaFormat.KEY_CHANNEL_COUNT)
            var floatPcm = false
            var totalFrames = 0L // PCM frames to keep (one frame = one sample per channel)
            var fadeFrames = 0L
            var framesWritten = 0L

            val info = MediaCodec.BufferInfo()
            var extractorDone = false
            var decoderDone = false
            var encoderInputDone = false
            var encoderDone = false

            fun ensureEncoder(): MediaCodec {
                encoder?.let { return it }
                totalFrames = durationUs * sampleRate / 1_000_000L
                fadeFrames = fadeOutUs * sampleRate / 1_000_000L
                val format = MediaFormat.createAudioFormat(AAC, sampleRate, channels).apply {
                    setInteger(MediaFormat.KEY_AAC_PROFILE, MediaCodecInfo.CodecProfileLevel.AACObjectLC)
                    setInteger(MediaFormat.KEY_BIT_RATE, if (channels > 1) 192_000 else 128_000)
                    setInteger(MediaFormat.KEY_MAX_INPUT_SIZE, 64 * 1024)
                }
                val enc = MediaCodec.createEncoderByType(AAC)
                enc.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
                enc.start()
                encoder = enc
                return enc
            }

            fun drainEncoder(wait: Boolean) {
                val enc = encoder ?: return
                while (!encoderDone) {
                    val index = enc.dequeueOutputBuffer(info, if (wait) TIMEOUT_US else 0L)
                    when {
                        index == MediaCodec.INFO_TRY_AGAIN_LATER -> if (!wait) return
                        index == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                            muxTrack = mux.addTrack(enc.outputFormat)
                            mux.start()
                            muxerStarted = true
                        }
                        index >= 0 -> {
                            val out = enc.getOutputBuffer(index)!!
                            if (info.flags and MediaCodec.BUFFER_FLAG_CODEC_CONFIG != 0) info.size = 0
                            if (info.size > 0 && muxerStarted) {
                                out.position(info.offset)
                                out.limit(info.offset + info.size)
                                mux.writeSampleData(muxTrack, out, info)
                            }
                            enc.releaseOutputBuffer(index, false)
                            if (info.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0) encoderDone = true
                        }
                    }
                }
            }

            /** Feeds 16-bit interleaved PCM to the encoder, splitting as needed. */
            fun encodePcm(pcm: ByteBuffer) {
                val enc = ensureEncoder()
                while (pcm.hasRemaining()) {
                    val index = enc.dequeueInputBuffer(TIMEOUT_US)
                    if (index < 0) { drainEncoder(wait = false); continue }
                    val input = enc.getInputBuffer(index)!!
                    input.clear()
                    val frameBytes = channels * 2
                    val bytes = minOf(input.remaining(), pcm.remaining()) / frameBytes * frameBytes
                    val slice = pcm.duplicate()
                    slice.limit(pcm.position() + bytes)
                    input.put(slice)
                    pcm.position(pcm.position() + bytes)
                    val ptsUs = framesWritten * 1_000_000L / sampleRate
                    framesWritten += bytes / (channels * 2)
                    enc.queueInputBuffer(index, 0, bytes, ptsUs, 0)
                    drainEncoder(wait = false)
                }
            }

            fun finishEncoder() {
                if (encoderInputDone) return
                val enc = ensureEncoder()
                var index: Int
                do {
                    index = enc.dequeueInputBuffer(TIMEOUT_US)
                    if (index < 0) drainEncoder(wait = false)
                } while (index < 0)
                val ptsUs = framesWritten * 1_000_000L / sampleRate
                enc.queueInputBuffer(index, 0, 0, ptsUs, MediaCodec.BUFFER_FLAG_END_OF_STREAM)
                encoderInputDone = true
            }

            while (!decoderDone) {
                // 1. Compressed source → decoder.
                if (!extractorDone) {
                    val index = dec.dequeueInputBuffer(TIMEOUT_US)
                    if (index >= 0) {
                        val input = dec.getInputBuffer(index)!!
                        val size = extractor.readSampleData(input, 0)
                        val time = extractor.sampleTime
                        // Stop feeding a little after the needed range.
                        if (size < 0 || time - startUs > durationUs + 500_000L) {
                            dec.queueInputBuffer(index, 0, 0, 0, MediaCodec.BUFFER_FLAG_END_OF_STREAM)
                            extractorDone = true
                        } else {
                            dec.queueInputBuffer(index, 0, size, time, 0)
                            extractor.advance()
                        }
                    }
                }
                // 2. Decoder → PCM → trim + fade → encoder.
                val index = dec.dequeueOutputBuffer(info, TIMEOUT_US)
                when {
                    index == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                        val f = dec.outputFormat
                        sampleRate = f.getInteger(MediaFormat.KEY_SAMPLE_RATE)
                        channels = f.getInteger(MediaFormat.KEY_CHANNEL_COUNT)
                        floatPcm = f.containsKey(MediaFormat.KEY_PCM_ENCODING) &&
                            f.getInteger(MediaFormat.KEY_PCM_ENCODING) == AudioFormat.ENCODING_PCM_FLOAT
                    }
                    index >= 0 -> {
                        val eos = info.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0
                        if (info.size > 0 && framesWritten < totalFramesOrUnknown(encoder, totalFrames)) {
                            ensureEncoder()
                            val out = dec.getOutputBuffer(index)!!
                            out.position(info.offset)
                            out.limit(info.offset + info.size)
                            val pcm = shapePcm(
                                source = out.slice().order(ByteOrder.nativeOrder()),
                                floatPcm = floatPcm,
                                channels = channels,
                                bufferStartUs = info.presentationTimeUs,
                                trimStartUs = startUs,
                                sampleRate = sampleRate,
                                firstFrame = framesWritten,
                                totalFrames = totalFrames,
                                fadeFrames = fadeFrames,
                            )
                            encodePcm(pcm)
                        }
                        dec.releaseOutputBuffer(index, false)
                        if (encoder != null && framesWritten >= totalFrames) decoderDone = true
                        if (eos) decoderDone = true
                    }
                }
            }
            if (encoder == null && framesWritten == 0L) audioError("No audio could be decoded from $audioPath")
            finishEncoder()
            drainEncoder(wait = true)
            if (muxerStarted) {
                mux.stop()
                muxerStarted = false
            }
        } catch (e: EncoderException) {
            File(outPath).delete()
            throw e
        } catch (e: Exception) {
            File(outPath).delete()
            audioError("Audio processing failed: ${e.message}", e)
        } finally {
            extractor.release()
            try { decoder?.stop() } catch (_: Exception) {}
            try { decoder?.release() } catch (_: Exception) {}
            try { encoder?.stop() } catch (_: Exception) {}
            try { encoder?.release() } catch (_: Exception) {}
            try { if (muxerStarted) muxer?.stop() } catch (_: Exception) {}
            try { muxer?.release() } catch (_: Exception) {}
        }
    }

    private fun totalFramesOrUnknown(encoder: MediaCodec?, totalFrames: Long) =
        if (encoder == null) Long.MAX_VALUE else totalFrames

    /**
     * Converts one decoded buffer to 16-bit PCM, dropping frames before
     * [trimStartUs] (the seek lands on the preceding sync frame) and after
     * [totalFrames], and applies the fade-out gain.
     */
    private fun shapePcm(
        source: ByteBuffer,
        floatPcm: Boolean,
        channels: Int,
        bufferStartUs: Long,
        trimStartUs: Long,
        sampleRate: Int,
        firstFrame: Long,
        totalFrames: Long,
        fadeFrames: Long,
    ): ByteBuffer {
        val bytesPerSample = if (floatPcm) 4 else 2
        val frameCount = source.remaining() / (bytesPerSample * channels)
        val skip = if (bufferStartUs < trimStartUs) {
            ((trimStartUs - bufferStartUs) * sampleRate / 1_000_000L).coerceAtMost(frameCount.toLong()).toInt()
        } else 0
        val keep = minOf((frameCount - skip).toLong(), totalFrames - firstFrame).coerceAtLeast(0L).toInt()
        val out = ByteBuffer.allocateDirect(keep * channels * 2).order(ByteOrder.nativeOrder())
        val fadeStart = totalFrames - fadeFrames
        for (i in 0 until keep) {
            val frame = firstFrame + i
            val gain = if (fadeFrames > 0 && frame >= fadeStart) {
                (totalFrames - frame).toFloat() / fadeFrames
            } else 1f
            for (c in 0 until channels) {
                val at = ((skip + i) * channels + c) * bytesPerSample
                val sample = if (floatPcm) source.getFloat(at) * 32767f else source.getShort(at).toFloat()
                out.putShort((sample * gain).coerceIn(-32768f, 32767f).toInt().toShort())
            }
        }
        out.flip()
        return out
    }

    private fun audioError(message: String, cause: Throwable? = null): Nothing =
        throw EncoderException(EncoderException.AUDIO_FAILURE, message, cause)
}
