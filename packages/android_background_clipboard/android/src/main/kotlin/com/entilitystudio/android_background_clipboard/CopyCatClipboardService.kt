package com.entilitystudio.android_background_clipboard

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.ClipDescription
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Binder
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.PowerManager
import android.os.SystemClock
import android.util.Log
import android.view.textclassifier.TextClassifier
import android.view.textclassifier.TextLinks
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.InputStream

enum class ClipAction {
    Pending,
    PartialSuccess,
    Excluded,
    Success,
    Duplicate,
    Failed,
}

class CopyCatClipboardService : Service() {
    private lateinit var clipboardManager: ClipboardManager
    private lateinit var notificationManager: NotificationManager
    lateinit var copycatStorage: CopyCatSharedStorage
    private val notificationId: Int = 1
    private lateinit var notificationBuilder: NotificationCompat.Builder
    private var lastCopiedText: String? = null
    private var lastClipFingerprint: String? = null
    private var lastClipCapturedAtMs: Long = 0L
    private val mainHandler by lazy { Handler(mainLooper) }
    private val pasteActionDelayMs = 1000L
    private val delayedPasteRunnable = Runnable {
        disableDuplicateAnnouncement = true
        performClipboardRead("")
    }
    
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    private val nChannelId = "copycat-notification-channel"
    private val logTag = "CopyCatClipboardService"
    private val binder = LocalBinder()
    private var resumedActivityCount = 0

