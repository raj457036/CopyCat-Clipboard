import Cocoa
import SwiftUI

/// View controller for the quick paste popup list
class QuickPastePopupViewController: NSViewController {
    // MARK: - Properties
    
    var items: [[String: Any]] = []
    var selectedIndex: Int = 0
    var selectionColor: NSColor = .controlAccentColor
    var completionHandler: ((String?, Bool, String?) -> Void)?
    
    private let itemHeight: CGFloat = 56
    private let mediumItemHeight: CGFloat = 72
    private let imageItemHeight: CGFloat = 92
    private let maxTextLines: Int = 4
    private let padding: CGFloat = 0
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
        
        // scroll view
        let scrollView = NSScrollView()
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.horizontalScrollElasticity = .none
        scrollView.contentInsets = NSEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        
        // table view
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
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])
        
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
            if !items.isEmpty {
                tableView.noteHeightOfRows(withIndexesChanged: IndexSet(integersIn: 0..<items.count))
            }
        }
    }

    private func rowHeight(for row: Int, tableView: NSTableView) -> CGFloat {
        guard row >= 0 && row < items.count else {
            return itemHeight
        }

        let item = items[row]
        let isImage = item["isImage"] as? Bool ?? false
        let text = (item["text"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        // Keep image rows noticeably taller so preview thumbnails are useful.
        var resolvedHeight = isImage ? imageItemHeight : itemHeight

        guard !text.isEmpty else {
            return resolvedHeight
        }

        let font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        let lineHeight = max(font.boundingRectForFont.size.height, 1)

        // leading(5) + icon(28) + iconGap(6) + trailing(4) + preview(optional).
        var textWidth = (tableView.tableColumns.first?.width ?? minWidth)
        textWidth -= (5 + 28 + 6 + 4)
        if isImage {
            textWidth -= (34 + 4)
        }

        let bounded = (text as NSString).boundingRect(
            with: NSSize(width: max(textWidth, 80), height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        let measuredLines = Int(ceil(bounded.height / lineHeight))
        let lines = max(1, min(maxTextLines, measuredLines))

        if lines >= 4 {
            resolvedHeight = max(resolvedHeight, imageItemHeight)
        } else if lines >= 3 {
            resolvedHeight = max(resolvedHeight, mediumItemHeight)
        }

        return resolvedHeight
    }
    
    // MARK: - Keyboard Handling
    
    override var acceptsFirstResponder: Bool {
        return true
    }

    private func refreshVisibleSelectionState(_ tableView: NSTableView) {
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

    private func revealSelectionIfNeeded(
        _ row: Int,
        movingDown: Bool,
        tableView: NSTableView
    ) {
        guard let scrollView = tableView.enclosingScrollView else {
            return
        }

        let rowRect = tableView.rect(ofRow: row)
        let visibleRect = scrollView.contentView.documentVisibleRect

        let maxOffsetY = max(0, tableView.bounds.height - visibleRect.height)
        var targetOffsetY: CGFloat?

        if movingDown, rowRect.maxY > visibleRect.maxY {
            targetOffsetY = rowRect.maxY - visibleRect.height
        } else if !movingDown, rowRect.minY < visibleRect.minY {
            targetOffsetY = rowRect.minY
        }

        guard let targetOffsetY else {
            return
        }

        let clampedOffsetY = min(max(0, targetOffsetY), maxOffsetY)
        scrollView.contentView.setBoundsOrigin(NSPoint(x: 0, y: clampedOffsetY))
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    private func moveSelectionBy(_ delta: Int, tableView: NSTableView) {
        guard !items.isEmpty else {
            return
        }

        let nextIndex = max(0, min(items.count - 1, selectedIndex + delta))
        guard nextIndex != selectedIndex else {
            return
        }

        selectedIndex = nextIndex
        tableView.selectRowIndexes(
            NSIndexSet(index: selectedIndex) as IndexSet,
            byExtendingSelection: false
        )
        revealSelectionIfNeeded(
            selectedIndex,
            movingDown: delta > 0,
            tableView: tableView
        )
        refreshVisibleSelectionState(tableView)
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
            moveSelectionBy(-1, tableView: tableView)
            
        case 0x7D: // Down arrow key
            moveSelectionBy(1, tableView: tableView)
            
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
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return rowHeight(for: row, tableView: tableView)
    }

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
        refreshVisibleSelectionState(tableView)
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
    private var hostingView: NSHostingView<ClipboardRowContentView>?

    private func resolvedAppIcon(from appIconPath: String?) -> NSImage? {
        if let appIconPath,
           let icon = NSImage(contentsOfFile: appIconPath) {
            return icon
        }

        let mainAppIcon = NSWorkspace.shared.icon(forFile: Bundle.main.bundlePath)
        return mainAppIcon
    }

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
        layer?.masksToBounds = true

        let host = NSHostingView(
            rootView: ClipboardRowContentView(
                title: "",
                appIcon: nil,
                previewImage: nil,
                isImage: false
            )
        )
        host.translatesAutoresizingMaskIntoConstraints = false
        host.setContentCompressionResistancePriority(.required, for: .horizontal)
        host.setContentCompressionResistancePriority(.required, for: .vertical)
        addSubview(host)
        NSLayoutConstraint.activate([
            host.leadingAnchor.constraint(equalTo: leadingAnchor),
            host.trailingAnchor.constraint(equalTo: trailingAnchor),
            host.topAnchor.constraint(equalTo: topAnchor),
            host.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        hostingView = host
    }

    func configure(
        title: String,
        appIconPath: String?,
        previewImagePath: String?,
        isImage: Bool,
        selected: Bool,
        selectionColor: NSColor
    ) {
        setSelected(selected, selectionColor: selectionColor)

        let resolvedIcon = resolvedAppIcon(from: appIconPath)
        let resolvedPreview = previewImagePath.flatMap { NSImage(contentsOfFile: $0) }

        hostingView?.rootView = ClipboardRowContentView(
            title: title,
            appIcon: resolvedIcon,
            previewImage: resolvedPreview,
            isImage: isImage
        )
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

private struct ClipboardRowContentView: View {
    let title: String
    let appIcon: NSImage?
    let previewImage: NSImage?
    let isImage: Bool

    var body: some View {
        Group {
            if isImage, let previewImage {
                imageContent(previewImage)
            } else {
                textContent
            }
        }
        .padding(6)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.clear)
    }

    private var iconBadge: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(Color.black.opacity(0.22))
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)

            if let appIcon {
                Image(nsImage: appIcon)
                    .resizable()
                    .interpolation(.high)
                    .renderingMode(.original)
                    .scaledToFit()
                    .padding(2)
            } else {
                Text("CC")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .frame(width: 28, height: 28)
        .zIndex(2)
    }

    private var textContent: some View {
        HStack(alignment: .center, spacing: 6) {
            iconBadge

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(4)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    private func imageContent(_ image: NSImage) -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height,
                        alignment: .center
                    )
                    .clipped()

                iconBadge
                    .padding(6)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .clipped()
        }
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
    }

    override func drawBackground(in dirtyRect: NSRect) {
        if isSelected {
            return
        }

        let backgroundRect = bounds.insetBy(dx: 1, dy: 1)
        let path = NSBezierPath(roundedRect: backgroundRect, xRadius: 8, yRadius: 8)
        NSColor.clear.setFill()
        path.fill()
    }
}
