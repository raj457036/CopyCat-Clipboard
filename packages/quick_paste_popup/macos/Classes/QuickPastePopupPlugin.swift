import Cocoa
import FlutterMacOS

public class QuickPastePopupPlugin: NSObject, FlutterPlugin, NSPopoverDelegate {
    private var methodChannel: FlutterMethodChannel?
    private var currentPopover: NSPopover?
    private var anchorWindow: NSWindow?
    private var pendingResult: FlutterResult?
    private var didSendResultForCurrentPopup = false
    private var cachedCaretPosition: CGPoint?
    private var appDeactivationObserver: NSObjectProtocol?
    private var selectionColor: NSColor = .controlAccentColor

    /// PID of the last non-CopyCat app that was active.
    private var previousActiveAppPID: pid_t?
    private var activeAppTrackingObserver: NSObjectProtocol?

    // MARK: - Registration

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "quick_paste_popup", binaryMessenger: registrar.messenger
        )
        let instance = QuickPastePopupPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.startTrackingActiveApp()
    }

    /// Continuously track the last non-self app so we can query its AX tree
    /// for caret position even after CopyCat steals focus.
    private func startTrackingActiveApp() {
        let myPID = ProcessInfo.processInfo.processIdentifier

        if let front = NSWorkspace.shared.frontmostApplication,
           front.processIdentifier != myPID {
            previousActiveAppPID = front.processIdentifier
        }

        activeAppTrackingObserver = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey]
                    as? NSRunningApplication else { return }
            if app.processIdentifier != myPID {
                self?.previousActiveAppPID = app.processIdentifier
            }
        }
    }

    // MARK: - Method channel dispatch

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "showQuickPastePopup":
            handleShowQuickPastePopup(call: call, result: result)
        case "setTheme":
            handleSetTheme(call: call, result: result)
        case "insertTextDirect":
            handleInsertTextDirect(call: call, result: result)
        case "captureCaretContext":
            handleCaptureCaretContext(result: result)
        case "getCursorPosition":
            handleGetCursorPosition(result: result)
        case "getFocusedApp":
            result(SystemUtilities.getFocusedApp())
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Handlers

    private func handleGetCursorPosition(result: FlutterResult) {
        guard let pos = SystemUtilities.getCursorPosition() else {
            result(nil)
            return
        }
        result(["x": pos.x, "y": pos.y])
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

        if let v = args["selectionColor"] as? Int64 {
            selectionColor = NSColor(argb: UInt32(truncatingIfNeeded: v))
            result(true)
        } else if let v = args["selectionColor"] as? Int {
            selectionColor = NSColor(argb: UInt32(truncatingIfNeeded: v))
            result(true)
        } else {
            result(false)
        }
    }

    private func handleCaptureCaretContext(result: @escaping FlutterResult) {
        guard let targetPID = previousActiveAppPID,
              let targetApp = NSRunningApplication(processIdentifier: targetPID) else {
            self.cachedCaretPosition = SystemUtilities.getCursorPosition()
            result(false)
            return
        }

        // Activate the target app so macOS populates its AX focused element.
        targetApp.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))

        var caretPos = SystemUtilities.getCaretPositionForApp(pid: targetPID)
        if caretPos == nil {
            caretPos = SystemUtilities.getFocusedTextCaretPosition()
        }

        self.cachedCaretPosition = caretPos ?? SystemUtilities.getCursorPosition()
        result(caretPos != nil)
    }

    private func handleShowQuickPastePopup(call: FlutterMethodCall, result: @escaping FlutterResult) {
        runOnMain {
            self.closeCurrentPopup(sendDismissedIfPending: true)

            guard let args = call.arguments as? [String: Any],
                  let itemsData = args["items"] as? [[String: Any]] else {
                result(["selectedItemId": NSNull(), "dismissed": true, "error": "Invalid arguments"])
                return
            }

            let anchor = self.cachedCaretPosition
                ?? SystemUtilities.getFocusedTextCaretPosition()
                ?? SystemUtilities.getCursorPosition()
            self.cachedCaretPosition = nil

            let vc = QuickPastePopupViewController()
            vc.items = itemsData
            vc.selectionColor = self.selectionColor

            let popover = NSPopover()
            popover.contentViewController = vc
            popover.behavior = .transient
            popover.animates = true
            popover.delegate = self

            self.currentPopover = popover
            self.pendingResult = result
            self.didSendResultForCurrentPopup = false

            vc.completionHandler = { [weak self] selectedItemId, dismissed, error in
                guard let self = self else { return }
                self.runOnMain {
                    var data: [String: Any] = ["dismissed": dismissed]
                    if let id = selectedItemId { data["selectedItemId"] = id }
                    if let e = error { data["error"] = e }
                    self.sendResultIfPending(data)
                    self.closeCurrentPopup(sendDismissedIfPending: false)
                }
            }

            guard let anchorView = self.createAnchorView(at: anchor) else {
                self.sendResultIfPending(["dismissed": true, "error": "Failed to create anchor"])
                self.closeCurrentPopup(sendDismissedIfPending: false)
                return
            }

            self.installAppDeactivationObserver()
            popover.show(relativeTo: anchorView.bounds, of: anchorView, preferredEdge: .maxY)
        }
    }

    // MARK: - Popover lifecycle

    public func popoverDidClose(_ notification: Notification) {
        sendResultIfPending(["dismissed": true])
        cleanupPopupReferences()
    }

    private func sendResultIfPending(_ data: [String: Any]) {
        guard !didSendResultForCurrentPopup else { return }
        didSendResultForCurrentPopup = true
        pendingResult?(data)
        pendingResult = nil
    }

    private func closeCurrentPopup(sendDismissedIfPending: Bool) {
        assert(Thread.isMainThread)
        if sendDismissedIfPending { sendResultIfPending(["dismissed": true]) }
        currentPopover?.delegate = nil
        if let p = currentPopover, p.isShown { p.close() }
        cleanupPopupReferences()
    }

    private func cleanupPopupReferences() {
        let obs = appDeactivationObserver
        appDeactivationObserver = nil
        if let obs = obs { NotificationCenter.default.removeObserver(obs) }

        currentPopover?.delegate = nil
        currentPopover = nil

        let win = anchorWindow
        anchorWindow = nil
        win?.orderOut(nil)
        win?.close()
    }

    private func installAppDeactivationObserver() {
        let old = appDeactivationObserver
        appDeactivationObserver = nil
        if let old = old { NotificationCenter.default.removeObserver(old) }

        appDeactivationObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: NSApp, queue: .main
        ) { [weak self] _ in
            guard let self = self, self.currentPopover?.isShown == true else { return }
            self.closeCurrentPopup(sendDismissedIfPending: true)
        }
    }

    // MARK: - Utilities

    private func runOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread { block() }
        else { DispatchQueue.main.async { block() } }
    }

    private func createAnchorView(at position: CGPoint?) -> NSView? {
        assert(Thread.isMainThread)

        let origin: CGPoint
        if let p = position {
            origin = p
        } else if let screen = NSScreen.main {
            origin = CGPoint(x: screen.visibleFrame.midX, y: screen.visibleFrame.midY)
        } else {
            origin = CGPoint(x: 100, y: 100)
        }

        let panel = NSPanel(
            contentRect: NSRect(x: origin.x, y: origin.y, width: 1, height: 1),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered, defer: false
        )
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.ignoresMouseEvents = true
        panel.level = .statusBar
        panel.hidesOnDeactivate = false
        panel.isFloatingPanel = true
        panel.collectionBehavior = [.canJoinAllSpaces, .transient, .ignoresCycle]
        panel.isReleasedWhenClosed = false

        let view = NSView(frame: NSRect(x: 0, y: 0, width: 1, height: 1))
        panel.contentView = view
        panel.orderFrontRegardless()

        self.anchorWindow = panel
        return view
    }
}
