import Cocoa

/// View controller for the quick paste popup list
class QuickPastePopupViewController: NSViewController {
    // MARK: - Properties
    
    var items: [[String: Any]] = []
    var selectedIndex: Int = 0
    var selectionColor: NSColor = .controlAccentColor
    var completionHandler: ((String?, Bool, String?) -> Void)?
    
    private let itemHeight: CGFloat = 56
    private let padding: CGFloat = 0
    private let paddingBottom: CGFloat = 10
    private let maxHeight: CGFloat = 400
    private let minWidth: CGFloat = 360
    
    private var tableView: NSTableView?
    private var scrollView: NSScrollView?
    private var emptyStateLabel: NSTextField?
    private var hasDismissed = false
    private var isAnimatingDismissal = false
    
    // MARK: - Lifecycle
    
    override func loadView() {
        let calculatedHeight = min(max(CGFloat(items.count) * itemHeight + padding * 2, 120), maxHeight)
        let frame = NSRect(x: 0, y: 0, width: minWidth, height: calculatedHeight)
        let view = NSVisualEffectView(frame: frame)
        view.material = .popover
        view.blendingMode = .behindWindow
        view.state = .active
        view.wantsLayer = true
        view.layer?.cornerRadius = 16
        view.layer?.masksToBounds = true
        view.layer?.borderWidth = 0
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("[QuickPastePopupViewController] viewDidLoad items=\(items.count)")
        setupUI()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // Keep focus in the originating app (emoji-picker style behavior).
        // Avoid forcing this popup to become first responder.
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        syncTableWidthToViewport()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        let contentView = self.view

        if items.isEmpty {
            let label = NSTextField(labelWithString: "Empty clipboard")
            label.font = NSFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = NSColor.secondaryLabelColor
            label.alignment = .center
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
            emptyStateLabel = label
            NSLog("[QuickPastePopupViewController] Showing empty clipboard state")
            return
        }
        
        // Create scroll view
        let scrollView = NSScrollView()
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.horizontalScrollElasticity = .none
        scrollView.contentInsets = NSEdgeInsets(top: 1, left: 1, bottom: 50, right: 1)
        
        // Create table view
        let tableView = NSTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.headerView = nil
        tableView.rowHeight = itemHeight
        tableView.intercellSpacing = NSSize(width: 0, height: 8)
        tableView.backgroundColor = NSColor.clear
        tableView.selectionHighlightStyle = .none
        tableView.focusRingType = .none
        tableView.allowsColumnResizing = false
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        
        // Add column
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("itemColumn"))
        column.resizingMask = .autoresizingMask
        column.width = minWidth - padding
        column.dataCell = ClipboardItemCell()
        tableView.addTableColumn(column)
        
        scrollView.documentView = tableView
        self.tableView = tableView
        self.scrollView = scrollView
        
