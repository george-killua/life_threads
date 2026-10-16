package dev.gkcoding.lifethreads

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * The home screen widget: a memory from the wall, a different one each day.
 * The app writes the next days and small photo copies (see `HomeWidgetSync`
 * in the Flutter code); the widget picks today's on every update.
 */
class LifeThreadsWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, views(context, id))
        }
    }

    companion object {
        private const val PREFERENCES = "lifethreads_home_widget"
        private const val PAYLOAD_KEY = "payload"
        private const val MAX_SIDE = 720

        fun folder(context: Context): File =
            File(context.filesDir, "home_widget").apply { mkdirs() }

        fun savePayload(context: Context, payload: String) {
            context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
                .edit()
                .putString(PAYLOAD_KEY, payload)
                .apply()
        }

        /** Redraws every LifeThreads widget on the home screen. */
        fun refreshAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, LifeThreadsWidgetProvider::class.java),
            )
            for (id in ids) {
                manager.updateAppWidget(id, views(context, id))
            }
        }

        private fun views(context: Context, widgetId: Int): RemoteViews {
            val views = RemoteViews(context.packageName, R.layout.lifethreads_widget)
            val payload = payload(context)
            val day = payload?.let { today(it) }
            val isEmpty = day?.optStringOrNull("kind") == "empty"
            views.setTextViewText(
                R.id.widget_subtitle,
                day?.optString("subtitle")
                    ?: context.getString(R.string.widget_placeholder_subtitle),
            )
            views.setTextViewText(
                R.id.widget_title,
                day?.optString("title")
                    ?: context.getString(R.string.widget_placeholder_title),
            )

            val image = day?.optStringOrNull("image")
                ?.let { File(folder(context), it) }
                ?.takeIf { it.exists() }
                ?.let { decode(it) }
            if (image != null) {
                views.setImageViewBitmap(R.id.widget_image, image)
                views.setViewVisibility(R.id.widget_image, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_image, View.GONE)
            }

            val memoryId = day?.optStringOrNull("memoryId")
            val link = when {
                isEmpty -> ADD_LINK
                memoryId != null -> "lifethreads://memory/${Uri.encode(memoryId)}"
                else -> "lifethreads://wall"
            }
            views.setOnClickPendingIntent(R.id.widget_root, open(context, widgetId * 3, link))

            // No memory yet: buttons to add the first one.
            if (isEmpty) {
                views.setViewVisibility(R.id.widget_actions, View.VISIBLE)
                views.setTextViewText(
                    R.id.widget_add,
                    "+ " + (payload?.optStringOrNull("addLabel") ?: "Add a memory"),
                )
                views.setTextViewText(
                    R.id.widget_photo,
                    payload?.optStringOrNull("photoLabel") ?: "Take photo",
                )
                views.setOnClickPendingIntent(R.id.widget_add, open(context, widgetId * 3 + 1, ADD_LINK))
                views.setOnClickPendingIntent(
                    R.id.widget_photo,
                    open(context, widgetId * 3 + 2, "$ADD_LINK?camera=1"),
                )
            } else {
                views.setViewVisibility(R.id.widget_actions, View.GONE)
            }
            return views
        }

        private const val ADD_LINK = "lifethreads://add"

        /** Opens the app at [link]; [requestCode] keeps the intents apart. */
        private fun open(context: Context, requestCode: Int, link: String): PendingIntent {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(link), context, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            return PendingIntent.getActivity(
                context,
                requestCode,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        private fun payload(context: Context): JSONObject? {
            val raw = context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
                .getString(PAYLOAD_KEY, null) ?: return null
            return try {
                JSONObject(raw)
            } catch (_: Exception) {
                null
            }
        }

        /** Today's entry, else the latest earlier one, else the first. */
        private fun today(payload: JSONObject): JSONObject? {
            val days = payload.optJSONArray("days") ?: return null
            if (days.length() == 0) return null
            val key = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
            var earlier: JSONObject? = null
            for (index in 0 until days.length()) {
                val day = days.getJSONObject(index)
                val date = day.optStringOrNull("date") ?: continue
                if (date == key) return day
                if (date < key) earlier = day
            }
            return earlier ?: days.getJSONObject(0)
        }

        /** The photo at most [MAX_SIDE] pixels on its longer side. */
        private fun decode(file: File): Bitmap? {
            val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
            BitmapFactory.decodeFile(file.path, bounds)
            var sample = 1
            while (bounds.outWidth / (sample * 2) >= MAX_SIDE ||
                bounds.outHeight / (sample * 2) >= MAX_SIDE
            ) {
                sample *= 2
            }
            return BitmapFactory.decodeFile(
                file.path,
                BitmapFactory.Options().apply { inSampleSize = sample },
            )
        }

        private fun JSONObject.optStringOrNull(name: String): String? =
            if (isNull(name)) null else optString(name).takeIf { it.isNotEmpty() }
    }
}
