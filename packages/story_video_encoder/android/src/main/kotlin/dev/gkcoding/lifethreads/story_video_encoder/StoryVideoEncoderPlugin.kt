package dev.gkcoding.lifethreads.story_video_encoder

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger

/**
 * Method-channel front end. Every session owns its own encoder thread; this
 * class only routes calls to it and posts the results back on the main
 * thread. Nothing heavy ever runs on the platform thread.
 */
class StoryVideoEncoderPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val mainHandler = Handler(Looper.getMainLooper())
    private val sessions = ConcurrentHashMap<Int, VideoEncoderSession>()
    private val nextId = AtomicInteger(1)

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        // The engine is going away: nobody can finish these sessions any more.
        sessions.values.forEach { it.cancel {} }
        sessions.clear()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "start" -> start(call, result)
                "addFrame" -> withSession(call, result) { session ->
                    val index = call.argument<Int>("index")!!
                    val rgba = call.argument<ByteArray>("rgba")!!
                    session.addFrame(index, rgba) { error ->
                        // A failed session has already cleaned up after itself.
                        if (error != null) sessions.remove(session.id)
                        reply(result, error, null)
                    }
                }
                "finish" -> withSession(call, result) { session ->
                    val id = session.id
                    session.finish { error, path ->
                        sessions.remove(id)
                        reply(result, error, path)
                    }
                }
                "cancel" -> withSession(call, result) { session ->
                    sessions.remove(session.id)
                    session.cancel { reply(result, null, null) }
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error(EncoderException.ENCODER_FAILURE, e.message ?: e.toString(), null)
        }
    }

    private fun start(call: MethodCall, result: Result) {
        val config = SessionConfig(
            outputPath = call.argument<String>("outputPath")!!,
            width = call.argument<Int>("width")!!,
            height = call.argument<Int>("height")!!,
            fps = call.argument<Int>("fps")!!,
            bitRate = call.argument<Int>("bitRate")!!,
            audioPath = call.argument<String>("audioPath"),
            audioStartUs = call.argument<Number>("audioStartUs")?.toLong() ?: 0L,
            fadeOutUs = call.argument<Number>("fadeOutUs")?.toLong() ?: 0L,
        )
        val id = nextId.getAndIncrement()
        val session = VideoEncoderSession(id, config)
        sessions[id] = session
        session.start { error ->
            if (error != null) sessions.remove(id)
            reply(result, error, if (error == null) id else null)
        }
    }

    private inline fun withSession(
        call: MethodCall,
        result: Result,
        block: (VideoEncoderSession) -> Unit,
    ) {
        val id = call.argument<Int>("id")
        val session = id?.let { sessions[it] }
        if (session == null) {
            result.error(EncoderException.INVALID_SESSION, "Unknown session $id", null)
            return
        }
        block(session)
    }

    /** Results must be delivered on the platform thread. */
    private fun reply(result: Result, error: Throwable?, value: Any?) {
        mainHandler.post {
            when (error) {
                null -> result.success(value)
                is EncoderException -> result.error(error.code, error.message, null)
                else -> result.error(
                    EncoderException.ENCODER_FAILURE,
                    error.message ?: error.toString(),
                    null,
                )
            }
        }
    }

    companion object {
        const val CHANNEL = "dev.gkcoding.lifethreads/story_video_encoder"
    }
}

/** Error with one of the codes the Dart side maps to typed exceptions. */
class EncoderException(val code: String, message: String, cause: Throwable? = null) :
    Exception(message, cause) {
    companion object {
        const val UNSUPPORTED_SIZE = "unsupported_size"
        const val ENCODER_FAILURE = "encoder_failure"
        const val AUDIO_FAILURE = "audio_failure"
        const val INVALID_SESSION = "invalid_session"
    }
}

data class SessionConfig(
    val outputPath: String,
    val width: Int,
    val height: Int,
    val fps: Int,
    val bitRate: Int,
    val audioPath: String?,
    val audioStartUs: Long,
    val fadeOutUs: Long,
)
