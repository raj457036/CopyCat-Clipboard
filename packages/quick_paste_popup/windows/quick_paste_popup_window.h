#ifndef FLUTTER_PLUGIN_QUICK_PASTE_POPUP_WINDOW_H_
#define FLUTTER_PLUGIN_QUICK_PASTE_POPUP_WINDOW_H_

#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <windows.h>
#include <vector>
#include <string>
#include <functional>
#include <memory>
#include <flutter/encodable_value.h>

#include <gdiplus.h>

namespace quick_paste_popup {

struct ClipboardItem {
    std::string id;
    std::string text;
    std::string app_icon_path;
    std::string preview_image_path;
    bool is_image;
    // ... other fields as needed
};

class QuickPastePopupWindow {
public:
    using CompletionHandler = std::function<void(std::optional<std::string> selected_id, bool dismissed, std::optional<std::string> error)>;

    QuickPastePopupWindow(const std::vector<ClipboardItem>& items, uint32_t selection_color, CompletionHandler completion_handler);
    ~QuickPastePopupWindow();

    bool Show(POINT position);
    void Close();

private:
    static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    LRESULT HandleMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

    void Render();
    void OnKeyDown(WPARAM wParam);
    void OnMouseMove(int x, int y);
    void OnLButtonDown(int x, int y);
    void OnKillFocus();

    std::wstring Utf8ToWide(const std::string& utf8);
    void DrawItem(Gdiplus::Graphics& graphics, int index, int y, int width);

    HWND hwnd_ = nullptr;
    std::vector<ClipboardItem> items_;
    uint32_t selection_color_;
    CompletionHandler completion_handler_;
    
    int selected_index_ = 0;
    int top_index_ = 0;
    bool has_dismissed_ = false;
    bool is_dark_mode_ = true;

    // Animation state
    float animation_alpha_ = 0.0f;
    int target_x_ = 0;
    int target_y_ = 0;
    int current_y_offset_ = 20;

    void EnsureVisible(int index);
    void DetectTheme();
    void UpdateAnimation();

    // Drawing resources
    ULONG_PTR gdiplusToken_;
};

// Layout constants
const int kItemPadding = 8;
const int kIconSize = 24;
const int kThumbnailHeight = 80;

} // namespace quick_paste_popup

#endif // FLUTTER_PLUGIN_QUICK_PASTE_POPUP_WINDOW_H_
