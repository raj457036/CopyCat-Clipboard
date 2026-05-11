#include "quick_paste_popup_plugin.h"

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>
#include <winuser.h>
#include <iostream>
#include <sstream>
#include <memory>
#include <UIAutomation.h>

namespace quick_paste_popup {

// static
void QuickPastePopupPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "quick_paste_popup",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<QuickPastePopupPlugin>(registrar);

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

QuickPastePopupPlugin::QuickPastePopupPlugin(flutter::PluginRegistrarWindows* registrar)
    : registrar_(registrar) {
  CoInitializeEx(NULL, COINIT_APARTMENTTHREADED);
}

QuickPastePopupPlugin::~QuickPastePopupPlugin() {}

void QuickPastePopupPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("showQuickPastePopup") == 0) {
    HandleShowQuickPastePopup(method_call, std::move(result));
  } else if (method_call.method_name().compare("captureCaretContext") == 0) {
    HandleCaptureCaretContext(std::move(result));
  } else if (method_call.method_name().compare("setTheme") == 0) {
    HandleSetTheme(method_call, std::move(result));
  } else if (method_call.method_name().compare("insertTextDirect") == 0) {
    HandleInsertTextDirect(method_call, std::move(result));
  } else if (method_call.method_name().compare("getCursorPosition") == 0) {
    HandleGetCursorPosition(std::move(result));
  } else if (method_call.method_name().compare("getFocusedApp") == 0) {
    HandleGetFocusedApp(std::move(result));
  } else if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else {
    result->NotImplemented();
  }
}

void QuickPastePopupPlugin::HandleShowQuickPastePopup(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (!arguments) {
    result->Error("Invalid arguments", "Expected an EncodableMap");
    return;
  }

  auto items_it = arguments->find(flutter::EncodableValue("items"));
  if (items_it == arguments->end() || !std::holds_alternative<flutter::EncodableList>(items_it->second)) {
    result->Error("Invalid arguments", "Expected 'items' list");
    return;
  }

  const auto& items_list = std::get<flutter::EncodableList>(items_it->second);
  std::vector<ClipboardItem> items;
  for (const auto& item_val : items_list) {
    const auto& item_map = std::get<flutter::EncodableMap>(item_val);
    ClipboardItem item;
    
    auto id_it = item_map.find(flutter::EncodableValue("id"));
    if (id_it != item_map.end()) item.id = std::get<std::string>(id_it->second);
    
    auto text_it = item_map.find(flutter::EncodableValue("text"));
    if (text_it != item_map.end()) item.text = std::get<std::string>(text_it->second);
    
    auto subtitle_it = item_map.find(flutter::EncodableValue("subtitle"));
    if (subtitle_it != item_map.end() && !std::holds_alternative<std::monostate>(subtitle_it->second))
        item.subtitle = std::get<std::string>(subtitle_it->second);

    auto icon_it = item_map.find(flutter::EncodableValue("appIconPath"));
    if (icon_it != item_map.end() && !std::holds_alternative<std::monostate>(icon_it->second)) 
        item.app_icon_path = std::get<std::string>(icon_it->second);
    
    auto preview_it = item_map.find(flutter::EncodableValue("previewImagePath"));
    if (preview_it != item_map.end() && !std::holds_alternative<std::monostate>(preview_it->second)) 
        item.preview_image_path = std::get<std::string>(preview_it->second);

    auto is_image_it = item_map.find(flutter::EncodableValue("isImage"));
    if (is_image_it != item_map.end()) item.is_image = std::get<bool>(is_image_it->second);

    auto size_it = item_map.find(flutter::EncodableValue("fileSize"));
    if (size_it != item_map.end() && !std::holds_alternative<std::monostate>(size_it->second))
        item.file_size = std::get<int>(size_it->second);

    auto mime_it = item_map.find(flutter::EncodableValue("fileMimeType"));
    if (mime_it != item_map.end() && !std::holds_alternative<std::monostate>(mime_it->second))
        item.file_mime_type = std::get<std::string>(mime_it->second);

    items.push_back(item);
  }

  POINT anchor;
  if (cached_caret_position_.has_value()) {
    anchor = cached_caret_position_.value();
    
    // If it was a fallback to center screen, adjust anchor so window is centered
    if (!cached_caret_found_) {
      int totalHeight = 0;
      for (const auto& item : items) {
          totalHeight += item.is_image ? 80 + 10 : 64; // Use constants from window.cpp
      }
      if (totalHeight > 5 * 64) totalHeight = 5 * 64 + 10;
      
      anchor.x -= 380 / 2; // kWidth / 2
      anchor.y -= totalHeight / 2;
    }
    
    cached_caret_position_.reset();
    cached_caret_found_ = false;
  } else {
    GetCursorPos(&anchor);
  }

  // Shared result pointer for the completion handler
  auto shared_result = std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>(std::move(result));

  popup_window_ = std::make_unique<QuickPastePopupWindow>(
      items, selection_color_,
      [shared_result](std::optional<std::string> selected_id, bool dismissed, std::optional<std::string> error) {
        flutter::EncodableMap response;
        response[flutter::EncodableValue("dismissed")] = flutter::EncodableValue(dismissed);
        if (selected_id.has_value()) {
          response[flutter::EncodableValue("selectedItemId")] = flutter::EncodableValue(selected_id.value());
        } else {
          response[flutter::EncodableValue("selectedItemId")] = flutter::EncodableValue();
        }
        if (error.has_value()) {
          response[flutter::EncodableValue("error")] = flutter::EncodableValue(error.value());
        }
        shared_result->Success(flutter::EncodableValue(response));
      });

  if (!popup_window_->Show(anchor)) {
    popup_window_.reset();
  }
}

