import Cocoa

/// Manages the quick paste popup window lifecycle and positioning
class QuickPastePopupWindow: NSWindow, NSWindowDelegate {
    convenience init(viewController: QuickPastePopupViewController, cursorPosition: CGPoint?) {
        NSLog("[QuickPastePopupWindow] Initializing with items=\(viewController.items.count) cursor=\(String(describing: cursorPosition))")
        let frame = Self.calculateWindowFrame(
            itemCount: viewController.items.count,
            cursorPosition: cursorPosition
        )

        NSLog("[QuickPastePopupWindow] Calculated frame=\(frame)")
        
        self.init(contentRect: frame, styleMask: [.titled, .closable], backing: .buffered, defer: false)
        
        // Configure window
        self.contentViewController = viewController
        self.delegate = self
        self.isReleasedWhenClosed = true
        self.backgroundColor = NSColor.controlBackgroundColor
        self.level = .floating
        self.isOpaque = false
        self.hasShadow = true
        self.hidesOnDeactivate = true
        
        // Remove title bar
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        
        // Set appearance
        self.appearance = NSAppearance(named: .aqua)
        
        // Make it always on top
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
    }
    
    /// Calculate the optimal window frame based on item count and cursor position
    private static func calculateWindowFrame(itemCount: Int, cursorPosition: CGPoint?) -> NSRect {
        let itemHeight: CGFloat = 56
        let padding: CGFloat = 12
        let minWidth: CGFloat = 300
        let maxHeight: CGFloat = 400
        let minHeight: CGFloat = 120
        
        // Calculate height based on item count
        var height = CGFloat(itemCount) * itemHeight + padding * 2
        height = min(height, maxHeight)
        height = max(height, minHeight)
        
        var origin: CGPoint
        
        // Try to position at cursor first
        if let cursor = cursorPosition,
           let screen = NSScreen.main {
            
            let screenFrame = screen.visibleFrame
            
            // Position window below cursor with some offset
            var x = cursor.x - minWidth / 2
            var y = cursor.y - height - 10 // 10pt offset below cursor
            
            // Constrain to screen bounds
            if x + minWidth > screenFrame.maxX {
                x = screenFrame.maxX - minWidth - 10
            }
            if x < screenFrame.minX {
                x = screenFrame.minX + 10
            }
            
            if y < screenFrame.minY {
                // If not enough space below, position above cursor
                y = cursor.y + 10
            }
            
            origin = CGPoint(x: x, y: y)
        } else {
            // Fallback: center on main screen
            guard let screen = NSScreen.main else {
                origin = CGPoint(x: 100, y: 100)
                let fallbackFrame = NSRect(origin: origin, size: NSSize(width: minWidth, height: height))
                return fallbackFrame
            }
            
            let screenFrame = screen.visibleFrame
            let centerX = screenFrame.midX - minWidth / 2
            let centerY = screenFrame.midY - height / 2
            
            origin = CGPoint(x: centerX, y: centerY)
        }
        
        return NSRect(origin: origin, size: NSSize(width: minWidth, height: height))
    }
    
    /// Present the window to the user
    func presentPopup() {
        NSLog("[QuickPastePopupWindow] Present popup")
        self.makeKeyAndOrderFront(nil)
    }

    func windowDidResignKey(_ notification: Notification) {
        NSLog("[QuickPastePopupWindow] Window resigned key, closing popup")
        self.close()
    }

    func windowDidResignMain(_ notification: Notification) {
        NSLog("[QuickPastePopupWindow] Window resigned main, closing popup")
        self.close()
    }
}
