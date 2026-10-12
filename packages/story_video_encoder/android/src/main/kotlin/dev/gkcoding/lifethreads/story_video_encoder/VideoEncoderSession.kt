package dev.gkcoding.lifethreads.story_video_encoder

import android.media.MediaCodec
import android.media.MediaCodecInfo
import android.media.MediaCodecList
import android.media.MediaFormat
import android.media.MediaMuxer
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import java.io.File
import java.nio.ByteBuffer

/**
 * One MP4 being encoded, driven from a dedicated [HandlerThread].
 *
 * Pipeline: RGBA bytes → GL texture → full-screen quad drawn onto the
 * MediaCodec input Surface (EGL) → H.264 → MediaMuxer.
 *
 * Why an input Surface instead of YUV input buffers: the GPU does the
 * RGB→YUV conversion in the colour format the vendor encoder actually wants
 * (YUV input layouts differ per chipset and stride/alignment bugs are common),
 * and `eglPresentationTimeANDROID` gives every frame an exact timestamp of
 * `index / fps`, independent of how long the Flutter side took to render it.
 *
 * Every public method may be called from any thread; work is serialised on
 * the session thread and the callback is invoked from that thread.
 */
class VideoEncoderSession(val id: Int, private val config: SessionConfig) {
    private val thread = HandlerThread("StoryVideoEncoder-$id").apply { start() }
    private val handler = Handler(thread.looper)

    private var codec: MediaCodec? = null
    private var muxer: MediaMuxer? = null
    private var egl: EglSurfaceRenderer? = null
    private var trackIndex = -1
    private var muxerStarted = false
    private var framesEncoded = 0
    private var closed = false
    private val bufferInfo = MediaCodec.BufferInfo()

    /** With audio we first write a video-only file and remux it at the end. */
    private val videoPath: String =
        if (config.audioPath != null) config.outputPath + ".video.tmp.mp4" else config.outputPath

