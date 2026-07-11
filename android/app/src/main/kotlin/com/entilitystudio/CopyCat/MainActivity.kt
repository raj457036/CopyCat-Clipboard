package com.entilitystudio.CopyCat

import android.view.View
import android.view.ViewGroup
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    private val dragFileUriChannelName = "com.entilitystudio.CopyCat/drag_file_uri"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, dragFileUriChannelName)
            .setMethodCallHandler { call, result ->
                if (call.method != "getContentUriForPath") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }

                val rawPath = call.argument<String>("path")?.trim().orEmpty()
                if (rawPath.isEmpty()) {
                    result.error("invalid_args", "Path is empty", null)
                    return@setMethodCallHandler
                }

                runCatching {
                    val file = File(rawPath)
                    if (!file.exists()) {
                        throw IllegalArgumentException("File does not exist")
                    }

                    FileProvider.getUriForFile(
                        this,
                        "${applicationContext.packageName}.fileProvider",
                        file,
                    ).toString()
                }.onSuccess { uriString ->
                    result.success(uriString)
                }.onFailure { error ->
                    result.error("uri_generation_failed", error.message, null)
                }
            }
    }

    override fun onPostResume() {
        super.onPostResume()

        val view = findViewById<View>(android.R.id.content) as? ViewGroup
        if (view != null) {
            val flutterView = findFlutterView(view)
            if (flutterView != null) {
                flutterView.id = FlutterActivity.FLUTTER_VIEW_ID
            }
        }
    }

    private fun findFlutterView(view: ViewGroup): FlutterView? {
        for (i in 0 until view.childCount) {
            val child = view.getChildAt(i)
            if (child is FlutterView) {
                return child
            } else if (child is ViewGroup) {
                val result = findFlutterView(child)
                if (result != null) return result
            }
        }
        return null
    }
}