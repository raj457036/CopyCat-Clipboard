#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"
#include "clipboard_toast.h"

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

FlutterWindow::FlutterWindow(const flutter::DartProject &project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate()
{
  if (!Win32Window::OnCreate())
  {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view())
  {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  // Method channel for clipboard feedback (used on macOS and Windows)
  {
    auto messenger = flutter_controller_->engine()->messenger();
    static auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
        messenger, "copycat_clipboard_feedback", &flutter::StandardMethodCodec::GetInstance());

    channel->SetMethodCallHandler(
        [](const flutter::MethodCall<flutter::EncodableValue> &call,
           std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
        {
          if (call.method_name().compare("showClipboardFeedback") == 0)
          {
            const auto *args = std::get_if<flutter::EncodableMap>(call.arguments());
            std::string message = "Copied";
            bool showToast = true;
            bool playHaptic = false;
            if (args)
            {
              auto it = args->find(flutter::EncodableValue("message"));
              if (it != args->end())
              {
                if (auto p = std::get_if<std::string>(&(it->second)))
                {
                  message = *p;
                }
              }
              it = args->find(flutter::EncodableValue("showToast"));
              if (it != args->end())
              {
                if (auto p = std::get_if<bool>(&(it->second)))
                {
                  showToast = *p;
                }
              }
              it = args->find(flutter::EncodableValue("playHaptic"));
              if (it != args->end())
              {
                if (auto p = std::get_if<bool>(&(it->second)))
                {
                  playHaptic = *p;
                }
              }
            }
            // Show a simple native toast on Windows
            clipboard_toast::ShowClipboardFeedback(message, showToast, playHaptic);
            result->Success();
            return;
          }
          result->NotImplemented();
        });
  }
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]()
                                                      {
                                                        // this->Show();
                                                      });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy()
{
  if (flutter_controller_)
  {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept
{
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_)
  {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result)
    {
      return *result;
    }
  }

  switch (message)
  {
  case WM_FONTCHANGE:
    flutter_controller_->engine()->ReloadSystemFonts();
    break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
