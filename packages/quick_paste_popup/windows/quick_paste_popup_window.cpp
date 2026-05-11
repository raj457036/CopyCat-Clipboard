#include "quick_paste_popup_window.h"
#include <gdiplus.h>
#include <dwmapi.h>
#include <vector>
#include <string>
#include <algorithm>

#pragma comment(lib, "gdiplus.lib")
#pragma comment(lib, "dwmapi.lib")

using namespace Gdiplus;

namespace quick_paste_popup {

const wchar_t kWindowClassName[] = L"QuickPastePopupWindow";
const int kItemHeight = 70;
const int kWidth = 420;
const int kMaxVisibleItems = 6;

// Fallback for Windows 11 DWM attributes if using an older SDK
#ifndef DWMWA_WINDOW_CORNER_PREFERENCE
#define DWMWA_WINDOW_CORNER_PREFERENCE 33
#endif

#ifndef DWMWCP_ROUNDED
#define DWMWCP_ROUNDED 2
#endif

#ifndef DWMWA_SYSTEMBACKDROP_TYPE
#define DWMWA_SYSTEMBACKDROP_TYPE 38
#endif

#ifndef DWMSBT_TRANSIENTWINDOW
#define DWMSBT_TRANSIENTWINDOW 3
#endif

#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif

QuickPastePopupWindow::QuickPastePopupWindow(const std::vector<ClipboardItem>& items, uint32_t selection_color, CompletionHandler completion_handler)
    : items_(items), selection_color_(selection_color), completion_handler_(completion_handler) {
    
    GdiplusStartupInput gdiplusStartupInput;
    GdiplusStartup(&gdiplusToken_, &gdiplusStartupInput, NULL);
}

QuickPastePopupWindow::~QuickPastePopupWindow() {
    Close();
    GdiplusShutdown(gdiplusToken_);
}

bool QuickPastePopupWindow::Show(POINT position) {
    HINSTANCE hInstance = GetModuleHandle(NULL);

    DetectTheme();

    WNDCLASSEXW wcex = {sizeof(WNDCLASSEXW)};
    if (!GetClassInfoExW(hInstance, kWindowClassName, &wcex)) {
        wcex.style = CS_HREDRAW | CS_VREDRAW | CS_DROPSHADOW;
        wcex.lpfnWndProc = WindowProc;
        wcex.hInstance = hInstance;
        wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
        wcex.lpszClassName = kWindowClassName;
        wcex.hbrBackground = (HBRUSH)GetStockObject(NULL_BRUSH);
        RegisterClassExW(&wcex);
    }

    // Calculate height based on content
    int totalHeight = 10;
    for (int i = 0; i < (int)std::min(items_.size(), (size_t)kMaxVisibleItems); ++i) {
        totalHeight += items_[i].is_image ? kThumbnailHeight + 10 : kItemHeight;
    }
    if (items_.empty()) totalHeight = 100;

    // Smart Positioning (Smart Flip)
    HMONITOR hMonitor = MonitorFromPoint(position, MONITOR_DEFAULTTONEAREST);
    MONITORINFO mi = { sizeof(mi) };
    GetMonitorInfo(hMonitor, &mi);

    int x = position.x;
    int y = position.y + 10; 

    if (y + totalHeight > mi.rcWork.bottom) {
        y = position.y - totalHeight - 10; 
    }

    if (x + kWidth > mi.rcWork.right) {
        x = mi.rcWork.right - kWidth - 10;
    }
    if (x < mi.rcWork.left) {
        x = mi.rcWork.left + 10;
    }

    hwnd_ = CreateWindowExW(
        WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_NOACTIVATE,
        kWindowClassName, L"Quick Paste",
        WS_POPUP,
        x, y, kWidth, totalHeight,
        NULL, NULL, hInstance, this
    );

    if (!hwnd_) {
        if (completion_handler_) {
            completion_handler_(std::nullopt, true, "Failed to create window");
        }
        return false;
    }

    // Enable dark mode for the window frame
    BOOL dark_mode = is_dark_mode_;
    DwmSetWindowAttribute(hwnd_, DWMWA_USE_IMMERSIVE_DARK_MODE, &dark_mode, sizeof(dark_mode));

    // Rounded corners
    int corner_preference = DWMWCP_ROUNDED;
    DwmSetWindowAttribute(hwnd_, DWMWA_WINDOW_CORNER_PREFERENCE, &corner_preference, sizeof(corner_preference));

    ShowWindow(hwnd_, SW_SHOW);
    UpdateWindow(hwnd_);
    
    SetForegroundWindow(hwnd_);
    SetFocus(hwnd_);

    return true;
}

std::wstring QuickPastePopupWindow::Utf8ToWide(const std::string& utf8) {
    if (utf8.empty()) return L"";
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, &utf8[0], (int)utf8.size(), NULL, 0);
    std::wstring wstrTo(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, &utf8[0], (int)utf8.size(), &wstrTo[0], size_needed);
    return wstrTo;
}

