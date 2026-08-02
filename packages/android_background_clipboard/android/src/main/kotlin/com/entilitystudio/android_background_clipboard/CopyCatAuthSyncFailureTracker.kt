package com.entilitystudio.android_background_clipboard

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

class CopyCatAuthSyncFailureTracker(
    private val appContext: Context,
) {
    companion object {
        private const val AUTH_SYNC_NOTIFICATION_CHANNEL_ID = "copycat-auth-sync-issues"
        private const val AUTH_SYNC_NOTIFICATION_ID = 46001
        private const val FAILURE_THRESHOLD = 3
    }

    private var consecutiveFailures: Int = 0
    private var notificationShown: Boolean = false

    fun onAuthFailure() {
        consecutiveFailures += 1
        if (consecutiveFailures >= FAILURE_THRESHOLD && !notificationShown) {
            showNotification()
            notificationShown = true
        }
    }

    fun onSyncSuccess() {
        if (consecutiveFailures == 0 && !notificationShown) {
            return
        }
        consecutiveFailures = 0
        clearNotification()
        notificationShown = false
    }

    private fun showNotification() {
        val notificationManager =
            appContext.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                ?: return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                AUTH_SYNC_NOTIFICATION_CHANNEL_ID,
                "CopyCat Sync Alerts",
                NotificationManager.IMPORTANCE_DEFAULT,
            )
            channel.description = "Alerts when background clipboard sync has auth problems"
            notificationManager.createNotificationChannel(channel)
        }

        val builder = NotificationCompat.Builder(appContext, AUTH_SYNC_NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(R.drawable.tray_icon)
            .setContentTitle("CopyCat sync issue detected")
            .setContentText("Please open CopyCat app to fix the auth issue.")
            .setStyle(
                NotificationCompat.BigTextStyle().bigText(
                    "CopyCat is having trouble syncing clips due to an auth issue. Please open CopyCat app to fix it.",
                ),
            )
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)

        buildOpenAppPendingIntent()?.let { pendingIntent ->
            builder.setContentIntent(pendingIntent)
        }

        notificationManager.notify(AUTH_SYNC_NOTIFICATION_ID, builder.build())
    }

    private fun clearNotification() {
        val notificationManager =
            appContext.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
                ?: return
        notificationManager.cancel(AUTH_SYNC_NOTIFICATION_ID)
    }

    private fun buildOpenAppPendingIntent(): PendingIntent? {
        val launchIntent =
            appContext.packageManager.getLaunchIntentForPackage(appContext.packageName)
                ?: Intent().setClassName(appContext.packageName, "${appContext.packageName}.MainActivity")

        launchIntent.addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP,
        )

        return PendingIntent.getActivity(
            appContext,
            AUTH_SYNC_NOTIFICATION_ID,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }
}