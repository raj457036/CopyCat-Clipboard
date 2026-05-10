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
import android.os.SystemClock
import android.util.Log
import android.view.Gravity
import android.view.WindowManager
import android.view.accessibility.AccessibilityEvent
import android.widget.LinearLayout
import android.widget.Toast


const val DetectionText = "CopyCat"

class CopyCatAccessibilityService : AccessibilityService() {
    private val logTag = "CopyCatAccService"
    private val ackDetectionTimeoutMs = 4000L
    private val modeRelearnDelayMs = 500L
    private val verboseEventLogging = false
    private var detectingCopyAck: Boolean = false
    private var isClipboardServiceConnected: Boolean = false
    private var currentlyActiveApp: String = ""
    private lateinit var clipboardManager: ClipboardManager
    private lateinit var windowManager: WindowManager
    private var transientOverlayLayout: LinearLayout? = null
    private var persistentOverlayLayout: LinearLayout? = null
    private val handler = Handler(Looper.getMainLooper())
    private val ackDetectionTimeoutRunnable = Runnable {
        if (!detectingCopyAck) return@Runnable
        Log.w(logTag, "Ack detection timed out; completing setup with fallback")
        completeDetectionTest(succeeded = false)
    }
    private val modeRelearnRunnable = Runnable {
        if (!isClipboardServiceConnected || !::detectionStrategy.isInitialized) return@Runnable
        if (!detectionStrategy.requiresDetectionTest()) return@Runnable
        detectCopyAck()
    }
    private var strategyMode: ClipboardDetectionMode = ClipboardDetectionMode.default()

    // Strategy for detection
    private lateinit var detectionStrategy: ClipboardDetectionStrategy

    private val detectionStatusReporter = DetectionStatusReporter.getInstance()
    private var clipboardService: CopyCatClipboardService? = null
    private val detectionModeListener: (ClipboardDetectionMode) -> Unit = {
        handler.post {
            initializeDetectionStrategy(force = true)
        }
    }

    private fun updateDetectionStatus(state: String, outcome: String? = null) {
        detectionStatusReporter.update(state, outcome ?: "none")
    }

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
            Log.d(logTag, "OnServiceConnected $name")
            clipboardService = (binder as CopyCatClipboardService.LocalBinder).getService()
            clipboardService?.copycatStorage?.removeDetectionModeListener(detectionModeListener)
            clipboardService?.copycatStorage?.addDetectionModeListener(detectionModeListener)
            isClipboardServiceConnected = true

