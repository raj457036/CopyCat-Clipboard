package com.entilitystudio.CopyCat

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.inputmethodservice.InputMethodService
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.view.WindowManager
import android.view.KeyEvent
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.FrameLayout
import androidx.core.content.FileProvider
import androidx.core.content.getSystemService
import androidx.core.view.inputmethod.EditorInfoCompat
import androidx.core.view.inputmethod.InputConnectionCompat
import androidx.core.view.inputmethod.InputContentInfoCompat
import io.flutter.embedding.android.FlutterSurfaceView
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.content.ClipDescription

object ImeEngineManager {
    private const val ENGINE_ID = "copycat_ime_engine"

    fun getOrCreateEngine(context: Context): FlutterEngine {
        val cache = FlutterEngineCache.getInstance()
        var engine = cache.get(ENGINE_ID)
        if (engine == null) {
            engine = FlutterEngine(context.applicationContext).apply {
                dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint.createDefault(),
                    listOf("--ime"),
                )
            }
            cache.put(ENGINE_ID, engine)
        }
        return engine
    }
}

private class ImeContainerView(
    context: Context,
    private val targetHeightPx: Int,
) : FrameLayout(context) {
    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val exactHeightSpec = MeasureSpec.makeMeasureSpec(targetHeightPx, MeasureSpec.EXACTLY)
        super.onMeasure(widthMeasureSpec, exactHeightSpec)
        setMeasuredDimension(getDefaultSize(suggestedMinimumWidth, widthMeasureSpec), targetHeightPx)
    }
}

class CopyCatImeService : InputMethodService() {

    private val channelName = "copycat/ime"

    private lateinit var flutterEngine: FlutterEngine
    private lateinit var imeChannel: MethodChannel
    private var flutterView: FlutterView? = null
    private var containerView: ImeContainerView? = null
    private var targetHeightPx: Int = 0

    private var supportedContentMimeTypes: Array<String> = emptyArray()

