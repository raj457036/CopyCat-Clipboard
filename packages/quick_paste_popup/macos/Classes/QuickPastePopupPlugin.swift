import Cocoa
import FlutterMacOS

public class QuickPastePopupPlugin: NSObject, FlutterPlugin, NSPopoverDelegate {
    private var methodChannel: FlutterMethodChannel?
    private var currentPopover: NSPopover?
    private var anchorWindow: NSWindow?
    private var pendingResult: FlutterResult?
    private var didSendResultForCurrentPopup = false
    private var appDeactivationObserver: NSObjectProtocol?
    private var selectionColor: NSColor = .controlAccentColor
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "quick_paste_popup", binaryMessenger: registrar.messenger)
        let instance = QuickPastePopupPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func dummyMethodToEnforceBundling() {
        // This method is required for the plugin to work properly in release builds
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        NSLog("[QuickPastePopupPlugin] Received call: \(call.method)")
        switch call.method {
        case "getPlatformVersion":
            handleGetPlatformVersion(result: result)
            
        case "getCursorPosition":
            handleGetCursorPosition(result: result)
            
        case "getFocusedApp":
            handleGetFocusedApp(result: result)
            
        case "showQuickPastePopup":
            handleShowQuickPastePopup(call: call, result: result)

        case "setTheme":
            handleSetTheme(call: call, result: result)

        case "insertTextDirect":
            handleInsertTextDirect(call: call, result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Method Handlers
    
    private func handleGetPlatformVersion(result: FlutterResult) {
        let version = "macOS " + ProcessInfo.processInfo.operatingSystemVersionString
        result(version)
    }
    
    private func handleGetCursorPosition(result: FlutterResult) {
        guard let position = SystemUtilities.getCursorPosition() else {
            NSLog("[QuickPastePopupPlugin] Cursor position unavailable")
            result(nil)
            return
        }

        NSLog("[QuickPastePopupPlugin] Cursor position x=\(position.x) y=\(position.y)")
        
        result([
            "x": position.x,
            "y": position.y,
        ])
    }
    
    private func handleGetFocusedApp(result: FlutterResult) {
        let appInfo = SystemUtilities.getFocusedApp()
        NSLog("[QuickPastePopupPlugin] Focused app=\(String(describing: appInfo))")
        result(appInfo)
    }

    private func handleInsertTextDirect(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let text = args["text"] as? String else {
            result(false)
            return
        }

        DispatchQueue.main.async {
            result(PasteboardHelper.insertTextDirectToFocusedElement(text))
        }
    }

    private func handleSetTheme(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(false)
            return
        }

        if let selectionColorValue = args["selectionColor"] as? Int64 {
            selectionColor = NSColor(argb: UInt32(truncatingIfNeeded: selectionColorValue))
            result(true)
            return
        }

        if let selectionColorValue = args["selectionColor"] as? Int {
            selectionColor = NSColor(argb: UInt32(truncatingIfNeeded: selectionColorValue))
            result(true)
            return
        }

        result(false)
    }
    
    private func handleShowQuickPastePopup(call: FlutterMethodCall, result: @escaping FlutterResult) {
        runOnMain {
            self.closeCurrentPopup(sendDismissedIfPending: true)

            guard let args = call.arguments as? [String: Any],
                  let itemsData = args["items"] as? [[String: Any]] else {
                NSLog("[QuickPastePopupPlugin] Invalid arguments for showQuickPastePopup")
                result([
                    "selectedItemId": nil,
                    "dismissed": true,
                    "error": "Invalid arguments provided",
                ])
                return
            }

            NSLog("[QuickPastePopupPlugin] showQuickPastePopup with items=\(itemsData.count)")
            let anchorPosition = SystemUtilities.getCursorPosition()
            NSLog("[QuickPastePopupPlugin] Anchor for popup=\(String(describing: anchorPosition))")
            
            let viewController = QuickPastePopupViewController()
            viewController.items = itemsData
            viewController.selectionColor = self.selectionColor

            let popover = NSPopover()
            popover.contentViewController = viewController
            popover.behavior = .transient
            popover.animates = true
            popover.delegate = self
            
            self.currentPopover = popover
            self.pendingResult = result
            self.didSendResultForCurrentPopup = false

            viewController.completionHandler = { [weak self] selectedItemId, dismissed, error in
                guard let self = self else { return }
                self.runOnMain {
                    NSLog(
                        "[QuickPastePopupPlugin] Completion selectedItemId=\(String(describing: selectedItemId)) dismissed=\(dismissed) error=\(String(describing: error))"
                    )
                    
                    var resultData: [String: Any] = [
                        "dismissed": dismissed,
                    ]
                    
                    if let itemId = selectedItemId {
                        resultData["selectedItemId"] = itemId
                    }
                    
                    if let error = error {
                        resultData["error"] = error
                    }

                    self.sendResultIfPending(resultData)
                    self.closeCurrentPopup(sendDismissedIfPending: false)
                }
            }

            NSLog("[QuickPastePopupPlugin] Presenting popover")

            guard let anchorView = self.createAnchorView(cursorPosition: anchorPosition) else {
                self.sendResultIfPending([
                    "dismissed": true,
                    "error": "Failed to create anchor view for popover",
                ])
                self.closeCurrentPopup(sendDismissedIfPending: false)
                return
            }

            self.installAppDeactivationObserver()

            popover.show(
                relativeTo: anchorView.bounds,
                of: anchorView,
                preferredEdge: .maxY
            )
        }
    }

    public func popoverDidClose(_ notification: Notification) {
        // Only fires from AppKit-initiated closes (transient click-outside)
        // because we nil the delegate before calling close() ourselves.
        NSLog("[QuickPastePopupPlugin] Popover closed by AppKit (transient)")

        sendResultIfPending([
            "dismissed": true,
        ])

        cleanupPopupReferences()
    }

    private func sendResultIfPending(_ resultData: [String: Any]) {
        guard !didSendResultForCurrentPopup else { return }
        didSendResultForCurrentPopup = true
        pendingResult?(resultData)
        pendingResult = nil
    }

    private func closeCurrentPopup(sendDismissedIfPending: Bool) {
        assert(Thread.isMainThread)

        if sendDismissedIfPending {
            sendResultIfPending([
                "dismissed": true,
            ])
        }

        // Nil the delegate BEFORE calling close() to prevent a re-entrant call
        // to popoverDidClose (which fires synchronously on the same call stack).
        // popoverDidClose is only intended for AppKit-initiated transient closes.
        currentPopover?.delegate = nil

        if let popover = currentPopover, popover.isShown {
            popover.close()
        }

        cleanupPopupReferences()
    }

    private func cleanupPopupReferences() {
        // Capture and clear the observer ivar BEFORE removing from NotificationCenter.
        // This prevents a crash when removal is triggered from inside the observer callback.
        let observerToRemove = appDeactivationObserver
        appDeactivationObserver = nil
        if let observer = observerToRemove {
            NotificationCenter.default.removeObserver(observer)
        }

        currentPopover?.delegate = nil
        currentPopover = nil

        // Capture-and-nil BEFORE close to prevent any ARC double-release.
        let windowToClose = anchorWindow
        anchorWindow = nil
        windowToClose?.orderOut(nil)
        windowToClose?.close()
    }

    private func installAppDeactivationObserver() {
        // Clear any previous observer before installing a new one.
        let oldObserver = appDeactivationObserver
        appDeactivationObserver = nil
        if let old = oldObserver {
            NotificationCenter.default.removeObserver(old)
        }

        appDeactivationObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: NSApp,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            if self.currentPopover?.isShown == true {
                NSLog("[QuickPastePopupPlugin] App resigned active, closing popover")
                self.closeCurrentPopup(sendDismissedIfPending: true)
            }
        }
    }

    private func removeAppDeactivationObserver() {
        let observerToRemove = appDeactivationObserver
        appDeactivationObserver = nil
        if let observer = observerToRemove {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func runOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }

    private func createAnchorView(cursorPosition: CGPoint?) -> NSView? {
        assert(Thread.isMainThread)

        let origin: CGPoint

        if let cursorPosition {
            origin = cursorPosition
        } else if let screen = NSScreen.main {
            origin = CGPoint(x: screen.visibleFrame.midX, y: screen.visibleFrame.midY)
        } else {
            origin = CGPoint(x: 100, y: 100)
        }

        let frame = NSRect(x: origin.x, y: origin.y, width: 1, height: 1)
        let panel = NSPanel(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.level = .statusBar
        panel.hidesOnDeactivate = false
        panel.isFloatingPanel = true
        panel.collectionBehavior = [.canJoinAllSpaces, .transient, .ignoresCycle]
        // Must be false under ARC to prevent double-release crash when close() is called.
        panel.isReleasedWhenClosed = false

        let anchorView = NSView(frame: NSRect(x: 0, y: 0, width: 1, height: 1))
        panel.contentView = anchorView
        // Show without activating the app, so the original text field keeps focus.
        panel.orderFrontRegardless()

        self.anchorWindow = panel
        return anchorView
    }
}

