import Cocoa
import AppKit
import ApplicationServices

/// Handles pasteboard operations and pasting to other applications
class PasteboardHelper {
    /// Attempt to replace the currently selected text in the focused editable element.
    /// Falls back to false when the target app does not expose an editable AX value.
    static func insertTextDirectToFocusedElement(_ text: String) -> Bool {
        guard AXIsProcessTrusted() else {
            return false
        }

        guard let focusedElement = SystemUtilities.getFocusedTextElement(),
              let selectedRange = SystemUtilities.getSelectedTextRange(for: focusedElement) else {
            return false
        }

        var valueRef: CFTypeRef?
        let valueResult = AXUIElementCopyAttributeValue(
            focusedElement,
            kAXValueAttribute as CFString,
            &valueRef
        )

        guard valueResult == .success,
              let currentValue = valueRef as? String else {
            return false
        }

        let nsCurrentValue = currentValue as NSString
        let insertionLocation = max(0, min(selectedRange.location, nsCurrentValue.length))
        let insertionLength = max(0, min(selectedRange.length, nsCurrentValue.length - insertionLocation))
        let replacementRange = NSRange(location: insertionLocation, length: insertionLength)
        let updatedValue = nsCurrentValue.replacingCharacters(in: replacementRange, with: text)

        let setResult = AXUIElementSetAttributeValue(
            focusedElement,
            kAXValueAttribute as CFString,
            updatedValue as CFTypeRef
        )

        guard setResult == .success else {
            return false
        }

        let insertedLength = (text as NSString).length
        var updatedRange = CFRange(location: insertionLocation + insertedLength, length: 0)
        if let updatedRangeValue = AXValueCreate(.cfRange, &updatedRange) {
            _ = AXUIElementSetAttributeValue(
                focusedElement,
                kAXSelectedTextRangeAttribute as CFString,
                updatedRangeValue
            )
        }

        return true
    }

    /// Paste text to the currently active application using simulated keyboard input
    /// This method:
    /// 1. Gets the focused app info before pasting
    /// 2. Sets the pasteboard with the text
    /// 3. Sends Cmd+V to the active app
    static func pasteTextToActiveApp(_ text: String) -> Bool {
        // Verify that there is a focused app
        guard SystemUtilities.getFocusedApp() != nil else {
            return false
        }
        
        // Set the text to the general pasteboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let success = pasteboard.setString(text, forType: .string)
        
        guard success else {
            return false
        }
        
        // Give the pasteboard a moment to register
        Thread.sleep(forTimeInterval: 0.05)
        
        // Send Cmd+V to paste
        return sendPasteCommand()
    }
    
    /// Paste multiple strings to the active app
    static func pasteStringsToActiveApp(_ strings: [String]) -> Bool {
        guard !strings.isEmpty else {
            return false
        }
        
        // Join strings with newlines
        let combinedText = strings.joined(separator: "\n")
        return pasteTextToActiveApp(combinedText)
    }
    
    /// Send Cmd+V keyboard command to paste
    private static func sendPasteCommand() -> Bool {
        let source = CGEventSource(stateID: .combinedSessionState)
        
        // Create key down for Cmd+V
        guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true) else {
            return false
        }
        keyDown.flags = .maskCommand
        
        // Create key up for Cmd+V
        guard let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false) else {
            return false
        }
        keyUp.flags = .maskCommand
        
        // Post the events
        keyDown.post(tap: .cghidEventTap)
        Thread.sleep(forTimeInterval: 0.05)
        keyUp.post(tap: .cghidEventTap)
        
        return true
    }
    
    /// Get text from the clipboard item data dictionary
    static func extractText(from itemData: [String: Any]) -> String? {
        if let text = itemData["text"] as? String {
            return text
        }
        return nil
    }
}