        // Add to view
        contentView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingBottom),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
        
        // Select first item
        tableView.selectRowIndexes(NSIndexSet(index: 0) as IndexSet, byExtendingSelection: false)
        selectedIndex = 0
        syncTableWidthToViewport()
    }

    private func syncTableWidthToViewport() {
        guard let tableView, let scrollView else {
            return
        }

        let horizontalInsets = scrollView.contentInsets.left + scrollView.contentInsets.right
        let availableWidth = scrollView.contentView.bounds.width - horizontalInsets
        let viewportWidth = max(availableWidth, minWidth - padding)
        if let column = tableView.tableColumns.first {
            column.width = viewportWidth
        }

        var frame = tableView.frame
        if abs(frame.width - viewportWidth) > 0.5 {
            frame.size.width = viewportWidth
            tableView.frame = frame
        }
    }
    
    // MARK: - Keyboard Handling
    
    override var acceptsFirstResponder: Bool {
        return true
    }

    func scrollToRowSmooth(_ row: Int, tableView: NSTableView) {
        guard let scrollView = tableView.enclosingScrollView else { return }

        let rowRect = tableView.rect(ofRow: row)
        let targetPoint = NSPoint(x: 0, y: rowRect.origin.y)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            scrollView.contentView.animator().setBoundsOrigin(targetPoint)
            scrollView.reflectScrolledClipView(scrollView.contentView)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if items.isEmpty {
            switch event.keyCode {
            case 0x24, 0x33, 0x35: // Enter/Delete/Escape dismiss
                dismiss(dismissed: true)
                return
            default:
                super.keyDown(with: event)
                return
            }
        }

        guard let tableView = tableView else {
            super.keyDown(with: event)
            return
        }
        
        switch event.keyCode {
        case 0x24: // Return/Enter key
            handleSelection()
            
        case 0x33: // Backspace/Delete key - dismiss
            dismiss(dismissed: true)
            
        case 0x35: // Escape key
            dismiss(dismissed: true)
            
        case 0x7E: // Up arrow key
            if selectedIndex > 0 {
                selectedIndex -= 1
                tableView.selectRowIndexes(NSIndexSet(index: selectedIndex) as IndexSet, byExtendingSelection: false)
                tableView.scrollRowToVisible(selectedIndex)
            }
            
        case 0x7D: // Down arrow key
            if selectedIndex < items.count - 1 {
                selectedIndex += 1
                tableView.selectRowIndexes(NSIndexSet(index: selectedIndex) as IndexSet, byExtendingSelection: false)
                tableView.scrollRowToVisible(selectedIndex+1)
            }
            
        default:
            super.keyDown(with: event)
        }
    }
    
    // MARK: - Selection Handling
    
    private func handleSelection() {
        guard selectedIndex >= 0 && selectedIndex < items.count else {
            NSLog("[QuickPastePopupViewController] Selection out of range index=\(selectedIndex) items=\(items.count)")
            dismiss(dismissed: true)
            return
        }
        
        let selectedItem = items[selectedIndex]
        
        // Extract the item ID
        guard let itemId = selectedItem["id"] as? String else {
            NSLog("[QuickPastePopupViewController] Selected item missing id")
            dismiss(error: "Invalid item ID")
            return
        }
        
        dismiss(selectedItemId: itemId)
    }
    
    // MARK: - Dismissal
    
    private func dismiss(selectedItemId: String? = nil, dismissed: Bool = false, error: String? = nil) {
        if hasDismissed || isAnimatingDismissal {
            return
        }

        let completeDismissal = {
            self.hasDismissed = true
            NSLog(
                "[QuickPastePopupViewController] Dismiss selectedItemId=\(String(describing: selectedItemId)) dismissed=\(dismissed) error=\(String(describing: error))"
            )
            self.completionHandler?(selectedItemId, dismissed, error)
        }

        guard let window = view.window else {
            completeDismissal()
            return
        }

        isAnimatingDismissal = true
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.12
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 0.0
        }, completionHandler: {
            self.isAnimatingDismissal = false
            completeDismissal()
        })
    }

}

// MARK: - NSTableViewDataSource

extension QuickPastePopupViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
}

// MARK: - NSTableViewDelegate

extension QuickPastePopupViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard row >= 0 && row < items.count else {
            return nil
        }
        
        let item = items[row]
        let isImage = item["isImage"] as? Bool ?? false
        let text = item["text"] as? String ?? ""
        let appIconPath = item["appIconPath"] as? String
        let previewImagePath = item["previewImagePath"] as? String
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("itemCell"), owner: nil)
            as? ClipboardItemCellView ?? ClipboardItemCellView()
        
        cell.configure(
            title: text.prefix(100).trimmingCharacters(in: .whitespacesAndNewlines),
            appIconPath: appIconPath,
            previewImagePath: previewImagePath,
            isImage: isImage,
            selected: row == selectedIndex,
            selectionColor: selectionColor
        )
        
        return cell
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return ClipboardItemRowView()
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        selectedIndex = row
        return true
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = tableView else {
            return
        }
        selectedIndex = tableView.selectedRow
        tableView.enumerateAvailableRowViews { _, row in
            if let cell = tableView.view(
                atColumn: 0,
                row: row,
                makeIfNecessary: false
            ) as? ClipboardItemCellView {
                cell.setSelected(
                    row == self.selectedIndex,
                    selectionColor: self.selectionColor
                )
            }
        }
    }
}

// MARK: - Cell Views

class ClipboardItemCell: NSTextFieldCell {
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        return rect.insetBy(dx: 8, dy: 4)
    }
    
    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        return rect.insetBy(dx: 8, dy: 4)
    }
}

class ClipboardItemCellView: NSTableCellView {
    private let iconView = NSImageView()
    private let iconFallbackLabel = NSTextField(labelWithString: "")
    private let iconContainer = NSView()
    private let titleLabel = NSTextField(labelWithString: "")
    private let previewImageView = NSImageView()
    private var titleTrailingToPreviewConstraint: NSLayoutConstraint?
    private var titleTrailingToEdgeConstraint: NSLayoutConstraint?
    private var previewWidthConstraint: NSLayoutConstraint?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        wantsLayer = true
        layer?.cornerRadius = 12