            // Initialize strategy based on current mode
            initializeDetectionStrategy(force = true)
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.d(logTag, "OnServiceDisconnected $name")
            handler.removeCallbacks(modeRelearnRunnable)
            cancelDetectionTest()
            clipboardService?.copycatStorage?.removeDetectionModeListener(detectionModeListener)
            clipboardService = null
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
        if (detectingCopyAck) {
            Log.d(logTag, "Detection test already running; skipping duplicate start")
            return
        }
        Log.d(logTag, "Starting copy acknowledgement detection...")
        detectingCopyAck = true
        updateDetectionStatus(state = "calibrating", outcome = "pending")
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        handler.postDelayed(ackDetectionTimeoutRunnable, ackDetectionTimeoutMs)
        val probeText = "$DetectionText-${SystemClock.uptimeMillis()}"
        detectionStrategy.startDetectionTest(probeText, object : ClipboardDetectionCallback {
            override fun onCopyDetected(packageName: String) {}
            override fun onTestAckCandidate(ackText: String) {
                if (!isDetectionProbeStillOnClipboard(probeText)) {
                    Log.d(logTag, "Ignoring ack candidate because clipboard no longer matches probe")
                    return
                }
                detectionStrategy.acceptDetectionTestAckText(ackText)
                completeDetectionTest(succeeded = true)
            }
        })
        withAccessibilityOverlayFocus {
            clipboardService?.writeToClipboard(probeText)
        }
    }

    private fun isDetectionProbeStillOnClipboard(probeText: String): Boolean {
        var clipboardText: String? = null
        withAccessibilityOverlayFocus {
            val clipData = clipboardManager.primaryClip
            if (clipData != null && clipData.itemCount > 0) {
                clipboardText = clipData.getItemAt(0).coerceToText(this)?.toString()
            }
        }

        return clipboardText?.trim() == probeText
    }

    private fun cancelDetectionTest(nextState: String? = null, nextOutcome: String? = null) {
        if (!detectingCopyAck) {
            return
        }

        detectingCopyAck = false
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        if (::detectionStrategy.isInitialized) {
            detectionStrategy.completeDetectionTest()
        }
        if (nextState != null) {
            updateDetectionStatus(nextState, nextOutcome ?: "none")
        }
    }

    private fun completeDetectionTest(succeeded: Boolean) {
        if (!detectingCopyAck) return
        detectingCopyAck = false
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        detectionStrategy.completeDetectionTest()
        updateDetectionStatus(
            state = "running_heuristic",
            outcome = if (succeeded) "success" else "failure",
        )
        if (succeeded) {
            Toast.makeText(this, "CopyCat Service Started", Toast.LENGTH_SHORT).show()
            Log.d(logTag, "CopyCat Service successfully detected copy acknowledgement")
        } else {
            Toast.makeText(this, "CopyCat started with fallback detection", Toast.LENGTH_SHORT)
                .show()
            Log.w(logTag, "CopyCat calibration timed out; continuing with fallback detection")
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        Log.i(logTag, "CopyCat Accessibility Service Connected")
        clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

        startClipboardService()
    }

    private fun getFocusOnOverlay(): Boolean {
        transientOverlayLayout = LinearLayout(this)
        val layoutParams = WindowManager.LayoutParams(
            0,
            0,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            android.graphics.PixelFormat.TRANSPARENT,
        )

        return try {
            windowManager.addView(transientOverlayLayout, layoutParams)
            true
        } catch (e: Exception) {
            Log.e(logTag, "Failed to add accessibility overlay: ${e.message}")
            transientOverlayLayout = null
            false
        }
    }

    private fun removeFocusOnOverlay() {
        transientOverlayLayout?.let {
            try {
                windowManager.removeView(it)
            } catch (e: Exception) {
                Log.w(logTag, "Failed to remove accessibility overlay: ${e.message}")
            }
        }
        transientOverlayLayout = null
    }

    private fun enablePersistentOverlayIfNeeded() {
        if (persistentOverlayLayout != null || Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val overlayView = LinearLayout(this)
        val layoutParams = WindowManager.LayoutParams(
            1,
            1,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE,
            android.graphics.PixelFormat.TRANSPARENT,
        ).apply {
            gravity = Gravity.TOP or Gravity.START
        }

        try {
            windowManager.addView(overlayView, layoutParams)
            persistentOverlayLayout = overlayView
            Log.d(logTag, "Enabled persistent accessibility overlay")
        } catch (e: Exception) {
            Log.e(logTag, "Failed to enable persistent accessibility overlay: ${e.message}")
        }
    }

    private fun disablePersistentOverlay() {
        persistentOverlayLayout?.let {
            try {
                windowManager.removeView(it)
            } catch (e: Exception) {
                Log.w(logTag, "Failed to remove persistent accessibility overlay: ${e.message}")
            }
        }
        persistentOverlayLayout = null
    }

    private fun updatePersistentOverlayState(mode: ClipboardDetectionMode) {
        if (mode == ClipboardDetectionMode.MODE_3_OVERLAY) {
            enablePersistentOverlayIfNeeded()
        } else {
            disablePersistentOverlay()
        }
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

    private fun scheduleModeRelearnIfNeeded() {
        if (!isClipboardServiceConnected ||
            !::detectionStrategy.isInitialized ||
            !detectionStrategy.requiresDetectionTest()
        ) {
            return
        }
        handler.removeCallbacks(modeRelearnRunnable)
        handler.postDelayed(modeRelearnRunnable, modeRelearnDelayMs)
    }
    
    private fun initializeDetectionStrategy(force: Boolean = false) {
        val selectedMode = clipboardService?.copycatStorage?.detectionMode
            ?: ClipboardDetectionMode.default()

        if (!force && ::detectionStrategy.isInitialized && selectedMode == strategyMode) {
            return
        }

        val hadStrategy = ::detectionStrategy.isInitialized
        val previousMode = strategyMode

        if (detectingCopyAck) {
            Log.d(logTag, "Cancelling in-flight detection test due to mode reinitialization")
            cancelDetectionTest(nextState = "starting", nextOutcome = "pending")
        }

        if (hadStrategy) {
            detectionStrategy.shutdown()
        }

        strategyMode = selectedMode
        val cachedMode1AckText = clipboardService?.copycatStorage?.getMode1AckText()
        detectionStrategy = when (selectedMode) {
            ClipboardDetectionMode.MODE_INACTIVE -> ModeInactiveStrategy()
            ClipboardDetectionMode.MODE_1_ACK_TEXT -> Mode1AckTextStrategy(
                initialAckText = cachedMode1AckText,
                onAckTextLearned = { ackText ->
                    clipboardService?.copycatStorage?.writeMode1AckText(ackText)
                },
            )
            ClipboardDetectionMode.MODE_2_AGGRESSIVE -> Mode2AggressiveStrategy()
            ClipboardDetectionMode.MODE_3_OVERLAY -> Mode3OverlayStrategy()
        }

        updatePersistentOverlayState(selectedMode)
        val requiresDetectionTest = detectionStrategy.requiresDetectionTest()
        updateDetectionStatus(
            state = when (selectedMode) {
                ClipboardDetectionMode.MODE_INACTIVE -> "inactive"
                ClipboardDetectionMode.MODE_1_ACK_TEXT ->
                    if (requiresDetectionTest) "starting" else "running_heuristic"
                ClipboardDetectionMode.MODE_2_AGGRESSIVE -> "running_aggressive"
                ClipboardDetectionMode.MODE_3_OVERLAY -> "running_overlay"
            },
            outcome = when (selectedMode) {
                ClipboardDetectionMode.MODE_1_ACK_TEXT ->
                    if (requiresDetectionTest) "pending" else "success"

                else -> "none"
            },
        )

        Log.d(logTag, "Initialized detection strategy for mode: ${selectedMode.value}")

        if (force || !hadStrategy || selectedMode != previousMode) {
            scheduleModeRelearnIfNeeded()
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) {
            return
        }

        val isOwnAppEvent = event.packageName?.toString() == packageName
        if (isOwnAppEvent && !detectingCopyAck) {
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
                override fun onTestAckCandidate(ackText: String) {}
            }
        )
    }

    override fun onInterrupt() {
        Log.d(logTag, "Interrupt")
    }

    override fun onUnbind(intent: Intent?): Boolean {
        Log.i(logTag, "CopyCat Accessibility Service Disconnected")

        cancelDetectionTest()

        // Clean up strategy
        if (::detectionStrategy.isInitialized) {
            detectionStrategy.shutdown()
        }

        // Cancel any pending handler callbacks to prevent leaks
        handler.removeCallbacks(modeRelearnRunnable)
        handler.removeCallbacks(ackDetectionTimeoutRunnable)
        handler.removeCallbacksAndMessages(null)
        updateDetectionStatus(state = "stopped", outcome = "none")
        disablePersistentOverlay()
        removeFocusOnOverlay()

        clipboardService?.copycatStorage?.removeDetectionModeListener(detectionModeListener)
        if (isClipboardServiceConnected) unbindService(connection)
        stopClipboardService()
        Toast.makeText(this, "CopyCat Service Stopped", Toast.LENGTH_SHORT).show()
        return super.onUnbind(intent)
    }
}