void QuickPastePopupPlugin::HandleCaptureCaretContext(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  POINT p = {0, 0};
  bool found = false;

  // 1. Try UI Automation (Modern approach)
  IUIAutomation* pAutomation = NULL;
  // Use a fast timeout for COM initialization/calls if possible
  HRESULT hr = CoCreateInstance(CLSID_CUIAutomation, NULL, CLSCTX_INPROC_SERVER, IID_IUIAutomation, (void**)&pAutomation);
  if (SUCCEEDED(hr) && pAutomation) {
    IUIAutomationElement* pFocusedElement = NULL;
    if (SUCCEEDED(pAutomation->GetFocusedElement(&pFocusedElement)) && pFocusedElement) {
        IUIAutomationTextPattern* pTextPattern = NULL;
        if (SUCCEEDED(pFocusedElement->GetCurrentPattern(UIA_TextPatternId, (IUnknown**)&pTextPattern)) && pTextPattern) {
            IUIAutomationTextRangeArray* pSelectionRanges = NULL;
            if (SUCCEEDED(pTextPattern->GetSelection(&pSelectionRanges)) && pSelectionRanges) {
                int count = 0;
                pSelectionRanges->get_Length(&count);
                if (count > 0) {
                    IUIAutomationTextRange* pRange = NULL;
                    if (SUCCEEDED(pSelectionRanges->GetElement(0, &pRange)) && pRange) {
                        SAFEARRAY* pRects = NULL;
                        if (SUCCEEDED(pRange->GetBoundingRectangles(&pRects)) && pRects) {
                            double* rectData;
                            if (SUCCEEDED(SafeArrayAccessData(pRects, (void**)&rectData))) {
                                long lowerBound, upperBound;
                                SafeArrayGetLBound(pRects, 1, &lowerBound);
                                SafeArrayGetUBound(pRects, 1, &upperBound);
                                if ((upperBound - lowerBound + 1) >= 4) {
                                    p.x = (long)rectData[0];
                                    p.y = (long)(rectData[1] + rectData[3]); 
                                    found = true;
                                }
                                SafeArrayUnaccessData(pRects);
                            }
                            SafeArrayDestroy(pRects);
                        }
                        pRange->Release();
                    }
                }
                pSelectionRanges->Release();
            }
            pTextPattern->Release();
        }
        pFocusedElement->Release();
    }
    pAutomation->Release();
  }

  // 2. Fallback to standard Win32 Caret
  if (!found) {
    GUITHREADINFO gti = {sizeof(GUITHREADINFO)};
    if (GetGUIThreadInfo(0, &gti)) {
        if (gti.hwndCaret) {
            POINT caret_p = {gti.rcCaret.left, gti.rcCaret.bottom};
            ClientToScreen(gti.hwndCaret, &caret_p);
            p = caret_p;
            found = true;
        } else if (gti.hwndFocus && (gti.rcCaret.left != 0 || gti.rcCaret.top != 0)) {
            POINT caret_p = {gti.rcCaret.left, gti.rcCaret.bottom};
            ClientToScreen(gti.hwndFocus, &caret_p);
            p = caret_p;
            found = true;
        }
    }
  }

  // 3. Final fallback to Screen Center (Usability priority)
  if (!found) {
    int screenW = GetSystemMetrics(SM_CXSCREEN);
    int screenH = GetSystemMetrics(SM_CYSCREEN);
    p.x = screenW / 2;
    p.y = screenH / 2;
  }

  cached_caret_position_ = p;
  cached_caret_found_ = found;
  result->Success(flutter::EncodableValue(found));
}