        iconContainer.wantsLayer = true
        iconContainer.layer?.cornerRadius = 9
        iconContainer.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.08).cgColor

        iconView.imageScaling = .scaleAxesIndependently
        iconView.wantsLayer = true
        iconView.layer?.cornerRadius = 9
        iconView.layer?.masksToBounds = true

        iconFallbackLabel.font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        iconFallbackLabel.textColor = NSColor.secondaryLabelColor
        iconFallbackLabel.alignment = .center

        titleLabel.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = NSColor.labelColor
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.maximumNumberOfLines = 2
        titleLabel.cell?.wraps = true
        titleLabel.cell?.usesSingleLineMode = false
        titleLabel.cell?.lineBreakMode = .byCharWrapping
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        previewImageView.imageScaling = .scaleAxesIndependently
        previewImageView.wantsLayer = true
        previewImageView.layer?.cornerRadius = 8
        previewImageView.layer?.masksToBounds = true
        previewImageView.isHidden = true
        previewImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        iconContainer.addSubview(iconFallbackLabel)
        addSubview(titleLabel)
        addSubview(previewImageView)

        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconFallbackLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleTrailingToPreviewConstraint = titleLabel.trailingAnchor.constraint(equalTo: previewImageView.leadingAnchor, constant: -4)
        titleTrailingToEdgeConstraint = titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        previewWidthConstraint = previewImageView.widthAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 28),
            iconContainer.heightAnchor.constraint(equalToConstant: 28),

            iconView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor),
            iconView.topAnchor.constraint(equalTo: iconContainer.topAnchor),
            iconView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor),

            iconFallbackLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconFallbackLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -6),

            previewImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            previewImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            previewImageView.heightAnchor.constraint(equalToConstant: 34),
            titleTrailingToPreviewConstraint!,
            titleTrailingToEdgeConstraint!,
            previewWidthConstraint!,
        ])
    }

    func configure(
        title: String,
        appIconPath: String?,
        previewImagePath: String?,
        isImage: Bool,
        selected: Bool,
        selectionColor: NSColor
    ) {
        titleLabel.stringValue = title
        setSelected(selected, selectionColor: selectionColor)

        if let appIconPath,
           let appIcon = NSImage(contentsOfFile: appIconPath) {
            iconView.image = appIcon
            iconView.isHidden = false
            iconFallbackLabel.isHidden = true
        } else {
            iconView.image = nil
            iconView.isHidden = true
            iconFallbackLabel.stringValue = "•"
            iconFallbackLabel.isHidden = false
        }

        if isImage,
           let previewImagePath,
           let previewImage = NSImage(contentsOfFile: previewImagePath) {
            previewImageView.image = previewImage
            previewImageView.isHidden = false
            previewWidthConstraint?.constant = 34
            titleTrailingToPreviewConstraint?.isActive = true
            titleTrailingToEdgeConstraint?.isActive = false
        } else {
            previewImageView.image = nil
            previewImageView.isHidden = true
            previewWidthConstraint?.constant = 0
            titleTrailingToPreviewConstraint?.isActive = false
            titleTrailingToEdgeConstraint?.isActive = true
        }
    }

    func setSelected(_ selected: Bool, selectionColor: NSColor = .controlAccentColor) {
        layer?.backgroundColor = selected
            ? selectionColor.withAlphaComponent(0.34).cgColor
            : NSColor.white.withAlphaComponent(0.03).cgColor
        layer?.borderWidth = 1
        layer?.borderColor = selected
            ? selectionColor.withAlphaComponent(0.75).cgColor
            : NSColor.white.withAlphaComponent(0.06).cgColor
    }
}

extension NSColor {
    convenience init(argb: UInt32) {
        let alpha = CGFloat((argb >> 24) & 0xFF) / 255.0
        let red = CGFloat((argb >> 16) & 0xFF) / 255.0
        let green = CGFloat((argb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(argb & 0xFF) / 255.0
        self.init(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
}

class ClipboardItemRowView: NSTableRowView {
    override var isEmphasized: Bool {
        get { return true }
        set { }
    }

    override func drawSelection(in dirtyRect: NSRect) {
        // Selection is rendered by ClipboardItemCellView.setSelected using the
        // theme color from the plugin. Keep row-level selection fully transparent
        // to avoid AppKit accent color blending.
    }

    override func drawBackground(in dirtyRect: NSRect) {
        if isSelected {
            return
        }

        let backgroundRect = bounds.insetBy(dx: 1, dy: 1)
        let path = NSBezierPath(roundedRect: backgroundRect, xRadius: 12, yRadius: 12)
        NSColor.clear.setFill()
        path.fill()
    }
}
