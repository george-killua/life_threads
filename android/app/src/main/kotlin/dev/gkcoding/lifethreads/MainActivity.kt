package dev.gkcoding.lifethreads

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Hands the home screen widget its memories (see HomeWidgetSync).
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "dev.gkcoding.lifethreads/home_widget",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "containerPath" ->
                    result.success(LifeThreadsWidgetProvider.folder(this).absolutePath)
                "update" -> {
                    val payload = call.argument<String>("payload")
                    if (payload == null) {
                        result.error("bad_arguments", null, null)
                    } else {
                        LifeThreadsWidgetProvider.savePayload(this, payload)
                        LifeThreadsWidgetProvider.refreshAll(this)
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