void QuickPastePopupWindow::Render() {
    RECT rect;
    GetClientRect(hwnd_, &rect);
    int width = rect.right - rect.left;
    int height = rect.bottom - rect.top;

    PAINTSTRUCT ps;
    HDC hdc = BeginPaint(hwnd_, &ps);
    
    // Memory DC for double buffering
    HDC memDC = CreateCompatibleDC(hdc);
    HBITMAP memBitmap = CreateCompatibleBitmap(hdc, width, height);
    SelectObject(memDC, memBitmap);

    Graphics graphics(memDC);
    graphics.SetSmoothingMode(SmoothingModeAntiAlias);
    graphics.SetInterpolationMode(InterpolationModeHighQualityBicubic);
    
    // Clear with semi-transparent background to allow Acrylic to show through
    // Clear with solid background
    if (is_dark_mode_) {
        graphics.Clear(Color(255, 32, 32, 32)); 
    } else {
        graphics.Clear(Color(255, 250, 250, 250)); // Solid off-white
    }

    int currentY = 5;
    for (int i = top_index_; i < (int)items_.size(); ++i) {
        DrawItem(graphics, i, currentY, width);
        currentY += items_[i].is_image ? kThumbnailHeight + 10 : kItemHeight;
        if (currentY > height) break;
    }

    if (items_.empty()) {
        FontFamily fontFamily(L"Segoe UI");
        Font font(&fontFamily, 12, FontStyleRegular, UnitPoint);
        SolidBrush textBrush(Color(255, 180, 180, 180));
        StringFormat format;
        format.SetAlignment(StringAlignmentCenter);
        format.SetLineAlignment(StringAlignmentCenter);
        graphics.DrawString(L"No items found", -1, &font, RectF(0, 0, (float)width, (float)height), &format, &textBrush);
    }

    BitBlt(hdc, 0, 0, width, height, memDC, 0, 0, SRCCOPY);

    DeleteObject(memBitmap);
    DeleteDC(memDC);
    EndPaint(hwnd_, &ps);
}

