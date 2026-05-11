#ifndef FLUTTER_PLUGIN_QUICK_PASTE_POPUP_PLUGIN_C_API_H_
#define FLUTTER_PLUGIN_QUICK_PASTE_POPUP_PLUGIN_C_API_H_

#include <flutter_plugin_registrar.h>

#ifndef QUICK_PASTE_POPUP_EXPORT
#ifdef FLUTTER_PLUGIN_IMPL
#define QUICK_PASTE_POPUP_EXPORT __declspec(dllexport)
#else
#define QUICK_PASTE_POPUP_EXPORT __declspec(dllimport)
#endif
#endif

#if defined(__cplusplus)
extern "C" {
#endif

QUICK_PASTE_POPUP_EXPORT void QuickPastePopupPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // FLUTTER_PLUGIN_QUICK_PASTE_POPUP_PLUGIN_C_API_H_