    override fun onCreate() {
        super.onCreate()

        targetHeightPx = android.util.TypedValue.applyDimension(
            android.util.TypedValue.COMPLEX_UNIT_DIP,
            290f,
            resources.displayMetrics
        ).toInt()

        window?.window?.apply {
            setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
            decorView.setBackgroundColor(Color.TRANSPARENT)
        }

        flutterEngine = ImeEngineManager.getOrCreateEngine(this)

        imeChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        imeChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "commitText" -> handleCommitText(call, result)
                "commitContent" -> handleCommitContent(call, result)
                "deleteBackward" -> handleDeleteBackward(result)
                "showInputMethodPicker" -> {
                    val imm = getSystemService<InputMethodManager>()
                    imm?.showInputMethodPicker()
                    result.success(null)
                }
                "copyToClipboard" -> handleCopyToClipboard(call, result)
                "performEditorAction" -> handlePerformEditorAction(result)
                "hide" -> {
                    requestHideSelf(0)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onConfigureWindow(win: Window, isFullscreen: Boolean, isCandidatesOnly: Boolean) {
        super.onConfigureWindow(win, isFullscreen, isCandidatesOnly)
        win.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
        win.setGravity(Gravity.BOTTOM)
        win.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        win.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
    }

    override fun onCreateInputView(): View {
        containerView?.let { existing ->
            (existing.parent as? ViewGroup)?.removeView(existing)
            return existing
        }

        flutterView?.detachFromFlutterEngine()

        val container = ImeContainerView(this, targetHeightPx)
        val surfaceView = FlutterSurfaceView(this, true)
        val view = FlutterView(this, surfaceView).apply {
            layoutParams = FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT,
            )
        }
        container.addView(view)
        view.attachToFlutterEngine(flutterEngine)

        flutterView = view
        containerView = container
        return container
    }

    override fun onComputeInsets(outInsets: Insets) {
        super.onComputeInsets(outInsets)
        val container = containerView ?: return
        val height = container.height.takeIf { it > 0 } ?: targetHeightPx
        val decorHeight = window?.window?.decorView?.height ?: height
        val top = (decorHeight - height).coerceAtLeast(0)
        outInsets.contentTopInsets = top
        outInsets.visibleTopInsets = top
        outInsets.touchableInsets = Insets.TOUCHABLE_INSETS_CONTENT
    }

    override fun onEvaluateFullscreenMode(): Boolean {
        return false
    }

    override fun onStartInputView(info: EditorInfo, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        flutterEngine.lifecycleChannel.appIsResumed()
        supportedContentMimeTypes = EditorInfoCompat.getContentMimeTypes(info)

        val actionCode = info.imeOptions and EditorInfo.IME_MASK_ACTION
        val hasNoEnterAction = (info.imeOptions and EditorInfo.IME_FLAG_NO_ENTER_ACTION) != 0
        val action = if (hasNoEnterAction) {
            "newline"
        } else {
            when (actionCode) {
                EditorInfo.IME_ACTION_GO -> "go"
                EditorInfo.IME_ACTION_SEARCH -> "search"
                EditorInfo.IME_ACTION_SEND -> "send"
                EditorInfo.IME_ACTION_NEXT -> "next"
                EditorInfo.IME_ACTION_DONE -> "done"
                EditorInfo.IME_ACTION_PREVIOUS -> "previous"
                else -> "newline"
            }
        }

        imeChannel.invokeMethod(
            "onEditorCapabilitiesChanged",
            mapOf(
                "supportedMimeTypes" to supportedContentMimeTypes.toList(),
                "action" to action,
            ),
        )
    }

    override fun onFinishInputView(finishingInput: Boolean) {
        super.onFinishInputView(finishingInput)
        flutterEngine.lifecycleChannel.appIsPaused()
        supportedContentMimeTypes = emptyArray()
    }

    override fun onDestroy() {
        flutterView?.detachFromFlutterEngine()
        flutterView = null
        containerView = null
        if (::flutterEngine.isInitialized) {
            flutterEngine.lifecycleChannel.appIsPaused()
        }
        super.onDestroy()
    }

    // ─── Method handlers ────────────────────────────────────────────────────

    private fun handleCommitText(call: MethodCall, result: MethodChannel.Result) {
        val text = call.argument<String>("text") ?: ""
        val ic = currentInputConnection
        if (ic == null) {
            result.error("no_input_connection", "No active InputConnection", null)
            return
        }
        ic.commitText(text, 1)
        result.success(null)
    }

    private fun handleCommitContent(call: MethodCall, result: MethodChannel.Result) {
        val filePath = call.argument<String>("filePath") ?: run {
            result.error("invalid_args", "filePath is null", null)
            return
        }
        val mimeType = call.argument<String>("mimeType") ?: "image/*"
        val label    = call.argument<String>("label") ?: "Image"

        val ic   = currentInputConnection
        val info = currentInputEditorInfo
        if (ic == null || info == null) {
            result.error("no_input_connection", "No active InputConnection", null)
            return
        }

        runCatching {
            val file = File(filePath)
            require(file.exists()) { "File not found: $filePath" }

            val contentUri = FileProvider.getUriForFile(
                this,
                "${applicationContext.packageName}.fileProvider",
                file,
            )

            InputConnectionCompat.commitContent(
                ic,
                info,
                InputContentInfoCompat(
                    contentUri,
                    ClipDescription(label, arrayOf(mimeType)),
                    null,
                ),
                InputConnectionCompat.INPUT_CONTENT_GRANT_READ_URI_PERMISSION,
                null,
            )
        }.onSuccess {
            result.success(null)
        }.onFailure { e ->
            result.error("commit_failed", e.message, null)
        }
    }

    private fun handleCopyToClipboard(call: MethodCall, result: MethodChannel.Result) {
        val text  = call.argument<String>("text") ?: run {
            result.error("invalid_args", "text is null", null)
            return
        }
        val label = call.argument<String>("label") ?: "Clip"

        runCatching {
            val cm = getSystemService<ClipboardManager>()!!
            cm.setPrimaryClip(ClipData.newPlainText(label, text))
        }.onSuccess {
            result.success(null)
        }.onFailure { e ->
            result.error("clipboard_failed", e.message, null)
        }
    }

    private fun handleDeleteBackward(result: MethodChannel.Result) {
        val ic = currentInputConnection
        if (ic == null) {
            result.error("no_input_connection", "No active InputConnection", null)
            return
        }
        val selected = ic.getSelectedText(0)
        if (!selected.isNullOrEmpty()) {
            ic.commitText("", 1)
        } else {
            val deleted = ic.deleteSurroundingText(1, 0)
            if (!deleted) {
                sendDownUpKeyEvents(KeyEvent.KEYCODE_DEL)
            }
        }
        result.success(null)
    }

    private fun handlePerformEditorAction(result: MethodChannel.Result) {
        val ic = currentInputConnection
        if (ic == null) {
            result.error("no_input_connection", "No active InputConnection", null)
            return
        }
        val info = currentInputEditorInfo
        val actionCode = (info?.imeOptions ?: 0) and EditorInfo.IME_MASK_ACTION
        val hasNoEnterAction = ((info?.imeOptions ?: 0) and EditorInfo.IME_FLAG_NO_ENTER_ACTION) != 0
        if (!hasNoEnterAction && actionCode != EditorInfo.IME_ACTION_NONE && actionCode != EditorInfo.IME_ACTION_UNSPECIFIED) {
            ic.performEditorAction(actionCode)
        } else {
            sendDownUpKeyEvents(KeyEvent.KEYCODE_ENTER)
        }
        result.success(null)
    }
}
