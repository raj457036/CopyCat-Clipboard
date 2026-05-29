#ifndef FLUTTER_PLUGIN_QUICK_PASTE_POPUP_PLUGIN_H_
#define FLUTTER_PLUGIN_QUICK_PASTE_POPUP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>
#include <optional>

#include "quick_paste_popup_window.h"

namespace quick_paste_popup {

class QuickPastePopupPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  QuickPastePopupPlugin(flutter::PluginRegistrarWindows* registrar);

  virtual ~QuickPastePopupPlugin();

  // Disallow copy and assign.
  QuickPastePopupPlugin(const QuickPastePopupPlugin&) = delete;
  QuickPastePopupPlugin& operator=(const QuickPastePopupPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  void HandleShowQuickPastePopup(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void HandleCaptureCaretContext(
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void HandleSetTheme(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void HandleInsertTextDirect(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void HandleGetCursorPosition(
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void HandleGetFocusedApp(
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  std::wstring Utf8ToWide(const std::string& utf8);

  // The registrar for this plugin.
  flutter::PluginRegistrarWindows* registrar_;

  // The active popup window, if any.
  std::unique_ptr<QuickPastePopupWindow> popup_window_;

  // Cached caret position from the last captureCaretContext call.
  std::optional<POINT> cached_caret_position_;
  bool cached_caret_found_ = false;
  
  // Theme selection color.
  uint32_t selection_color_ = 0xFF0078D7; // Default Windows Blue
};

}  // namespace quick_paste_popup

#endif  // FLUTTER_PLUGIN_QUICK_PASTE_POPUP_PLUGIN_H_
