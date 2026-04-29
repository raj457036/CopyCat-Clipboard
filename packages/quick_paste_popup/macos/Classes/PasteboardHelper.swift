import Cocoa
import ApplicationServices

/// Handles direct text insertion via the Accessibility API.
class PasteboardHelper {
    /// Replace the currently selected text in the focused editable element.
    /// Returns `false` when the target app doesn't expose an editable AX value.
    static func insertTextDirectToFocusedElement(_ text: String) -> Bool {
        guard AXIsProcessTrusted() else { return false }

        guard let element = SystemUtilities.getFocusedTextElement(),
              let selectedRange = SystemUtilities.getSelectedTextRange(for: element) else {
            return false
        }

        var valueRef: CFTypeRef?
        let err = AXUIElementCopyAttributeValue(element, kAXValueAttribute as CFString, &valueRef)
        guard err == .success, let currentValue = valueRef as? String else { return false }

        let ns = currentValue as NSString
        let loc = max(0, min(selectedRange.location, ns.length))
        let len = max(0, min(selectedRange.length, ns.length - loc))
        let updated = ns.replacingCharacters(in: NSRange(location: loc, length: len), with: text)

        let setErr = AXUIElementSetAttributeValue(
            element, kAXValueAttribute as CFString, updated as CFTypeRef
        )
        guard setErr == .success else { return false }

        // Move cursor to end of inserted text.
        var newRange = CFRange(location: loc + (text as NSString).length, length: 0)
        if let val = AXValueCreate(.cfRange, &newRange) {
            _ = AXUIElementSetAttributeValue(
                element, kAXSelectedTextRangeAttribute as CFString, val
            )
        }

        return true
    }
}
