import Cocoa
import FlutterMacOS
import LaunchAtLogin
import SwiftUI
import window_manager

class MainFlutterWindow: NSWindow {
  private let clipboardToastPresenter = ClipboardToastPresenter()

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    FlutterMethodChannel(
      name: "launch_at_startup", binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    .setMethodCallHandler { (_ call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "launchAtStartupIsEnabled":
        result(LaunchAtLogin.isEnabled)
      case "launchAtStartupSetEnabled":
        if let arguments = call.arguments as? [String: Any] {
          LaunchAtLogin.isEnabled = arguments["setEnabledValue"] as! Bool
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    FlutterMethodChannel(
      name: "copycat_clipboard_feedback",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    .setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "showClipboardFeedback":
        let arguments = call.arguments as? [String: Any]
        let message = arguments?["message"] as? String
        let showToast = arguments?["showToast"] as? Bool ?? false
        self?.clipboardToastPresenter.show(
          message: message,
          showToast: showToast
        )
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
    super.order(place, relativeTo: otherWin)
    hiddenWindowAtLaunch()
  }
}

final class ClipboardToastPresenter {
  private var panel: NSPanel?
  private var dismissWorkItem: DispatchWorkItem?

  func show(
    message: String?,
    showToast: Bool,
    duration: TimeInterval = 1.8
  ) {
    DispatchQueue.main.async {
      guard showToast else { return }

      self.dismissWorkItem?.cancel()
      self.dismissCurrentToast()

      let screen = self.activeScreen()
      let visibleFrame = screen.visibleFrame
      let width: CGFloat = 132
      let height: CGFloat = 30
      let originX = visibleFrame.midX - width / 2
      let originY = visibleFrame.maxY - height - 22

      let panel = NSPanel(
        contentRect: NSRect(x: originX, y: originY, width: width, height: height),
        styleMask: [.borderless, .nonactivatingPanel],
        backing: .buffered,
        defer: false
      )

      panel.isOpaque = false
      panel.backgroundColor = .clear
      panel.hasShadow = false
      panel.ignoresMouseEvents = true
      panel.isReleasedWhenClosed = false
      panel.level = .statusBar
      panel.hidesOnDeactivate = false
      panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .transient, .ignoresCycle]
      panel.contentViewController = NSHostingController(
        rootView: ClipboardToastView(message: message ?? "Copied")
      )
      panel.alphaValue = 0
      panel.orderFrontRegardless()

      NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.18
        context.timingFunction = CAMediaTimingFunction(name: .easeOut)
        panel.animator().alphaValue = 1
      }

      self.panel = panel

      let dismiss = DispatchWorkItem { [weak self, weak panel] in
        guard let panel else { return }
        panel.orderOut(nil)
        panel.close()
        if self?.panel === panel {
          self?.panel = nil
        }
      }

      self.dismissWorkItem = dismiss
      DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: dismiss)
    }
  }

  private func dismissCurrentToast() {
    panel?.orderOut(nil)
    panel?.close()
    panel = nil
  }

  private func activeScreen() -> NSScreen {
    let mouseLocation = NSEvent.mouseLocation
    if let screen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) {
      return screen
    }

    return NSScreen.main ?? NSScreen.screens.first ?? NSScreen()
  }
}

private struct ClipboardToastView: View {
  let message: String
  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    let capsule = Capsule(style: .continuous)

    Text(message)
      .font(.system(size: 11, weight: .semibold))
      .foregroundColor(.primary)
      .kerning(0.2)
      .multilineTextAlignment(.center)
      .padding(.horizontal, 12)
      .lineLimit(1)
      .frame(width: 132, height: 30)
      .background(
        capsule.fill(colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.89))
      )
      .clipShape(capsule)
      .overlay(
        capsule.strokeBorder(
          colorScheme == .dark ? Color(white: 0.33) : Color(white: 0.77),
          lineWidth: 0.9
        )
      )
  }
}
