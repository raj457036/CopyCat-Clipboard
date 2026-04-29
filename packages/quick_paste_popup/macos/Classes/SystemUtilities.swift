import Cocoa
import ApplicationServices

/// System-level utilities for cursor position and accessibility queries.
class SystemUtilities {
    private static func axErrorName(_ error: AXError) -> String {
        switch error {
            case .success: return "success"
            case .failure: return "failure"
            case .illegalArgument: return "illegalArgument"
            case .invalidUIElement: return "invalidUIElement"
            case .invalidUIElementObserver: return "invalidUIElementObserver"
            case .cannotComplete: return "cannotComplete"
            case .attributeUnsupported: return "attributeUnsupported"
            case .actionUnsupported: return "actionUnsupported"
            case .notificationUnsupported: return "notificationUnsupported"
            case .notImplemented: return "notImplemented"
            case .notificationAlreadyRegistered: return "notificationAlreadyRegistered"
            case .notificationNotRegistered: return "notificationNotRegistered"
            case .apiDisabled: return "apiDisabled"
            case .noValue: return "noValue"
            case .parameterizedAttributeUnsupported: return "parameterizedAttributeUnsupported"
            case .notEnoughPrecision: return "notEnoughPrecision"
            @unknown default: return "unknown(\(error.rawValue))"
        }
    }

    // MARK: - Mouse cursor

    /// Current mouse cursor position in AppKit screen coordinates.
    static func getCursorPosition() -> CGPoint? {
        let loc = NSEvent.mouseLocation
        guard !loc.x.isNaN && !loc.y.isNaN else { return nil }
        return loc
    }

    // MARK: - Focused app

    /// Frontmost application info (`name`, `bundleId`).
    static func getFocusedApp() -> [String: String]? {
        guard let app = NSWorkspace.shared.frontmostApplication else { return nil }
        return [
            "name": app.localizedName ?? "Unknown",
            "bundleId": app.bundleIdentifier ?? "",
        ]
    }

    // MARK: - Caret position

    /// Caret position via the system-wide focused element (requires the
    /// target app to be frontmost).
    static func getFocusedTextCaretPosition() -> CGPoint? {
        guard AXIsProcessTrusted() else { return nil }
        guard let element = getFocusedTextElement() else { return nil }
        return caretPositionFromElement(element)
    }

    /// Caret position by querying a specific app's AX tree by PID.
    /// The target app must be active for macOS to report its focused element.
    static func getCaretPositionForApp(pid: pid_t) -> CGPoint? {
        guard AXIsProcessTrusted() else { return nil }

        let appRef = AXUIElementCreateApplication(pid)
        var ref: CFTypeRef?
        let err = AXUIElementCopyAttributeValue(
            appRef, kAXFocusedUIElementAttribute as CFString, &ref
        )

        guard err == .success,
              let ref = ref, CFGetTypeID(ref) == AXUIElementGetTypeID() else {
            if err != .success {
                NSLog("[SystemUtilities] AXFocusedUIElement pid=\(pid) error=\(axErrorName(err))")
            }
            return nil
        }

        return caretPositionFromElement(unsafeBitCast(ref, to: AXUIElement.self))
    }

    // MARK: - Private helpers

    /// Extract the caret position from a focused AXUIElement, returned in
    /// AppKit screen coordinates.
    private static func caretPositionFromElement(_ element: AXUIElement) -> CGPoint? {
        guard let selectedRange = getSelectedTextRange(for: element) else { return nil }

        var anchor: CGPoint?

        // 1. Try the exact selected range.
        if let b = getBounds(for: element, range: selectedRange) {
            anchor = CGPoint(x: b.minX, y: b.maxY)
        }

        // 2. Zero-length insertion point.
        if anchor == nil {
            let loc = selectedRange.location + selectedRange.length
            if let b = getBounds(for: element, range: CFRange(location: loc, length: 0)) {
                anchor = CGPoint(x: b.minX, y: b.maxY)
            }

            // 3. Character immediately before the insertion point.
            if anchor == nil, loc > 0 {
                if let b = getBounds(for: element, range: CFRange(location: loc - 1, length: 1)) {
                    anchor = CGPoint(x: b.maxX, y: b.maxY)
                }
            }
        }

        // AX returns CG coordinates (top-left origin) → convert to AppKit (bottom-left).
        guard let cg = anchor else { return nil }
        return cgPointToAppKit(cg)
    }

    /// CG screen coordinates → AppKit screen coordinates.
    private static func cgPointToAppKit(_ point: CGPoint) -> CGPoint? {
        let screen = NSScreen.screens.first { NSMouseInRect(point, $0.frame, false) }
            ?? NSScreen.main
        guard let h = screen?.frame.height else { return nil }
        return CGPoint(x: point.x, y: h - point.y)
    }

    /// System-wide focused UI element, falling back to the frontmost app.
    static func getFocusedTextElement() -> AXUIElement? {
        let systemWide = AXUIElementCreateSystemWide()
        var ref: CFTypeRef?
        let err = AXUIElementCopyAttributeValue(
            systemWide, kAXFocusedUIElementAttribute as CFString, &ref
        )

        if err == .success, let ref = ref, CFGetTypeID(ref) == AXUIElementGetTypeID() {
            return unsafeBitCast(ref, to: AXUIElement.self)
        }

        // Fallback: query the frontmost app directly.
        guard let app = NSWorkspace.shared.frontmostApplication else { return nil }
        let appRef = AXUIElementCreateApplication(app.processIdentifier)
        var appFocused: CFTypeRef?
        let appErr = AXUIElementCopyAttributeValue(
            appRef, kAXFocusedUIElementAttribute as CFString, &appFocused
        )

        guard appErr == .success,
              let appFocused = appFocused,
              CFGetTypeID(appFocused) == AXUIElementGetTypeID() else {
            return nil
        }

        return unsafeBitCast(appFocused, to: AXUIElement.self)
    }

    static func getSelectedTextRange(for element: AXUIElement) -> CFRange? {
        var ref: CFTypeRef?
        let err = AXUIElementCopyAttributeValue(
            element, kAXSelectedTextRangeAttribute as CFString, &ref
        )

        guard err == .success,
              let ref = ref, CFGetTypeID(ref) == AXValueGetTypeID() else {
            return nil
        }

        let val = unsafeBitCast(ref, to: AXValue.self)
        guard AXValueGetType(val) == .cfRange else { return nil }

        var range = CFRange()
        guard AXValueGetValue(val, .cfRange, &range) else { return nil }
        return range
    }

    static func getBounds(for element: AXUIElement, range: CFRange) -> CGRect? {
        var mutableRange = range
        guard let rangeVal = AXValueCreate(.cfRange, &mutableRange) else { return nil }

        var ref: CFTypeRef?
        let err = AXUIElementCopyParameterizedAttributeValue(
            element, kAXBoundsForRangeParameterizedAttribute as CFString, rangeVal, &ref
        )

        guard err == .success,
              let ref = ref, CFGetTypeID(ref) == AXValueGetTypeID() else {
            return nil
        }

        let val = unsafeBitCast(ref, to: AXValue.self)
        guard AXValueGetType(val) == .cgRect else { return nil }

        var bounds = CGRect.zero
        guard AXValueGetValue(val, .cgRect, &bounds) else { return nil }
        return bounds
    }
}
