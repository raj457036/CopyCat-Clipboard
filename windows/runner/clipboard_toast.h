#pragma once

#include <string>

namespace clipboard_toast {
void ShowClipboardFeedback(const std::string &message, bool showToast,
                           double durationSeconds = 3.0);
} // namespace clipboard_toast
