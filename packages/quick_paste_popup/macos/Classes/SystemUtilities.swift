import Cocoa
import ApplicationServices

/// Handles system-level operations like cursor position and focused app detection
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

    /// Get the current mouse cursor position on screen
    static func getCursorPosition() -> CGPoint? {
        // Get the current mouse location in screen coordinates
        let mouseLocation = NSEvent.mouseLocation
        
        // Validate that the location is within valid screen bounds
        guard !mouseLocation.x.isNaN && !mouseLocation.y.isNaN else {
            NSLog("[SystemUtilities] Invalid cursor coordinates")
            return nil
        }

        NSLog("[SystemUtilities] Cursor x=\(mouseLocation.x) y=\(mouseLocation.y)")
        
        return mouseLocation
    }
    
    /// Get information about the currently focused application
    /// Returns a dictionary with 'name' and 'bundleId' keys
    static func getFocusedApp() -> [String: String]? {
        let workspace = NSWorkspace.shared
        
        // Get the frontmost (active) application
        guard let activeApp = workspace.frontmostApplication else {
            NSLog("[SystemUtilities] No frontmost application")
            return nil
        }

        NSLog("[SystemUtilities] Frontmost app name=\(activeApp.localizedName ?? "Unknown") bundle=\(activeApp.bundleIdentifier ?? "")")
        
        return [
            "name": activeApp.localizedName ?? "Unknown",
            "bundleId": activeApp.bundleIdentifier ?? "",
        ]
    }

    static func getFocusedTextCaretPosition() -> CGPoint? {
        guard AXIsProcessTrusted() else {
            NSLog("[SystemUtilities] Accessibility permission unavailable for caret lookup")
            return nil
        }

        guard let focusedElement = getFocusedTextElement() else {
            NSLog("[SystemUtilities] Focused text element unavailable")
            return nil
        }

        guard let selectedRange = getSelectedTextRange(for: focusedElement) else {
            NSLog("[SystemUtilities] Selected text range unavailable")
            return nil
        }

        NSLog(
            "[SystemUtilities] Selected text range location=\(selectedRange.location) length=\(selectedRange.length)"
        )

        if let caretBounds = getBounds(for: focusedElement, range: selectedRange) {
            let anchor = CGPoint(x: caretBounds.minX, y: caretBounds.maxY)
            NSLog("[SystemUtilities] Caret anchor x=\(anchor.x) y=\(anchor.y)")
            return anchor
        }

        NSLog("[SystemUtilities] Bounds for selected text range unavailable")

        // Some editors do not return bounds for a 0-length range. Retry near
        // the insertion point using neighboring ranges.
        let insertionLocation = selectedRange.location + selectedRange.length
        var insertionRange = CFRange(location: insertionLocation, length: 0)
        if let caretBounds = getBounds(for: focusedElement, range: insertionRange) {
            let anchor = CGPoint(x: caretBounds.minX, y: caretBounds.maxY)
            NSLog("[SystemUtilities] Caret fallback(anchor insertion) x=\(anchor.x) y=\(anchor.y)")
            return anchor
        }

        NSLog("[SystemUtilities] Bounds for insertion range unavailable")

        if insertionLocation > 0 {
            var previousCharRange = CFRange(location: insertionLocation - 1, length: 1)
            if let previousBounds = getBounds(for: focusedElement, range: previousCharRange) {
                let anchor = CGPoint(x: previousBounds.maxX, y: previousBounds.maxY)
                NSLog("[SystemUtilities] Caret fallback(previous char) x=\(anchor.x) y=\(anchor.y)")
                return anchor
            }

            NSLog("[SystemUtilities] Bounds for previous character range unavailable")
        }

        return nil
    }

    static func getFocusedTextElement() -> AXUIElement? {
        let systemWideElement = AXUIElementCreateSystemWide()
        var systemFocusedRef: CFTypeRef?
        let systemResult = AXUIElementCopyAttributeValue(
            systemWideElement,
            kAXFocusedUIElementAttribute as CFString,
            &systemFocusedRef
        )

        NSLog("[SystemUtilities] System-wide AXFocusedUIElement result=\(axErrorName(systemResult))")

        if systemResult == .success,
           let systemFocusedRef,
           CFGetTypeID(systemFocusedRef) == AXUIElementGetTypeID() {
            NSLog("[SystemUtilities] Using system-wide focused element")
            return unsafeBitCast(systemFocusedRef, to: AXUIElement.self)
        }

        if systemResult == .success {
            NSLog("[SystemUtilities] System-wide focused element had unexpected type")
        }

        guard let activeApp = NSWorkspace.shared.frontmostApplication else {
            NSLog("[SystemUtilities] No frontmost app available for fallback focused element lookup")
            return nil
        }

        let activeAppName = activeApp.localizedName ?? "Unknown"

        NSLog(
            "[SystemUtilities] Falling back to frontmost app focused element lookup pid=\(activeApp.processIdentifier) name=\(activeAppName)"
        )

        let appRef = AXUIElementCreateApplication(activeApp.processIdentifier)
        var focusedElementRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            appRef,
            kAXFocusedUIElementAttribute as CFString,
            &focusedElementRef
        )

        NSLog("[SystemUtilities] Frontmost app AXFocusedUIElement result=\(axErrorName(result))")

        guard result == .success,
              let focusedElementRef,
              CFGetTypeID(focusedElementRef) == AXUIElementGetTypeID() else {
            return nil
        }

        NSLog("[SystemUtilities] Using frontmost app focused element")

        return unsafeBitCast(focusedElementRef, to: AXUIElement.self)
    }

    static func getSelectedTextRange(for element: AXUIElement) -> CFRange? {
        var selectedRangeRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            element,
            kAXSelectedTextRangeAttribute as CFString,
            &selectedRangeRef
        )

                NSLog("[SystemUtilities] AXSelectedTextRange result=\(axErrorName(result))")

        guard result == .success,
              let selectedRangeRef,
              CFGetTypeID(selectedRangeRef) == AXValueGetTypeID() else {
            return nil
        }

        let selectedRangeValue = unsafeBitCast(selectedRangeRef, to: AXValue.self)
        guard AXValueGetType(selectedRangeValue) == .cfRange else {
            return nil
        }

        var selectedRange = CFRange()
        guard AXValueGetValue(selectedRangeValue, .cfRange, &selectedRange) else {
            return nil
        }

        return selectedRange
    }

    static func getBounds(for element: AXUIElement, range: CFRange) -> CGRect? {
        var mutableRange = range
        guard let rangeValue = AXValueCreate(.cfRange, &mutableRange) else {
            return nil
        }

        var boundsRef: CFTypeRef?
        let result = AXUIElementCopyParameterizedAttributeValue(
            element,
            kAXBoundsForRangeParameterizedAttribute as CFString,
            rangeValue,
            &boundsRef
        )

        NSLog(
            "[SystemUtilities] AXBoundsForRange result=\(axErrorName(result)) location=\(range.location) length=\(range.length)"
        )

        guard result == .success,
              let boundsRef,
              CFGetTypeID(boundsRef) == AXValueGetTypeID() else {
            return nil
        }

        let boundsValue = unsafeBitCast(boundsRef, to: AXValue.self)
        guard AXValueGetType(boundsValue) == .cgRect else {
            return nil
        }

        var bounds = CGRect.zero
        guard AXValueGetValue(boundsValue, .cgRect, &bounds) else {
            return nil
        }

        return bounds
    }
    
    /// Get the main screen's visible frame (considering menu bar and dock)
    static func getMainScreenVisibleFrame() -> NSRect? {
        guard let mainScreen = NSScreen.main else {
            return nil
        }
        return mainScreen.visibleFrame
    }
    
    /// Get the full frame of the main screen
    static func getMainScreenFrame() -> NSRect? {
        guard let mainScreen = NSScreen.main else {
            return nil
        }
        return mainScreen.frame
    }
}
