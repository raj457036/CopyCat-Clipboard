package com.entilitystudio.android_background_clipboard

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class NotificationDeleteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        debugLog("NotificationBroadcast") { "Notification dismissed" }
    }
}