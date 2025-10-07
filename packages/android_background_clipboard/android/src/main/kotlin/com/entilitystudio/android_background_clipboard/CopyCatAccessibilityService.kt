package com.entilitystudio.android_background_clipboard

import android.accessibilityservice.AccessibilityService
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.widget.Toast


const val DetectionText = "CopyCat"

class CopyCatAccessibilityService : AccessibilityService() {
    private val logTag = "CopyCatAccService"
    private var detectingCopyAck: Boolean = false
    private var notificationAckText: String = "[Copied]"
    private var isClipboardServiceConnected: Boolean = false
    private var currentlyActiveApp: String = ""
    private val handler = Handler(Looper.getMainLooper())
    private val copyRunnable = Runnable {
        val currentTimestamp = System.currentTimeMillis()
        if (currentTimestamp - lastCopiedTimestamp > 400 && isScreenOn()) {
            onCopyEvent(true)
        } else {
            Log.d(logTag, "Skipped onCopyEvent: Screen OFF or duplicate")
        }
    }
    private var lastCopiedTimestamp: Long = 0;

    private val strictCheck: Boolean
        get() = clipboardService?.copycatStorage?.strictCheck == true



    private var clipboardService: CopyCatClipboardService? = null

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
            Log.d(logTag, "OnServiceConnected $name")
            clipboardService = (binder as CopyCatClipboardService.LocalBinder).getService()
            isClipboardServiceConnected = true