    private val appLifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) = Unit

        override fun onActivityStarted(activity: Activity) = Unit

        override fun onActivityResumed(activity: Activity) {
            resumedActivityCount += 1
        }

        override fun onActivityPaused(activity: Activity) {
            resumedActivityCount = (resumedActivityCount - 1).coerceAtLeast(0)
        }

        override fun onActivityStopped(activity: Activity) = Unit

        override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) = Unit

        override fun onActivityDestroyed(activity: Activity) = Unit
    }

    // Disable duplicate announcement for one read cycle
    var disableDuplicateAnnouncement: Boolean = false

    private val ackToastEnable: Boolean
        get() = copycatStorage.showAckToast

    inner class LocalBinder : Binder() {
        fun getService(): CopyCatClipboardService = this@CopyCatClipboardService
    }

    companion object {
        var isRunning: Boolean = false
    }

    private fun isHostAppForeground(): Boolean = resumedActivityCount > 0

    private fun isScreenOn(): Boolean {
        val pm = getSystemService(Context.POWER_SERVICE) as? PowerManager
        return pm?.isInteractive ?: true
    }

    private fun redactForLog(value: String?): String {
        if (value.isNullOrEmpty()) return ""
        return if (value.length <= 2) {
            "${value}***"
        } else {
            "${value.take(2)}***"
        }
    }

    fun performClipboardRead(appPackageName: String) {
        performClipboardReadFromClipData(clipboardManager.primaryClip, appPackageName)
    }

    fun writeToClipboard(data: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Mark this as already handled so listener does not re-capture and re-sync it.
            markCaptured(buildClipFingerprint(data, ClipType.Text))
            lastCopiedText = data
            val clip = ClipData.newPlainText("CopyCat", data)
            clipboardManager.setPrimaryClip(clip)
        }
    }

    private fun buildClipFingerprint(text: String, type: ClipType): String {
        return "$type::$text"
    }

    private fun markCaptured(fingerprint: String) {
        lastClipFingerprint = fingerprint
        lastClipCapturedAtMs = SystemClock.elapsedRealtime()
    }

    private fun isDuplicateBurst(fingerprint: String): Boolean {
        val now = SystemClock.elapsedRealtime()
        val duplicateWindowMs = when (copycatStorage.detectionMode) {
            ClipboardDetectionMode.MODE_1_ACK_TEXT -> 900L
            ClipboardDetectionMode.MODE_2_AGGRESSIVE -> 1800L
            ClipboardDetectionMode.MODE_3_SEQUENCE -> 1300L
            ClipboardDetectionMode.MODE_4_OVERLAY -> 700L
        }

        return lastClipFingerprint == fingerprint &&
            now - lastClipCapturedAtMs < duplicateWindowMs
    }

    fun performClipboardReadFromClipData(clipData: ClipData?, appPackageName: String) {
        if (!isScreenOn()) {
            Log.d(logTag, "Clipboard capture paused: screen is off")
            return
        }
        Log.d(logTag, "Current Package: $appPackageName")
        Log.d(logTag, "Current Exclusions: ${copycatStorage.excludedPackages}")
        if (!copycatStorage.serviceEnabled) {
            Log.w(logTag, "Service not configured")
            return
        }
        val excluded =
            (copycatStorage.excludePasswordManagers && copycatStorage.passwordManagers.contains(
                appPackageName
            )) || copycatStorage.excludedPackages.contains(appPackageName)
        if (excluded) {
            Log.i(logTag, "$appPackageName is excluded by exclusion rules.")
            if (!disableDuplicateAnnouncement) {
                showAck("Clip Excluded!")
            }
            return
        }

        readClipboard(clipData)
    }

    private fun readUriClip(uri: Uri, label: String? = null): ClipAction {
        return when (uri.scheme) {
            "content" -> {
                // Media or File!
                try {
                    contentResolver.openInputStream(uri)?.use { _ ->
                        // Process the stream if needed
                    }
                    ClipAction.Success
                } catch (e: Exception) {
                    Log.e(logTag, "Failed to read URI clip: ${e.message}")
                    ClipAction.Failed
                }
            }

            else -> {
                writeTextToCopyCatClipboard(uri.toString(), ClipType.Url, label)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.R)
    private fun readTextLinks(tls: TextLinks, label: String? = null): ClipAction {

        val text = tls.text
        for (link in tls.links) {
            if (link.getConfidenceScore(TextClassifier.TYPE_URL) == 1.0f) {
                val url = text.substring(link.start, link.end)
                if (url.startsWith("http://") || url.startsWith("https://")) {
                    Log.d(logTag, "Clipboard Link: ${redactForLog(url)}")
                    return writeTextToCopyCatClipboard(url, ClipType.Url, label)
                }
            }
            if (link.getConfidenceScore(TextClassifier.TYPE_EMAIL) == 1.0f) {
                if (copycatStorage.excludeEmail) return ClipAction.Excluded

                val email = text.substring(link.start, link.end)
                Log.d(logTag, "Clipboard Email: ${redactForLog(email)}")
                return writeTextToCopyCatClipboard(email, ClipType.Email, label)
            }
            if (link.getConfidenceScore(TextClassifier.TYPE_PHONE) == 1.0f) {
                if (copycatStorage.excludePhone) return ClipAction.Excluded

                val phone = text.substring(link.start, link.end)
                Log.d(logTag, "Clipboard Phone: ${redactForLog(phone)}")
                return writeTextToCopyCatClipboard(phone, ClipType.Phone, label)
            }
        }
        return ClipAction.Pending
    }


    private fun writeTextToCopyCatClipboard(
        text: String,
        type: ClipType,
        label: String? = null
    ): ClipAction {
        val fingerprint = buildClipFingerprint(text, type)
        if (isDuplicateBurst(fingerprint)) {
            Log.d(logTag, "Detected duplicate item")
            return ClipAction.Duplicate
        }

        markCaptured(fingerprint)
        lastCopiedText = text
        copycatStorage.writeTextClip(text, type, label ?: "")
        disableDuplicateAnnouncement = false
        return ClipAction.Success
    }

    private fun readClipboard(clipData: ClipData?) {
        serviceScope.launch(Dispatchers.IO) {
            var actionStatus: ClipAction = ClipAction.Pending

            if (clipData != null && clipData.itemCount > 0) {
                val clipLabel = clipData.description?.label?.toString()
                Log.d(logTag, "Description Label: $clipLabel")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    Log.d(logTag, "Description Extras: ${clipData.description?.extras}")
                }
                val item = clipData.getItemAt(0)

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    item.textLinks?.let {
                        val result = readTextLinks(it, clipLabel)
                        actionStatus =
                            if (result == ClipAction.Success && it.text.length == lastCopiedText?.length) {
                                result
                            } else if (result == ClipAction.Excluded) {
                                ClipAction.Excluded
                            } else {
                                ClipAction.PartialSuccess
                            }
                    }
                }

                if (actionStatus != ClipAction.Excluded) {
                    if (actionStatus != ClipAction.Success)
                        item.text?.let {
                            Log.d(logTag, "Clipboard Text: ${redactForLog(it.toString())}")
                            actionStatus =
                                writeTextToCopyCatClipboard(it.toString(), ClipType.Text, clipLabel)
                        }

                    if (actionStatus != ClipAction.Success)
                        item.uri?.let {
                            Log.d(logTag, "Clipboard URI: $it")
                            actionStatus = readUriClip(it, clipLabel)
                        }
                }
            }

            withContext(Dispatchers.Main) {
                Log.d(logTag, "Clip Action: $actionStatus")
                Log.d(logTag, "Clip Content: ${redactForLog(lastCopiedText)}")
                when (actionStatus) {
                    ClipAction.Duplicate -> {
                        if (!disableDuplicateAnnouncement) {
                            showAck("Detected duplicate item")
                        }
                    }
                    ClipAction.Failed -> showAck("CopyCat failed to capture clipboard")
                    ClipAction.Excluded -> {
                        if (!disableDuplicateAnnouncement) {
                            showAck("Clip Excluded!")
                        }
                    }
                    ClipAction.Success -> {
                        if (!disableDuplicateAnnouncement) {
                            showAck("Clip Captured!")
                        }
                    }
                    else -> {}
                }
            }
        }

    }

    private fun showAck(text: String) {
        if (!ackToastEnable) return
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                nChannelId,
                "CopyCat Notification Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun prepareNotification() {
        notificationBuilder = NotificationCompat.Builder(this, nChannelId)
            .setSmallIcon(R.drawable.tray_icon)
            .setOngoing(true) // Makes the notification non-dismissible
    }

    @SuppressLint("LaunchActivityFromNotification")
    private fun showNotification(): Notification {
        val pasteIntent = Intent(this, this::class.java).apply {
            action = "PASTE_ACTION"
        }

        val pendingPasteIntent = PendingIntent.getService(
            this,
            790,
            pasteIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )


        val deleteIntent = Intent(this, NotificationDeleteReceiver::class.java)
        val pendingDeleteIntent = PendingIntent.getBroadcast(
            this,
            788,
            deleteIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return notificationBuilder
            .setDeleteIntent(pendingDeleteIntent)
            .setContentTitle("CopyCat Clipboard")
            .setContentText("Tap to Capture • Swipe to Restart")
            .setContentIntent(pendingPasteIntent)
            .setOngoing(true)
            .setAutoCancel(false)
            .build()
    }

    private val onClipChangeListener = ClipboardManager.OnPrimaryClipChangedListener {
        if (!isScreenOn()) {
            Log.d(logTag, "Primary Clipboard capture paused: screen is off")
            return@OnPrimaryClipChangedListener
        }
        if (isHostAppForeground()) {
            Log.d(logTag, "Primary Clipboard capture paused: app is in foreground.")
            return@OnPrimaryClipChangedListener
        }
        if (Utils.isActivityOnTop) {
            Log.d(logTag, "Primary Clipboard disabled! Because top activity is CopyCat itself.")
            return@OnPrimaryClipChangedListener
        }
        Log.d(logTag, "Reading Primary Clipboard")
        readClipboard(clipboardManager.primaryClip)
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun setupClipboardManager() {
        clipboardManager.addPrimaryClipChangedListener(onClipChangeListener)
    }

    private fun prepareAndShowNotification() {
        createNotificationChannel()
        prepareNotification()
        
        // Handle Android 14+ foreground service type requirements
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                // Android 14+ (API 34+): Use FOREGROUND_SERVICE_TYPE_SPECIAL_USE
                startForeground(
                    notificationId, 
                    showNotification(), 
                    android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Android 10+ (API 29+): Use FOREGROUND_SERVICE_TYPE_DATA_SYNC
                startForeground(
                    notificationId, 
                    showNotification(), 
                    android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
                )
            } else {
                // Pre-Android 10: No service type needed
                startForeground(notificationId, showNotification())
            }
        } catch (e: Exception) {
            Log.e(logTag, "Failed to start foreground service with specific type: ${e.message}")
            // Fallback: try without service type
            try {
                startForeground(notificationId, showNotification())
            } catch (ex: Exception) {
                Log.e(logTag, "Failed to start foreground service: ${ex.message}", ex)
                // If we can't start as foreground, stop the service
                stopSelf()
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        application.registerActivityLifecycleCallbacks(appLifecycleCallbacks)
        copycatStorage = CopyCatSharedStorage.getInstance(this)
        clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        copycatStorage.start()
        copycatStorage.setRemoteClipApplier { content ->
            mainHandler.post {
                disableDuplicateAnnouncement = true
                writeToClipboard(content)
            }
        }
        prepareAndShowNotification()
        isRunning = true
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            setupClipboardManager()
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Ensure notification is shown if service was restarted
        if (!isRunning) {
            try {
                prepareAndShowNotification()
                isRunning = true
            } catch (e: Exception) {
                Log.e(logTag, "Failed to show notification on restart: ${e.message}", e)
                stopSelf()
                return START_NOT_STICKY
            }
        }
        
        when (intent?.action) {
            "RESTART_SERVICE" -> {
                Log.d(logTag, "Service restart requested")
                // Just ensure notification is showing, don't call onCreate
                prepareAndShowNotification()
                if (!isRunning) {
                    isRunning = true
                }
            }
            "PASTE_ACTION" -> {
                        mainHandler.removeCallbacks(delayedPasteRunnable)
                        mainHandler.postDelayed(delayedPasteRunnable, pasteActionDelayMs)
            }
        }
        return START_STICKY
    }

    override fun onBind(p0: Intent?): IBinder = binder

    override fun onDestroy() {
        // Cancel all coroutines
        serviceScope.cancel()
        mainHandler.removeCallbacksAndMessages(null)
        application.unregisterActivityLifecycleCallbacks(appLifecycleCallbacks)
        
        clipboardManager.removePrimaryClipChangedListener(onClipChangeListener)
        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
        Log.d(logTag, "CopyCatClipboardService Destroyed")
        showAck("CopyCat Clipboard Stopped")
        isRunning = false
        copycatStorage.clean()
        
        // Clear references to prevent memory leaks
        lastCopiedText = null
        lastClipFingerprint = null
        lastClipCapturedAtMs = 0L
        
        super.onDestroy()
    }

}