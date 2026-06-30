package com.entilitystudio.CopyCat

import android.view.View
import android.view.ViewGroup
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.android.FlutterView

class MainActivity : FlutterFragmentActivity() {
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