void QuickPastePopupWindow::DrawItem(Gdiplus::Graphics& graphics, int index, int y, int width) {
    const auto& item = items_[index];
    bool selected = (index == selected_index_);
    int itemHeight = item.is_image ? kThumbnailHeight : kItemHeight - 10;

    // Item Card Path
    GraphicsPath path;
    int radius = 8;
    int left = 8, top = y, right = width - 8, bottom = y + itemHeight;
    path.AddArc(left, top, radius, radius, 180, 90);
    path.AddArc(right - radius, top, radius, radius, 270, 90);
    path.AddArc(right - radius, bottom - radius, radius, radius, 0, 90);
    path.AddArc(left, bottom - radius, radius, radius, 90, 90);
    path.CloseFigure();

    if (selected) {
        ARGB argb = selection_color_;
        if (argb == 0 || argb == 0xFF0078D7) argb = Color::MakeARGB(255, 0, 120, 215);
        Gdiplus::Color accentColor(argb);
        
        // Card Background (Selected)
        Color selectionFill = is_dark_mode_ ? Color(40, 255, 255, 255) : Color(30, 0, 0, 0);
        Gdiplus::SolidBrush selectionBrush(selectionFill);
        graphics.FillPath(&selectionBrush, &path);
        
        // Card Border (Fluent style)
        Color borderColor = is_dark_mode_ ? Color(60, 255, 255, 255) : Color(40, 0, 0, 0);
        Pen borderPen(borderColor, 1.0f);
        graphics.DrawPath(&borderPen, &path);
        
        // Vertical indicator (pill shape)
        Gdiplus::SolidBrush accentBrush(accentColor);
        graphics.FillRectangle(&accentBrush, 8, y + 15, 3, itemHeight - 30);
    } else {
        // Subtle background for non-selected items to give card feel
        Color itemFill = is_dark_mode_ ? Color(15, 255, 255, 255) : Color(5, 0, 0, 0);
        Gdiplus::SolidBrush itemBrush(itemFill);
        graphics.FillPath(&itemBrush, &path);
    }

    // App Icon
    if (!item.app_icon_path.empty()) {
        std::wstring wpath = Utf8ToWide(item.app_icon_path);
        Gdiplus::Image icon(wpath.c_str());
        if (icon.GetLastStatus() == Gdiplus::Ok) {
            graphics.DrawImage(&icon, (Gdiplus::REAL)15, (Gdiplus::REAL)(y + (itemHeight - kIconSize) / 2), (Gdiplus::REAL)kIconSize, (Gdiplus::REAL)kIconSize);
        }
    } else {
        // Fallback icon circle
        Gdiplus::SolidBrush iconBrush(Gdiplus::Color(100, 80, 80, 80));
        graphics.FillEllipse(&iconBrush, 15, y + (itemHeight - kIconSize) / 2, kIconSize, kIconSize);
    }

    // Content
    Gdiplus::FontFamily fontFamily(L"Segoe UI");
    Gdiplus::Font font(&fontFamily, 10, Gdiplus::FontStyleRegular, Gdiplus::UnitPoint);
    Color textColor = is_dark_mode_ ? Color(255, 230, 230, 230) : Color(255, 30, 30, 30);
    SolidBrush textBrush(textColor);

    if (item.is_image && !item.preview_image_path.empty()) {
        std::wstring wpath = Utf8ToWide(item.preview_image_path);
        Gdiplus::Image preview(wpath.c_str());
        if (preview.GetLastStatus() == Gdiplus::Ok) {
            float imgWidth = (float)preview.GetWidth();
            float imgHeight = (float)preview.GetHeight();
            float scale = (float)(itemHeight - 10) / imgHeight;
            float drawWidth = imgWidth * scale;
            
            graphics.DrawImage(&preview, (Gdiplus::REAL)50, (Gdiplus::REAL)(y + 5), (Gdiplus::REAL)drawWidth, (Gdiplus::REAL)(itemHeight - 10));
        }
    } else {
        std::wstring wtext = Utf8ToWide(item.text);
        Gdiplus::RectF textRect(65, (float)y + 5, (float)width - 85, (float)itemHeight - 10);
        Gdiplus::StringFormat format;
        format.SetTrimming(Gdiplus::StringTrimmingEllipsisCharacter);
        format.SetLineAlignment(StringAlignmentCenter);
        graphics.DrawString(wtext.c_str(), -1, &font, textRect, &format, &textBrush);
    }
}

void QuickPastePopupWindow::Close() {
    if (!has_dismissed_) {
        has_dismissed_ = true;
        if (completion_handler_) {
            completion_handler_(std::nullopt, true, std::nullopt);
        }
    }
    DestroyWindow(hwnd_);
    hwnd_ = nullptr;
}