    fun start(done: (Throwable?) -> Unit) = run(done) {
        if (config.audioPath != null) AudioMuxer.validateSource(config.audioPath, config.audioStartUs)
        File(config.outputPath).absoluteFile.parentFile?.mkdirs()
        File(config.outputPath).delete()
        File(videoPath).delete()

        val format = MediaFormat.createVideoFormat(MIME, config.width, config.height).apply {
            setInteger(MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface)
            setInteger(MediaFormat.KEY_BIT_RATE, config.bitRate)
            setInteger(MediaFormat.KEY_FRAME_RATE, config.fps)
            setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
            // Tag as SDR BT.709 limited range so players don't guess.
            setInteger(MediaFormat.KEY_COLOR_STANDARD, MediaFormat.COLOR_STANDARD_BT709)
            setInteger(MediaFormat.KEY_COLOR_RANGE, MediaFormat.COLOR_RANGE_LIMITED)
            setInteger(MediaFormat.KEY_COLOR_TRANSFER, MediaFormat.COLOR_TRANSFER_SDR_VIDEO)
        }
        val codecName = MediaCodecList(MediaCodecList.REGULAR_CODECS).findEncoderForFormat(format)
            ?: throw EncoderException(
                EncoderException.UNSUPPORTED_SIZE,
                "No H.264 encoder supports ${config.width}x${config.height} @ ${config.fps} fps",
            )
        val c = MediaCodec.createByCodecName(codecName)
        codec = c
        // Prefer High profile (better quality per bit) when the encoder
        // advertises it; some encoders reject it at configure time, so fall
        // back to the codec's default (usually Baseline) in that case.
        val high = c.codecInfo.getCapabilitiesForType(MIME).profileLevels
            .firstOrNull { it.profile == MediaCodecInfo.CodecProfileLevel.AVCProfileHigh }
        var configured = false
        if (high != null) {
            try {
                c.configure(
                    MediaFormat(format).apply {
                        setInteger(MediaFormat.KEY_PROFILE, high.profile)
                        setInteger(MediaFormat.KEY_LEVEL, high.level)
                    },
                    null, null, MediaCodec.CONFIGURE_FLAG_ENCODE,
                )
                configured = true
            } catch (e: Exception) {
                Log.w(TAG, "$codecName rejected High profile, using default", e)
                c.reset()
            }
        }
        if (!configured) {
            try {
                c.configure(format, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
            } catch (e: Exception) {
                throw EncoderException(
                    EncoderException.UNSUPPORTED_SIZE,
                    "$codecName rejected ${config.width}x${config.height}: ${e.message}",
                    e,
                )
            }
        }
        egl = EglSurfaceRenderer(c.createInputSurface(), config.width, config.height)
        c.start()
        muxer = MediaMuxer(videoPath, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
        Log.d(TAG, "session $id: $codecName ${config.width}x${config.height}@${config.fps}")
    }

    fun addFrame(index: Int, rgba: ByteArray, done: (Throwable?) -> Unit) = run(done) {
        val renderer = egl ?: throw closedError()
        if (rgba.size != config.width * config.height * 4) {
            throw EncoderException(EncoderException.ENCODER_FAILURE, "Frame has ${rgba.size} bytes")
        }
        // Timestamp purely from the frame index: frame i is shown at i/fps.
        val ptsNs = index.toLong() * 1_000_000_000L / config.fps
        renderer.drawFrame(ByteBuffer.wrap(rgba), ptsNs)
        framesEncoded++
        // Keep the encoder flowing so eglSwapBuffers never blocks on a full queue.
        drainEncoder(endOfStream = false)
    }

    fun finish(done: (Throwable?, String?) -> Unit) {
        post({ done(closedError(), null) }) {
            try {
                if (closed) throw closedError()
                if (framesEncoded == 0) {
                    throw EncoderException(EncoderException.ENCODER_FAILURE, "No frames were added")
                }
                drainEncoder(endOfStream = true)
                releaseEncoder(stopMuxer = true)
                if (config.audioPath != null) {
                    val videoDurationUs = framesEncoded.toLong() * 1_000_000L / config.fps
                    AudioMuxer.muxWithAudio(
                        videoPath = videoPath,
                        audioPath = config.audioPath,
                        audioStartUs = config.audioStartUs,
                        fadeOutUs = config.fadeOutUs,
                        durationUs = videoDurationUs,
                        outputPath = config.outputPath,
                    )
                    File(videoPath).delete()
                }
                closed = true
                quit()
                done(null, config.outputPath)
            } catch (e: Throwable) {
                Log.e(TAG, "finish failed", e)
                fail()
                done(e, null)
            }
        }
    }

    fun cancel(done: () -> Unit) {
        post(done) {
            fail()
            done()
        }
    }

    /** Runs [block] on the session thread; on error releases everything. */
    private fun run(done: (Throwable?) -> Unit, block: () -> Unit) {
        post({ done(closedError()) }) {
            try {
                if (closed) throw closedError()
                block()
                done(null)
            } catch (e: Throwable) {
                Log.e(TAG, "session $id failed", e)
                fail()
                done(
                    if (e is EncoderException) e
                    else EncoderException(EncoderException.ENCODER_FAILURE, e.message ?: e.toString(), e),
                )
            }
        }
    }

    /**
     * Posts [block] to the session thread. Once the thread has quit (session
     * finished, failed or cancelled) posting fails and [ifClosed] runs on the
     * caller's thread instead, so no Dart future is ever left hanging.
     */
    private fun post(ifClosed: () -> Unit, block: () -> Unit) {
        if (!handler.post(block)) ifClosed()
    }

    private fun closedError() = EncoderException(EncoderException.INVALID_SESSION, "Session $id is closed")

    private fun drainEncoder(endOfStream: Boolean) {
        val c = codec ?: return
        if (endOfStream) c.signalEndOfInputStream()
        var idleSpins = 0
        while (true) {
            val index = c.dequeueOutputBuffer(bufferInfo, if (endOfStream) 10_000L else 0L)
            when {
                index == MediaCodec.INFO_TRY_AGAIN_LATER -> {
                    if (!endOfStream) return
                    // ~5 s without output after EOS means the codec is stuck.
                    if (++idleSpins > 500) {
                        throw EncoderException(EncoderException.ENCODER_FAILURE, "Encoder did not reach end of stream")
                    }
                }
                index == MediaCodec.INFO_OUTPUT_FORMAT_CHANGED -> {
                    check(!muxerStarted) { "Output format changed twice" }
                    val m = muxer!!
                    trackIndex = m.addTrack(c.outputFormat)
                    m.start()
                    muxerStarted = true
                }
                index >= 0 -> {
                    val buffer = c.getOutputBuffer(index)!!
                    if (bufferInfo.flags and MediaCodec.BUFFER_FLAG_CODEC_CONFIG != 0) {
                        // SPS/PPS already travel in the output format (csd-0/1).
                        bufferInfo.size = 0
                    }
                    if (bufferInfo.size > 0 && muxerStarted) {
                        buffer.position(bufferInfo.offset)
                        buffer.limit(bufferInfo.offset + bufferInfo.size)
                        muxer!!.writeSampleData(trackIndex, buffer, bufferInfo)
                    }
                    c.releaseOutputBuffer(index, false)
                    if (bufferInfo.flags and MediaCodec.BUFFER_FLAG_END_OF_STREAM != 0) return
                    idleSpins = 0
                }
            }
        }
    }

    private fun releaseEncoder(stopMuxer: Boolean) {
        try { codec?.stop() } catch (_: Exception) {}
        try { codec?.release() } catch (_: Exception) {}
        codec = null
        try { egl?.release() } catch (_: Exception) {}
        egl = null
        try {
            if (stopMuxer && muxerStarted) muxer?.stop()
        } finally {
            try { muxer?.release() } catch (_: Exception) {}
            muxer = null
            muxerStarted = false
        }
    }

    /** Releases everything and deletes partial output. Idempotent. */
    private fun fail() {
        if (!closed) {
            closed = true
            try { releaseEncoder(stopMuxer = false) } catch (_: Exception) {}
            File(videoPath).delete()
            File(config.outputPath).delete()
            AudioMuxer.deleteTemporaryFiles(config.outputPath)
        }
        quit()
    }

    private fun quit() {
        thread.quitSafely()
    }

    companion object {
        private const val TAG = "StoryVideoEncoder"
        private const val MIME = MediaFormat.MIMETYPE_VIDEO_AVC
    }
}