void QuickPastePopupPlugin::HandleSetTheme(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (!arguments) {
    result->Error("Invalid arguments", "Expected an EncodableMap");
    return;
  }

  auto color_it = arguments->find(flutter::EncodableValue("selectionColor"));
  if (color_it != arguments->end()) {
    if (std::holds_alternative<int32_t>(color_it->second)) {
      selection_color_ = static_cast<uint32_t>(std::get<int32_t>(color_it->second));
      result->Success(flutter::EncodableValue(true));
      return;
    } else if (std::holds_alternative<int64_t>(color_it->second)) {
      selection_color_ = static_cast<uint32_t>(std::get<int64_t>(color_it->second));
      result->Success(flutter::EncodableValue(true));
      return;
    }
  }
  result->Success(flutter::EncodableValue(false));
}

void QuickPastePopupPlugin::HandleInsertTextDirect(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (!arguments) {
    result->Error("Invalid arguments", "Expected an EncodableMap");
    return;
  }

  auto text_it = arguments->find(flutter::EncodableValue("text"));
  if (text_it == arguments->end() || !std::holds_alternative<std::string>(text_it->second)) {
    result->Error("Invalid arguments", "Expected 'text' string");
    return;
  }

  std::wstring text = Utf8ToWide(std::get<std::string>(text_it->second));

  // Simulating text insertion using SendInput
  std::vector<INPUT> inputs;
  for (wchar_t c : text) {
    INPUT input = {0};
    input.type = INPUT_KEYBOARD;
    input.ki.wVk = 0;
    input.ki.wScan = (WORD)c;
    input.ki.dwFlags = KEYEVENTF_UNICODE;
    inputs.push_back(input);

    input.ki.dwFlags |= KEYEVENTF_KEYUP;
    inputs.push_back(input);
  }

  if (!inputs.empty()) {
    SendInput((UINT)inputs.size(), inputs.data(), sizeof(INPUT));
  }
  result->Success(flutter::EncodableValue(true));
}

std::wstring QuickPastePopupPlugin::Utf8ToWide(const std::string& utf8) {
  if (utf8.empty()) return L"";
  int size_needed = MultiByteToWideChar(CP_UTF8, 0, &utf8[0], (int)utf8.size(), NULL, 0);
  std::wstring wstrTo(size_needed, 0);
  MultiByteToWideChar(CP_UTF8, 0, &utf8[0], (int)utf8.size(), &wstrTo[0], size_needed);
  return wstrTo;
}

void QuickPastePopupPlugin::HandleGetCursorPosition(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  POINT p;
  if (GetCursorPos(&p)) {
    flutter::EncodableMap pos;
    pos[flutter::EncodableValue("x")] = flutter::EncodableValue((double)p.x);
    pos[flutter::EncodableValue("y")] = flutter::EncodableValue((double)p.y);
    result->Success(flutter::EncodableValue(pos));
  } else {
    result->Success(flutter::EncodableValue());
  }
}

void QuickPastePopupPlugin::HandleGetFocusedApp(
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  HWND hwnd = GetForegroundWindow();
  if (hwnd) {
    wchar_t title[256];
    GetWindowTextW(hwnd, title, 256);
    
    std::wstring wtitle(title);
    
    int size_needed = WideCharToMultiByte(CP_UTF8, 0, &wtitle[0], (int)wtitle.size(), NULL, 0, NULL, NULL);
    std::string stitle(size_needed, 0);
    WideCharToMultiByte(CP_UTF8, 0, &wtitle[0], (int)wtitle.size(), &stitle[0], size_needed, NULL, NULL);

    flutter::EncodableMap app;
    app[flutter::EncodableValue("name")] = flutter::EncodableValue(stitle);
    app[flutter::EncodableValue("bundleId")] = flutter::EncodableValue(""); // Windows doesn't have bundle IDs
    result->Success(flutter::EncodableValue(app));
  } else {
    result->Success(flutter::EncodableValue());
  }
}

}  // namespace quick_paste_popup
