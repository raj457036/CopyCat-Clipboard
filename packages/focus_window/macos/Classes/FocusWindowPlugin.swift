import Cocoa
import FlutterMacOS
import AppKit
import AVFoundation
import Security
import ScriptingBridge


@objc protocol ChromeTab {
  @objc optional var URL: String { get }
  @objc optional var title: String { get }
}

@objc protocol ChromeWindow {
  @objc optional var activeTab: ChromeTab { get }
  @objc optional var mode: String { get }
}

extension SBObject: ChromeWindow, ChromeTab {}

@objc protocol ChromeProtocol {
  @objc optional func windows() -> [ChromeWindow]
}

extension SBApplication: ChromeProtocol {}


public class FocusWindowPlugin: NSObject, FlutterPlugin {
    private struct BrowserActivityCacheEntry {
        let url: String?
        let title: String?
        let createdAt: Date
    }

    private static let browserBundleIds: Set<String> = [
        "com.google.Chrome", "com.google.Chrome.beta", "com.google.Chrome.dev", "com.google.Chrome.canary",
        "com.brave.Browser", "com.brave.Browser.beta", "com.brave.Browser.nightly",
        "com.microsoft.edgemac", "com.microsoft.edgemac.Beta", "com.microsoft.edgemac.Dev", "com.microsoft.edgemac.Canary",
        "com.mighty.app", "com.ghostbrowser.gb1", "com.bookry.wavebox", "com.pushplaylabs.sidekick",
        "com.operasoftware.Opera", "com.operasoftware.OperaNext", "com.operasoftware.OperaDeveloper",
        "com.vivaldi.Vivaldi", "company.thebrowser.Browser",
        "com.apple.Safari", "com.apple.SafariTechnologyPreview", "com.mozilla.firefox"
    ]

    // Avoid repeated AppleEvent lookups during rapid copy bursts.
    private static let browserActivityCacheTtl: TimeInterval = 1.2

