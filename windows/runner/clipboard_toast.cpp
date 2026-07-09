#include "clipboard_toast.h"

#include <windows.h>
#include <string>
#include <thread>

static const wchar_t kClipboardToastWindowClass[] = L"CopyCatClipboardToastClass";

namespace clipboard_toast
{

    LRESULT CALLBACK ToastWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
    {
        switch (msg)
        {
        case WM_CREATE:
        {
            // store the message pointer passed via lpCreateParams
            LPCREATESTRUCT pcs = reinterpret_cast<LPCREATESTRUCT>(lparam);
            if (pcs && pcs->lpCreateParams)
            {
                SetWindowLongPtr(hwnd, GWLP_USERDATA,
                                 reinterpret_cast<LONG_PTR>(pcs->lpCreateParams));
            }
            SetClassLongPtr(hwnd, GCLP_HCURSOR, (LONG_PTR)LoadCursor(nullptr, IDC_ARROW));
        }
        break;
        case WM_PAINT:
        {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            RECT rc;
            GetClientRect(hwnd, &rc);

            auto p = reinterpret_cast<std::wstring *>(GetWindowLongPtr(hwnd, GWLP_USERDATA));
            std::wstring text = p && !p->empty() ? *p : L"Copied";

            HBRUSH bgBrush = CreateSolidBrush(RGB(234, 234, 234));
            HPEN borderPen = CreatePen(PS_SOLID, 1, RGB(196, 196, 196));
            HBRUSH oldBrush = (HBRUSH)SelectObject(hdc, bgBrush);
            HPEN oldPen = (HPEN)SelectObject(hdc, borderPen);
            RoundRect(hdc, rc.left, rc.top, rc.right, rc.bottom, 18, 18);
            SelectObject(hdc, oldBrush);
            SelectObject(hdc, oldPen);
            DeleteObject(bgBrush);
            DeleteObject(borderPen);

            SetBkMode(hdc, TRANSPARENT);
            SetTextColor(hdc, RGB(32, 32, 32));

            LOGFONT lf = {};
            lf.lfHeight = -15;
            lf.lfWeight = FW_MEDIUM;
            lf.lfCharSet = DEFAULT_CHARSET;
            wcscpy_s(lf.lfFaceName, L"Segoe UI");
            HFONT hFont = CreateFontIndirect(&lf);
            HFONT oldFont = (HFONT)SelectObject(hdc, hFont);

            DrawText(hdc, text.c_str(), -1, &rc, DT_CENTER | DT_SINGLELINE | DT_VCENTER);

            SelectObject(hdc, oldFont);
            DeleteObject(hFont);
            EndPaint(hwnd, &ps);
        }
        break;
        case WM_TIMER:
        {
            KillTimer(hwnd, 1);
            DestroyWindow(hwnd);
        }
        break;
        case WM_SETCURSOR:
        {
            SetCursor(LoadCursor(nullptr, IDC_ARROW));
            return TRUE;
        }
        break;
        case WM_DESTROY:
        {
            auto p = reinterpret_cast<std::wstring *>(GetWindowLongPtr(hwnd, GWLP_USERDATA));
            if (p)
            {
                delete p;
                SetWindowLongPtr(hwnd, GWLP_USERDATA, 0);
            }
            PostQuitMessage(0);
        }
        break;
        default:
            return DefWindowProc(hwnd, msg, wparam, lparam);
        }
        return 0;
    }

    void ShowClipboardFeedback(const std::string &message, bool showToast,
                               bool playHaptic, double durationSeconds)
    {
        if (!showToast)
            return;

        // Run UI on a new thread with its own message loop
        std::thread([message, durationSeconds]()
                    {
    HINSTANCE hInstance = GetModuleHandle(nullptr);

    WNDCLASS wc = {};
    wc.lpfnWndProc = ToastWndProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = kClipboardToastWindowClass;

    RegisterClass(&wc);

    int width = 170;
    int height = 38;

    // Position near top center of primary monitor
    int screenW = GetSystemMetrics(SM_CXSCREEN);
    int x = (screenW - width) / 2;
    int y = 50;

    // allocate and convert message to wide string, pass as lpParam
    std::wstring *wmsg = new std::wstring();
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, message.c_str(), (int)message.size(), NULL, 0);
    if (size_needed > 0) {
      wmsg->resize(size_needed);
      MultiByteToWideChar(CP_UTF8, 0, message.c_str(), (int)message.size(), wmsg->data(), size_needed);
    } else {
      *wmsg = L"Copied";
    }

    HWND hwnd = CreateWindowEx(
        WS_EX_TOPMOST | WS_EX_TOOLWINDOW | WS_EX_LAYERED | WS_EX_NOACTIVATE,
        kClipboardToastWindowClass, L"", WS_POPUP | WS_VISIBLE, x, y, width,
        height, nullptr, nullptr, hInstance, reinterpret_cast<LPVOID>(wmsg));

    SetCursor(LoadCursor(nullptr, IDC_ARROW));

    if (!hwnd) {
      return;
    }

    // Make window slightly transparent
    SetLayeredWindowAttributes(hwnd, 0, (BYTE)(255 * 0.95), LWA_ALPHA);

    // Trigger paint
    InvalidateRect(hwnd, nullptr, TRUE);

    // Set timer to auto destroy
    SetTimer(hwnd, 1, static_cast<UINT>(durationSeconds * 1000), nullptr);

    // Message loop
    MSG msg;
    while (GetMessage(&msg, nullptr, 0, 0) > 0) {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }

    UnregisterClass(kClipboardToastWindowClass, hInstance); })
            .detach();
    }

} // namespace clipboard_toast
