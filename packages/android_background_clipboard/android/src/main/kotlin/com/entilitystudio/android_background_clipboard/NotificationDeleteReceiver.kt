package com.entilitystudio.android_background_clipboard

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi


class NotificationDeleteReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("NotificationBroadcast", "Notification swiped away, restarting service")

        // Restart the service and show the notification again
        val serviceIntent = Intent(context, CopyCatClipboardService::class.java)
        serviceIntent.action = "RESTART_SERVICE"
        context.startForegroundService(serviceIntent)
    }
}