    private var observer: AXObserver?
    private var eventListening = false
    private var browserActivityCache: [String: BrowserActivityCacheEntry] = [:]
    public static var windowChangedCallback: WindowChanged = WindowChanged()
    public static var eventChannel: EventChannelHandler?



    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "focus_window", 
        binaryMessenger: registrar.messenger)
        eventChannel = EventChannelHandler(
            name: "focus_window_stream",
            messenger: registrar.messenger
        )
        let instance = FocusWindowPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func getActiveWindowId() -> Int? {
        if let frontApp = NSWorkspace.shared.frontmostApplication {
            let windowNumber = frontApp.processIdentifier
            return Int(windowNumber)
        } else {
            return nil
        }
    }
    
    public func setActiveWindow(windowId: Int) {
        // Retrieve window from given windowId processIdentifier
        let app = NSRunningApplication(processIdentifier: pid_t(windowId))
        app?.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
    }

    public func pasteContent() {
        let virtualKey: CGKeyCode = CGKeyCode(0x09)
        var flags: CGEventFlags = CGEventFlags()
        flags.insert(CGEventFlags.maskCommand)
        let eventKeyDownPress = CGEvent(keyboardEventSource: nil, virtualKey: virtualKey, keyDown: true);
        eventKeyDownPress!.flags = flags
        eventKeyDownPress!.post(tap: .cghidEventTap);
        usleep(10000)
        let eventKeyUpPress = CGEvent(keyboardEventSource: nil, virtualKey: virtualKey, keyDown: false);
        eventKeyUpPress!.flags = flags
        eventKeyUpPress!.post(tap: .cghidEventTap);
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getActiveWindowId":
                if let windowId = self.getActiveWindowId() {
                    result(windowId)
                } else {
                    result(nil)
                }
            case "setActiveWindowId":
                guard let args = call.arguments as? [String: Any],
                      let windowId = args["windowId"] as? Int else {
                    result(
                        FlutterError(
                            code: "INVALID_ARGUMENT",
                            message: "Invalid argument: windowId",
                            details: nil
                        )
                    )
                    return
                }
                self.setActiveWindow(windowId: windowId)
                result(nil)
            case "pasteContent":
                self.pasteContent()
                result(nil)
            // IMPL
            case "isAccessibilityPermissionGranted":
                isAccessibilityPermissionGranted(call, result: result)
                break
            case "requestAccessibilityPermission":
                requestAccessibilityPermission(call, result: result)
                break
            case "openAccessibilityPermissionSetting":
                openAccessibilityPermissionSetting(call, result: result)
                break
            case "getIcon":
                getIcon(call, result: result)
                break
            case "getActivity":
                getActivity(call, result: result)
                break
            case "startObserver":
                startListening()
                break
            case "stopObserver":
                stopListening()
                break
            case "isObserving":
                isListening(call, result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    //    Utilities
    @discardableResult
    private func runAppleScript(source: String?) -> String? {
        if (source == nil || source == ""){
            return nil;
        }
        var error: NSDictionary?
        if let result = NSAppleScript(source: source!) {
            let descriptor = result.executeAndReturnError(&error)
            if let error = error {
                print("[focus_window] AppleScript error: \(error)")
                return nil
            }
            return descriptor.stringValue
        }
        if (error != nil) {
            print(error!);
        }
        return nil
    }

    //    Private

    private func getIconForApplicationPath(_ applicationPath: String) -> NSImage? {
        let application = NSWorkspace.shared.icon(forFile: applicationPath)
        return application
    }
    
    private func getFrontApp() -> NSRunningApplication? {
        return NSWorkspace.shared.frontmostApplication;
    }
    
    private func getUrlForChromiumBasedBrowser(_ appId: String) -> String? {
        
        switch appId {
        case "com.google.Chrome", "com.google.Chrome.beta", "com.google.Chrome.dev", "com.google.Chrome.canary", "com.brave.Browser", "com.brave.Browser.beta", "com.brave.Browser.nightly", "com.microsoft.edgemac", "com.microsoft.edgemac.Beta", "com.microsoft.edgemac.Dev", "com.microsoft.edgemac.Canary", "com.mighty.app", "com.ghostbrowser.gb1", "com.bookry.wavebox", "com.pushplaylabs.sidekick", "com.vivaldi.Vivaldi", "company.thebrowser.Browser":
            
            let chromeObject: ChromeProtocol = SBApplication.init(bundleIdentifier: appId)!
            
            let frontWindow = chromeObject.windows?()[0]
            let activeTab = frontWindow?.activeTab
            return activeTab?.URL
        default:
            return nil
        }
        
    }

    private func getTitleForChromiumBasedBrowser(_ appId: String) -> String? {

        switch appId {
        case "com.google.Chrome", "com.google.Chrome.beta", "com.google.Chrome.dev", "com.google.Chrome.canary", "com.brave.Browser", "com.brave.Browser.beta", "com.brave.Browser.nightly", "com.microsoft.edgemac", "com.microsoft.edgemac.Beta", "com.microsoft.edgemac.Dev", "com.microsoft.edgemac.Canary", "com.mighty.app", "com.ghostbrowser.gb1", "com.bookry.wavebox", "com.pushplaylabs.sidekick", "com.vivaldi.Vivaldi", "company.thebrowser.Browser":

            let chromeObject: ChromeProtocol = SBApplication.init(bundleIdentifier: appId)!

            let frontWindow = chromeObject.windows?()[0]
            let activeTab = frontWindow?.activeTab
            return activeTab?.title
        default:
            return nil
        }

    }
    
    private func getActiveBrowserTabURLAppleScriptCommand(_ appId: String) -> String? {
        switch appId {
        case "com.google.Chrome", "com.google.Chrome.beta", "com.google.Chrome.dev", "com.google.Chrome.canary", "com.brave.Browser", "com.brave.Browser.beta", "com.brave.Browser.nightly", "com.microsoft.edgemac", "com.microsoft.edgemac.Beta", "com.microsoft.edgemac.Dev", "com.microsoft.edgemac.Canary", "com.mighty.app", "com.ghostbrowser.gb1", "com.bookry.wavebox", "com.pushplaylabs.sidekick", "com.operasoftware.Opera",  "com.operasoftware.OperaNext", "com.operasoftware.OperaDeveloper", "com.vivaldi.Vivaldi", "company.thebrowser.Browser":
            return "tell application id \"\(appId)\" to get the URL of active tab of front window"
        case "com.apple.Safari", "com.apple.SafariTechnologyPreview":
            return "tell application id \"\(appId)\" to do JavaScript \"document.URL\" in front document"
        default:
            return nil
        }
    }

    private func getActiveBrowserTabTitleAppleScriptCommand(_ appId: String) -> String? {
        switch appId {
        case "com.google.Chrome", "com.google.Chrome.beta", "com.google.Chrome.dev", "com.google.Chrome.canary", "com.brave.Browser", "com.brave.Browser.beta", "com.brave.Browser.nightly", "com.microsoft.edgemac", "com.microsoft.edgemac.Beta", "com.microsoft.edgemac.Dev", "com.microsoft.edgemac.Canary", "com.mighty.app", "com.ghostbrowser.gb1", "com.bookry.wavebox", "com.pushplaylabs.sidekick", "com.operasoftware.Opera",  "com.operasoftware.OperaNext", "com.operasoftware.OperaDeveloper", "com.vivaldi.Vivaldi", "company.thebrowser.Browser":
            return "tell application id \"\(appId)\" to get the title of active tab of front window"
        case "com.apple.Safari", "com.apple.SafariTechnologyPreview":
            return "tell application id \"\(appId)\" to return name of front document"
        default:
            return nil
        }
    }

    private func isBrowserApp(_ bundleId: String?) -> Bool {
        guard let bundleId = bundleId else { return false }
        return FocusWindowPlugin.browserBundleIds.contains(bundleId)
    }

    private func getCachedBrowserActivity(_ bundleId: String) -> BrowserActivityCacheEntry? {
        guard let cached = browserActivityCache[bundleId] else {
            return nil
        }

        let age = Date().timeIntervalSince(cached.createdAt)
        if age <= FocusWindowPlugin.browserActivityCacheTtl {
            return cached
        }

        browserActivityCache.removeValue(forKey: bundleId)
        return nil
    }

    private func setCachedBrowserActivity(
        _ bundleId: String,
        url: String?,
        title: String?
    ) {
        browserActivityCache[bundleId] = BrowserActivityCacheEntry(
            url: url,
            title: title,
            createdAt: Date()
        )
    }

    private func getWindowTitleUsingAccessibility(_ appPID: pid_t) -> String? {
        let appRef = AXUIElementCreateApplication(appPID)
        var focusedWindow: AnyObject? = nil
        
        // Try to get the focused window
        if AXUIElementCopyAttributeValue(
            appRef,
            kAXFocusedWindowAttribute as CFString,
            &focusedWindow
        ) == .success, let windowRef = focusedWindow {
            guard CFGetTypeID(windowRef) == AXUIElementGetTypeID() else {
                return nil
            }
            let window = windowRef as! AXUIElement
            var title: AnyObject? = nil
            if AXUIElementCopyAttributeValue(
                window,
                kAXTitleAttribute as CFString,
                &title
            ) == .success {
                return title as? String
            }
        }
        
        return nil
    }
    
    private func getWindowTitleUsingCGWindow(
        _ frontmostAppPID: pid_t,
        _ windows: [[String: Any]]
    ) -> String? {
        for window in windows {
            let windowOwnerPID = window[kCGWindowOwnerPID as String] as! pid_t
            if windowOwnerPID != frontmostAppPID {
                continue
            }
            if (window[kCGWindowAlpha as String] as! Double) == 0 {
                continue
            }
            
            if let windowTitle = window[kCGWindowName as String] as? String,
               !windowTitle.isEmpty {
                return windowTitle
            }
        }
        
        return nil
    }

    public func getActivity(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let args:[String: Any?] = call.arguments as! [String: Any?]
        let withIcon: Bool = (args["withIcon"] ?? false) as! Bool
        
        var activity: [String: Any?] = [
            "pid": -1,
            "app": "",
            "appFileName": "",
            "appFilePath": "",
            "identifier": "",
            "title": "",
            "url": "",
            "document": "",
            "icon": nil,
        ]
        
        guard
            let application = getFrontApp(),
            let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]]
        else {
            result(activity)
            return
        }
        
        let frontmostAppPID = application.processIdentifier
        let bundleId = application.bundleIdentifier
        
        // 1. Get document (opened file path)
        var elements = [AXUIElement]()
        var windowList: AnyObject? = nil
        let appRef = AXUIElementCreateApplication(frontmostAppPID)
        if AXUIElementCopyAttributeValue(appRef, "AXWindows" as CFString, &windowList) == .success {
            elements = windowList as! [AXUIElement]
        }

        var docRef: AnyObject? = nil
        if !elements.isEmpty && AXUIElementCopyAttributeValue(elements.first!, "AXDocument" as CFString, &docRef) == .success {
            let filePath = docRef as! String
            activity["document"] = filePath
        }
        
        // 2. Get window title (Accessibility API first, then CGWindow fallback)
        var windowTitle = getWindowTitleUsingAccessibility(frontmostAppPID) ?? ""
        if windowTitle.isEmpty {
            windowTitle = getWindowTitleUsingCGWindow(frontmostAppPID, windows) ?? ""
        }
        activity["title"] = windowTitle
        
        // 3. Get URL (browser-specific logic)
        var url: String? = nil
        var tabTitle: String? = nil
        
        if let bundleId = bundleId, isBrowserApp(bundleId) {
            if let cached = getCachedBrowserActivity(bundleId) {
                url = cached.url
                tabTitle = cached.title
            } else {
                // Try ScriptingBridge first
                url = getUrlForChromiumBasedBrowser(bundleId)
                tabTitle = getTitleForChromiumBasedBrowser(bundleId)
                
                // Fallback to AppleScript if needed.
                if url == nil {
                    let script = getActiveBrowserTabURLAppleScriptCommand(bundleId)
                    if let script = script {
                        url = runAppleScript(source: script)
                    }
                }

                if tabTitle == nil {
                    let titleScript = getActiveBrowserTabTitleAppleScriptCommand(bundleId)
                    if let titleScript = titleScript {
                        tabTitle = runAppleScript(source: titleScript)
                    }
                }

                setCachedBrowserActivity(bundleId, url: url, title: tabTitle)
            }
        }
        
        // Use browser tab title as window title if window title is empty
        if windowTitle.isEmpty && tabTitle != nil {
            activity["title"] = tabTitle
        }
        
        // 4. Get icon
        if withIcon {
            if let tiffData = application.icon?.tiffRepresentation,
               let imageRep = NSBitmapImageRep(data: tiffData),
               let pngData = imageRep.representation(
                using: NSBitmapImageRep.FileType.png,
                properties: [:]
               ) {
                activity["icon"] = pngData
            }
        }
        
        // 5. Populate app info
        activity["pid"] = application.processIdentifier
        activity["app"] = application.localizedName
        activity["appFileName"] = application.bundleURL?.lastPathComponent
        activity["appFilePath"] = application.bundleURL?.path
        activity["identifier"] = bundleId
        activity["url"] = url
        
        result(activity)
    }

    public func getIcon(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args:[String: Any] = call.arguments as! [String: Any]
        let applicationPath: String = args["applicationPath"] as! String
        let application = getIconForApplicationPath(applicationPath)
        if (application != nil) {
            let data = NSBitmapImageRep(data: application!.tiffRepresentation(using: .lzw, factor: .greatestFiniteMagnitude)!)!.representation(using: .png, properties: [:]);
            
            if (data != nil) {
                result(data)
            }
        }
    }

    public func isAccessibilityPermissionGranted(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let isGranted: Bool = AXIsProcessTrusted()
        result(isGranted)
    }
    
    public func requestAccessibilityPermission(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        let accessGranted: Bool = AXIsProcessTrustedWithOptions(options)
        result(accessGranted)
    }
    
    public func openAccessibilityPermissionSetting(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let opened = NSWorkspace.shared.open(
            URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
               )!
        )
        result(opened)
    }

    //    OBSERVERS
    
    public func isListening(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(eventListening)
    }
    
    public func startListening() {
        if (!eventListening)
        {
            NSWorkspace.shared.notificationCenter.addObserver(
                self, selector: #selector(focusedAppChanged),
                name: NSWorkspace.didActivateApplicationNotification,
                object: nil
            )
            eventListening = true
        }
    }
    
    public func stopListening() {
        if (eventListening) {
            NSWorkspace.shared.notificationCenter.removeObserver(NSWorkspace.didActivateApplicationNotification)
            eventListening = false
        }
    }

    
     @objc public func focusedAppChanged() {
        if observer != nil {
          CFRunLoopRemoveSource(
            RunLoop.current.getCFRunLoop(),
            AXObserverGetRunLoopSource(observer!),
            CFRunLoopMode.defaultMode)
        }

        let frontmost = NSWorkspace.shared.frontmostApplication!
        let pid = frontmost.processIdentifier
        let focusedApp = AXUIElementCreateApplication(pid)
        
        AXObserverCreate(
          pid,
          {
            (
              _ axObserver: AXObserver,
              axElement: AXUIElement,
              notification: CFString,
              userData: UnsafeMutableRawPointer?
            ) -> Void in
            
            if notification == kAXFocusedWindowChangedNotification as CFString {
                FocusWindowPlugin.windowChangedCallback.focusedWindowChanged(axObserver, window: axElement)
            } else {
                let event: Dictionary<String, String> = [
                    "type": "TabChanged",
                ]
                try? FocusWindowPlugin.eventChannel?.success(event: event)
            }
          }, &observer)

        let selfPtr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        AXObserverAddNotification(
          observer!, focusedApp, kAXFocusedWindowChangedNotification as CFString, selfPtr)

        CFRunLoopAddSource(
          RunLoop.current.getCFRunLoop(),
          AXObserverGetRunLoopSource(observer!),
          CFRunLoopMode.defaultMode)

        var focusedWindow: AnyObject?
        AXUIElementCopyAttributeValue(focusedApp, kAXFocusedWindowAttribute as CFString, &focusedWindow)

        if focusedWindow != nil {
            FocusWindowPlugin.windowChangedCallback.focusedWindowChanged(observer!, window: focusedWindow as! AXUIElement)
        }
      }
}