            // Safe to do ack detection later
            handler.postDelayed({
                if (isClipboardServiceConnected) {
                    detectCopyAck()
                }
            }, 1500)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.d(logTag, "OnServiceDisconnected $name")
            isClipboardServiceConnected = false
            restartClipboardService()
        }
    }

    private fun isScreenOn(): Boolean {
        val pm = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
        return pm.isInteractive
    }

    // Method to restart the clipboard service if it's disconnected
    private fun restartClipboardService() {
        Log.d(logTag, "Attempting to restart the clipboard service")
        startClipboardService() // Re-start the service
    }

    private fun onCopyEvent(disableDuplicateAnnouncements: Boolean = false) {
        Log.d(logTag, "Copy Event Detected, Reading Clipboard")

        if (!isClipboardServiceConnected) {
            Log.w(logTag, "ClipboardService not connected yet, ignoring onCopyEvent")
            return
        }
        if (!isScreenOn()) {
            Log.d(logTag, "Screen is OFF, skipping onCopyEvent")
            return
        }
        if (disableDuplicateAnnouncements) {
            clipboardService?.disableDuplicateAnnouncement = true;
        }
        clipboardService?.performClipboardRead(currentlyActiveApp)
        lastCopiedTimestamp = System.currentTimeMillis();
    }

    private fun startClipboardService() {
        val showIntent = Intent(this, CopyCatClipboardService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(showIntent)
        } else {
            startService(showIntent)
        }

        val bindIntent = Intent(this, CopyCatClipboardService::class.java)
        bindService(bindIntent, connection, Context.BIND_AUTO_CREATE)
        Log.d(logTag, "Clipboard service start requested")
        Toast.makeText(this, "CopyCat Service Starting", Toast.LENGTH_SHORT).show()
    }

    private fun stopClipboardService() {
        val stopIntent = Intent(this, CopyCatClipboardService::class.java)
        stopService(stopIntent)
    }

    private fun detectCopyAck() {
        Log.d(logTag, "CopyCat Service is detecting ack event...")
        detectingCopyAck = true
        clipboardService?.writeToClipboard(DetectionText)
    }

    private fun detectCopyAckComplete() {
        detectingCopyAck = false
        Toast.makeText(this, "CopyCat Service Started", Toast.LENGTH_SHORT).show()
        Log.d(logTag, "CopyCat Service successfully detected ($notificationAckText) ack event.")
    }

    private fun debounceOnCopyEvent(delayMillis: Long = 1200) {
        handler.removeCallbacks(copyRunnable) // cancel any pending run
        handler.postDelayed(copyRunnable, delayMillis)
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.i(logTag, "CopyCat Accessibility Service Connected")

        startClipboardService()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        Log.d(logTag, "Event : $event")

        if (event.packageName == "com.entilitystudio.CopyCat") {
            Log.d(logTag, "Ignoring CopyCat Clipboard Events")
            return
        }

        if (!detectingCopyAck) {
            if (Utils.isActivityOnTop) {
                Log.d(logTag, "Ignoring events as current activity is CopyCat itself")
                return
            }

            if (event?.packageName?.startsWith("com.entilitystudio") == true) {
                Log.d(logTag, "Ignoring CopyCat Clipboard Events")
                return
            }
        }

        when (event?.eventType) {
            AccessibilityEvent.TYPE_VIEW_CLICKED,
            AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED,
            AccessibilityEvent.TYPE_VIEW_TEXT_SELECTION_CHANGED -> {
                if (!strictCheck) debounceOnCopyEvent();
            }
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                event.packageName?.let {
                    if (it != "com.android.systemui")
                        currentlyActiveApp = it.toString()
                }

                // Special case for announcement type copy acknowledgement
                if ((event.packageName != "com.android.systemui" ||  event.className.toString() != "android.widget.FrameLayout") || event.text.isEmpty()) {
                    return
                }

                val ackTextSplit = event.text.toString().split(",")
                Log.d(logTag, "Ack TEXT: ${event.text} | $ackTextSplit")

                if (strictCheck && ackTextSplit.size > 1 || notificationAckText.isBlank()) {
                    val detectionText = ackTextSplit.first()

                    val ackText = ackTextSplit.last()
                    if (detectingCopyAck) {
                        if (!detectionText.contains(DetectionText)) return
                        notificationAckText = ackText
                        detectCopyAckComplete()
                        return
                    }

                    val copyDetected = ackText == notificationAckText || notificationAckText.isBlank()
                    if (copyDetected) onCopyEvent()
                } else if (!strictCheck && ackTextSplit.size == 1 && event.text.contains(DetectionText) && detectingCopyAck) {
                    notificationAckText = ""
                    detectCopyAckComplete()
                    return
                }
            }
            AccessibilityEvent.TYPE_ANNOUNCEMENT -> {
                if (strictCheck && event.packageName != "com.android.systemui") return

                val ackText = event.text.toString()
                if (detectingCopyAck && ackText.isNotEmpty()) {
                    notificationAckText = ackText
                    detectCopyAckComplete()
                    return
                }

                val copyDetected = ackText == notificationAckText
                if (copyDetected) onCopyEvent()
                else if (!strictCheck) debounceOnCopyEvent()
            }
            AccessibilityEvent.TYPE_NOTIFICATION_STATE_CHANGED -> {
                if (event.className != "android.widget.Toast") return
                Log.d(logTag, "Toast Event: $event")
                val ackText = event.text.toString()
                if (detectingCopyAck && ackText.isNotEmpty()) {
                    notificationAckText = ackText
                    detectCopyAckComplete()
                    return
                }
                Log.d(logTag, "Notification Text: $ackText | Expected: $notificationAckText")
                val copyDetected = ackText == notificationAckText
                if (copyDetected && ((strictCheck && event.packageName.contains("android")) || !strictCheck)) onCopyEvent()
                else if (!strictCheck) debounceOnCopyEvent()
            }
            else -> {}
        }

    }

    override fun onInterrupt() {
        Log.d(logTag, "Interrupt")
    }

    override fun onUnbind(intent: Intent?): Boolean {
        Log.i(logTag, "CopyCat Accessibility Service Disconnected")

        // Cancel any pending handler callbacks to prevent leaks
        handler.removeCallbacks(copyRunnable)
        handler.removeCallbacksAndMessages(null)

        if (isClipboardServiceConnected) unbindService(connection)
        stopClipboardService()
        Toast.makeText(this, "CopyCat Service Stopped", Toast.LENGTH_SHORT).show()
        return super.onUnbind(intent)
    }
}