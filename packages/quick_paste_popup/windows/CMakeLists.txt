cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME "quick_paste_popup")
project(${PROJECT_NAME} LANGUAGES CXX)

add_library(${PROJECT_NAME}_plugin SHARED
  "quick_paste_popup_plugin.cpp"
  "quick_paste_popup_plugin.h"
  "quick_paste_popup_window.cpp"
  "quick_paste_popup_window.h"
  "quick_paste_popup_plugin_c_api.cpp"
  "include/quick_paste_popup/quick_paste_popup_plugin_c_api.h"
)

set_target_properties(${PROJECT_NAME}_plugin PROPERTIES
  CXX_STANDARD 17
)

target_compile_definitions(${PROJECT_NAME}_plugin PRIVATE "FLUTTER_PLUGIN_IMPL")

target_include_directories(${PROJECT_NAME}_plugin INTERFACE
  "include"
)

target_link_libraries(${PROJECT_NAME}_plugin PRIVATE
  flutter
  flutter_wrapper_plugin
  dwmapi
  gdiplus
  shlwapi
  user32
  ole32
  oleaut32
  uiautomationcore
)

list(APPEND PLUGIN_BUNDLED_LIBRARIES
  flutter
)
