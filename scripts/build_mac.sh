flutter build macos --verbose \
  --tree-shake-icons \
  --dart-define-from-file="local/prod.json" \
  --obfuscate \
  --split-debug-info=./build_symbols \
&& codesign --remove-signature \
  build/macos/Build/Products/Release/CopyCat.app
&& ditto -c -k --keepParent \
  build/macos/Build/Products/Release/CopyCat.app \
  CopyCat-macOS.zip