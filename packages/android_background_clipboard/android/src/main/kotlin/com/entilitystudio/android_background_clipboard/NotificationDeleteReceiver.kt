package com.entilitystudio.android_background_clipboard

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat


class NotificationDeleteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        debugLog("NotificationBroadcast") { "Notification dismissed, toggling pause state" }

        val serviceIntent = Intent(context, CopyCatClipboardService::class.java)
        serviceIntent.action = CopyCatClipboardService.ACTION_TOGGLE_NOTIFICATION_PAUSE
        ContextCompat.startForegroundService(context, serviceIntent)
    }
}