LRESULT CALLBACK QuickPastePopupWindow::WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    QuickPastePopupWindow* window = nullptr;
    if (uMsg == WM_NCCREATE) {
        CREATESTRUCT* pCreate = (CREATESTRUCT*)lParam;
        window = (QuickPastePopupWindow*)pCreate->lpCreateParams;
        SetWindowLongPtr(hwnd, GWLP_USERDATA, (LONG_PTR)window);
    } else {
        window = (QuickPastePopupWindow*)GetWindowLongPtr(hwnd, GWLP_USERDATA);
    }

    if (window) {
        return window->HandleMessage(hwnd, uMsg, wParam, lParam);
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

LRESULT QuickPastePopupWindow::HandleMessage(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_PAINT: {
            Render();
            return 0;
        }
        case WM_KEYDOWN:
            OnKeyDown(wParam);
            return 0;
        case WM_MOUSEMOVE:
            OnMouseMove(LOWORD(lParam), HIWORD(lParam));
            return 0;
        case WM_LBUTTONDOWN:
            OnLButtonDown(LOWORD(lParam), HIWORD(lParam));
            return 0;
        case WM_KILLFOCUS:
        case WM_ACTIVATE:
            if (uMsg == WM_KILLFOCUS || (uMsg == WM_ACTIVATE && LOWORD(wParam) == WA_INACTIVE)) {
                Close();
            }
            return 0;
        case WM_MOUSEWHEEL: {
            int delta = GET_WHEEL_DELTA_WPARAM(wParam);
            
            // Calculate max top index to prevent overscroll
            RECT clientRect;
            GetClientRect(hwnd, &clientRect);
            int windowH = clientRect.bottom - clientRect.top;
            
            int totalH = 0;
            int visibleCount = 0;
            for (int i = (int)items_.size() - 1; i >= 0; --i) {
                totalH += items_[i].is_image ? kThumbnailHeight + 10 : kItemHeight;
                if (totalH > windowH - 10) break;
                visibleCount++;
            }
            int maxTopIndex = std::max(0, (int)items_.size() - visibleCount);

            if (delta > 0) {
                top_index_ = std::max(0, top_index_ - 1);
            } else {
                top_index_ = std::min(maxTopIndex, top_index_ + 1);
            }
            InvalidateRect(hwnd, NULL, FALSE);
            return 0;
        }
        case WM_ERASEBKGND:
            return 1;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

void QuickPastePopupWindow::OnMouseMove(int x, int y) {
    RECT rect;
    GetClientRect(hwnd_, &rect);
    int height = rect.bottom - rect.top;

    int currentY = 5;
    for (int i = top_index_; i < (int)items_.size(); ++i) {
        int itemHeight = items_[i].is_image ? kThumbnailHeight : kItemHeight - 10;
        if (y >= currentY && y < currentY + itemHeight) {
            if (selected_index_ != i) {
                selected_index_ = i;
                InvalidateRect(hwnd_, NULL, FALSE);
            }
            break;
        }
        currentY += itemHeight + 10;
        if (currentY > height) break;
    }
}

void QuickPastePopupWindow::OnLButtonDown(int x, int y) {
    RECT rect;
    GetClientRect(hwnd_, &rect);
    int height = rect.bottom - rect.top;

    int currentY = 5;
    for (int i = top_index_; i < (int)items_.size(); ++i) {
        int itemHeight = items_[i].is_image ? kThumbnailHeight : kItemHeight - 10;
        if (y >= currentY && y < currentY + itemHeight) {
            if (!has_dismissed_) {
                has_dismissed_ = true;
                if (completion_handler_) {
                    completion_handler_(items_[i].id, false, std::nullopt);
                }
                DestroyWindow(hwnd_);
            }
            break;
        }
        currentY += itemHeight + 10;
        if (currentY > height) break;
    }
}

void QuickPastePopupWindow::OnKeyDown(WPARAM wParam) {
    switch (wParam) {
        case VK_UP:
            selected_index_ = std::max(0, selected_index_ - 1);
            EnsureVisible(selected_index_);
            InvalidateRect(hwnd_, NULL, FALSE);
            break;
        case VK_DOWN:
            selected_index_ = std::min((int)items_.size() - 1, selected_index_ + 1);
            EnsureVisible(selected_index_);
            InvalidateRect(hwnd_, NULL, FALSE);
            break;
        case VK_RETURN:
            if (!items_.empty() && !has_dismissed_) {
                has_dismissed_ = true;
                if (completion_handler_) {
                    completion_handler_(items_[selected_index_].id, false, std::nullopt);
                }
                DestroyWindow(hwnd_);
            }
            break;
        case VK_ESCAPE:
            Close();
            break;
    }
}

void QuickPastePopupWindow::EnsureVisible(int index) {
    if (index < top_index_) {
        top_index_ = index;
    } else {
        // Check if index is past the visible area
        RECT rect;
        GetClientRect(hwnd_, &rect);
        int height = rect.bottom - rect.top;
        
        int currentY = 5;
        for (int i = top_index_; i <= index; ++i) {
            int itemHeight = items_[i].is_image ? kThumbnailHeight : kItemHeight - 10;
            if (i == index) {
                if (currentY + itemHeight > height) {
                    // Scroll down until index is visible
                    while (currentY + itemHeight > height && top_index_ < index) {
                        int topItemHeight = items_[top_index_].is_image ? kThumbnailHeight : kItemHeight - 10;
                        currentY -= (topItemHeight + 10);
                        top_index_++;
                    }
                }
                break;
            }
            currentY += itemHeight + 10;
        }
    }
}

void QuickPastePopupWindow::DetectTheme() {
    HKEY hKey;
    is_dark_mode_ = true; // Default to dark
    if (RegOpenKeyExW(HKEY_CURRENT_USER, L"Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize", 0, KEY_READ, &hKey) == ERROR_SUCCESS) {
        DWORD value;
        DWORD size = sizeof(DWORD);
        if (RegQueryValueExW(hKey, L"AppsUseLightTheme", NULL, NULL, (LPBYTE)&value, &size) == ERROR_SUCCESS) {
            is_dark_mode_ = (value == 0);
        }
        RegCloseKey(hKey);
    }
}

void QuickPastePopupWindow::UpdateAnimation() {}

} // namespace quick_paste_popup
