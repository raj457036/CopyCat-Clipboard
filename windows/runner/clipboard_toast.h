#pragma once

#include <string>

namespace clipboard_toast
{
    void ShowClipboardFeedback(const std::string &message, bool showToast,
                               double durationSeconds = 1.8);
} // namespace clipboard_toast
