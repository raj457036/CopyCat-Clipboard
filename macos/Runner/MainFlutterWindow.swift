import Cocoa
import FlutterMacOS
import LaunchAtLogin
import SwiftUI
import window_manager

// Intercept FLTEnableImpeller lookup before FlutterViewController initializes.
// Forces Skia on Intel (x86_64) and Impeller on Apple Silicon (arm64).
extension Bundle {
  private static let swizzleInfoDictionaryOnce: Void = {
    let originalSelector = #selector(Bundle.object(forInfoDictionaryKey:))
    let swizzledSelector = #selector(Bundle.custom_object(forInfoDictionaryKey:))

    guard let originalMethod = class_getInstanceMethod(Bundle.self, originalSelector),
          let swizzledMethod = class_getInstanceMethod(Bundle.self, swizzledSelector) else {
      return
    }
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }()

  static func enableArchitectureSpecificRendering() {
    _ = swizzleInfoDictionaryOnce
  }

  @objc func custom_object(forInfoDictionaryKey key: String) -> Any? {
    if key == "FLTEnableImpeller" {
      #if arch(x86_64)
        return false
      #else
        return true
      #endif
    }
    return custom_object(forInfoDictionaryKey: key)
  }
}

class MainFlutterWindow: NSWindow {
  private let clipboardToastPresenter = ClipboardToastPresenter()

  override func awakeFromNib() {
    Bundle.enableArchitectureSpecificRendering()

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

      let screen: NSScreen = self.activeScreen()
      let visibleFrame: NSRect = screen.visibleFrame
      let toastMessage: String = message ?? "Copied"

      let font: NSFont = NSFont.systemFont(ofSize: 12, weight: .medium)
      let textWidth: CGFloat = (toastMessage as NSString).size(withAttributes: [.font: font]).width
      let width: CGFloat = max(136, textWidth + 48)
      let height: CGFloat = 34
      let originX: CGFloat = visibleFrame.midX - width / 2
      let originY: CGFloat = visibleFrame.maxY - height - 22

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
        rootView: ClipboardToastView(
          message: toastMessage,
          width: width,
          height: height
        )
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
    let mouseLocation: NSPoint = NSEvent.mouseLocation
    if let screen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) {
      return screen
    }

    return NSScreen.main ?? NSScreen.screens.first ?? NSScreen()
  }
}

private struct ClipboardToastView: View {
  let message: String
  let width: CGFloat
  let height: CGFloat

  var body: some View {
    let capsule = Capsule(style: .continuous)

    HStack(spacing: 7) {
      Image(systemName: "checkmark")
        .font(.system(size: 11, weight: .semibold))
        .foregroundColor(Color.white.opacity(0.95))

      Text(message)
        .font(.system(size: 12, weight: .medium))
        .foregroundColor(Color.white)
        .lineLimit(1)
    }
    .padding(.horizontal, 16)
    .frame(width: width, height: height)
    .background(
      capsule
        .fill(Color(white: 0.44))
        .overlay(
          LinearGradient(
            colors: [
              Color.white.opacity(0.12),
              Color.clear,
            ],
            startPoint: .top,
            endPoint: .center
          )
          .clipShape(capsule)
        )
    )
    .clipShape(capsule)
    .overlay(
      capsule.strokeBorder(
        LinearGradient(
          colors: [
            Color.white.opacity(0.35),
            Color.white.opacity(0.08),
            Color.white.opacity(0.18),
          ],
          startPoint: .top,
          endPoint: .bottom
        ),
        lineWidth: 0.75
      )
    )
  }
}
