package com.entilitystudio.android_background_clipboard

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

class NotificationDeleteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        debugLog("NotificationBroadcast") { "Notification dismissed" }

        val serviceIntent = Intent(context, CopyCatClipboardService::class.java).apply {
            action = CopyCatClipboardService.ACTION_RESHOW_NOTIFICATION
        }

        ContextCompat.startForegroundService(context, serviceIntent)
    }
}