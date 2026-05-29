#include "include/quick_paste_popup/quick_paste_popup_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "quick_paste_popup_plugin.h"

void QuickPastePopupPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  quick_paste_popup::QuickPastePopupPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
