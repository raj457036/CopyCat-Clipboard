package com.entilitystudio.android_background_clipboard

import android.accessibilityservice.AccessibilityService
import android.content.ClipboardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.LinearLayout
import android.widget.Toast


const val DetectionText = "CopyCat"

class CopyCatAccessibilityService : AccessibilityService() {
    private val logTag = "CopyCatAccService"
    private val ackDetectionTimeoutMs = 4000L
    private val verboseEventLogging = false
    private var detectingCopyAck: Boolean = false
    private var isClipboardServiceConnected: Boolean = false
    private var currentlyActiveApp: String = ""
    private lateinit var clipboardManager: ClipboardManager
    private lateinit var windowManager: WindowManager
    private var overlayLayout: LinearLayout? = null
    private val handler = Handler(Looper.getMainLooper())
    private val ackDetectionTimeoutRunnable = Runnable {
        if (!detectingCopyAck) return@Runnable
        Log.w(logTag, "Ack detection timed out; completing setup with fallback")
        detectCopyAckComplete()
    }
    private var strategyMode: ClipboardDetectionMode = ClipboardDetectionMode.MODE_1_ACK_TEXT

    // Strategy for detection
    private lateinit var detectionStrategy: ClipboardDetectionStrategy

    private var clipboardService: CopyCatClipboardService? = null

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
            Log.d(logTag, "OnServiceConnected $name")
            clipboardService = (binder as CopyCatClipboardService.LocalBinder).getService()
            isClipboardServiceConnected = true

            // Initialize strategy based on current mode
            initializeDetectionStrategy()

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

    private fun onCopyEvent(packageName: String = "") {
        Log.d(logTag, "Copy Event Detected, Reading Clipboard")

        if (!isClipboardServiceConnected) {
            Log.w(logTag, "ClipboardService not connected yet, ignoring onCopyEvent")
            return
        }
        if (!isScreenOn()) {
            Log.d(logTag, "Screen is OFF, skipping onCopyEvent")
            return
        }
        withAccessibilityOverlayFocus {
            clipboardService?.performClipboardReadFromClipData(
                clipboardManager.primaryClip,
                packageName,
            )
        }
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
        Log.d(logTag, "Starting copy acknowledgement detection...")
        detectingCopyAck = true
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        handler.postDelayed(ackDetectionTimeoutRunnable, ackDetectionTimeoutMs)
        detectionStrategy.startDetectionTest(object : ClipboardDetectionCallback {
            override fun onCopyDetected(packageName: String) {}
            override fun onTestAckDetected() {
                detectCopyAckComplete()
            }
        })
        withAccessibilityOverlayFocus {
            clipboardService?.writeToClipboard(DetectionText)
        }
    }

    private fun detectCopyAckComplete() {
        if (!detectingCopyAck) return
        detectingCopyAck = false
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        detectionStrategy.completeDetectionTest()
        Toast.makeText(this, "CopyCat Service Started", Toast.LENGTH_SHORT).show()
        Log.d(logTag, "CopyCat Service successfully detected copy acknowledgement")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.i(logTag, "CopyCat Accessibility Service Connected")
        clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

        startClipboardService()
    }

    private fun getFocusOnOverlay(): Boolean {
        overlayLayout = LinearLayout(this)
        val layoutParams = WindowManager.LayoutParams(
            0,
            0,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            android.graphics.PixelFormat.TRANSPARENT,
        )

        return try {
            windowManager.addView(overlayLayout, layoutParams)
            true
        } catch (e: Exception) {
            Log.e(logTag, "Failed to add accessibility overlay: ${e.message}")
            overlayLayout = null
            false
        }
    }

    private fun removeFocusOnOverlay() {
        overlayLayout?.let {
            try {
                windowManager.removeView(it)
            } catch (e: Exception) {
                Log.w(logTag, "Failed to remove accessibility overlay: ${e.message}")
            }
        }
        overlayLayout = null
    }

    private fun withAccessibilityOverlayFocus(action: () -> Unit) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            action()
            return
        }

        val overlayAdded = getFocusOnOverlay()
        try {
            action()
        } finally {
            if (overlayAdded) {
                removeFocusOnOverlay()
            }
        }
    }
    
    private fun initializeDetectionStrategy(force: Boolean = false) {
        val selectedMode = clipboardService?.copycatStorage?.detectionMode
            ?: ClipboardDetectionMode.MODE_1_ACK_TEXT

        if (!force && ::detectionStrategy.isInitialized && selectedMode == strategyMode) {
            return
        }

        if (::detectionStrategy.isInitialized) {
            detectionStrategy.shutdown()
        }

        strategyMode = selectedMode
        detectionStrategy = when (selectedMode) {
            ClipboardDetectionMode.MODE_1_ACK_TEXT -> Mode1AckTextStrategy()
            ClipboardDetectionMode.MODE_2_AGGRESSIVE -> Mode2AggressiveStrategy()
            ClipboardDetectionMode.MODE_3_SEQUENCE -> Mode1AckTextStrategy()
            ClipboardDetectionMode.MODE_4_OVERLAY -> Mode1AckTextStrategy()
        }

        Log.d(logTag, "Initialized detection strategy for mode: ${selectedMode.value}")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.packageName == "com.entilitystudio.CopyCat") {
            return
        }

        if (verboseEventLogging) {
            Log.d(logTag, "Event : $event")
        }

        initializeDetectionStrategy()

        // Update currently active app for context
        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            event.packageName?.let {
                if (it != "com.android.systemui")
                    currentlyActiveApp = it.toString()
            }
        }

        // Delegate to detection strategy
        detectionStrategy.onAccessibilityEvent(
            event,
            packageName = currentlyActiveApp,
            isScreenOn = isScreenOn(),
            isAppInForeground = Utils.isActivityOnTop,
            callback = object : ClipboardDetectionCallback {
                override fun onCopyDetected(packageName: String) {
                    onCopyEvent(packageName = packageName)
                }
                override fun onTestAckDetected() {}
            }
        )
    }

    override fun onInterrupt() {
        Log.d(logTag, "Interrupt")
    }

    override fun onUnbind(intent: Intent?): Boolean {
        Log.i(logTag, "CopyCat Accessibility Service Disconnected")

        // Clean up strategy
        if (::detectionStrategy.isInitialized) {
            detectionStrategy.shutdown()
        }

        // Cancel any pending handler callbacks to prevent leaks
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        handler.removeCallbacksAndMessages(null)
        removeFocusOnOverlay()

        if (isClipboardServiceConnected) unbindService(connection)
        stopClipboardService()
        Toast.makeText(this, "CopyCat Service Stopped", Toast.LENGTH_SHORT).show()
        return super.onUnbind(intent)
    }
}