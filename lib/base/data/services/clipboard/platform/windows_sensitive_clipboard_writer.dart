import 'dart:ffi';
import 'package:clipboard/base/data/services/clipboard/sensitive_clipboard_writer.dart';
import 'package:clipboard/common/logging.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class WindowsSensitiveClipboardWriter implements SensitiveClipboardWriter {
  @override
  Future<bool> writeSensitiveText(String text) async {
    if (OpenClipboard(NULL) == FALSE) {
      logger.w(
        () => '[WindowsSensitiveClipboardWriter] Failed to open clipboard',
      );
      return false;
    }
    try {
      EmptyClipboard();

      final units = text.codeUnits;
      final bytesCount = (units.length + 1) * 2;
      final hMemText = GlobalAlloc(GHND, bytesCount);
      if (hMemText.address != 0) {
        final pMem = GlobalLock(hMemText);
        if (pMem.address != 0) {
          final pUtf16 = pMem.cast<Uint16>();
          for (var i = 0; i < units.length; i++) {
            pUtf16[i] = units[i];
          }
          pUtf16[units.length] = 0;
          GlobalUnlock(hMemText);
          SetClipboardData(CF_UNICODETEXT, hMemText.address);
        } else {
          GlobalFree(hMemText);
        }
      }

      void setDwordFormat(String formatName, int value) {
        final formatNamePtr = formatName.toNativeUtf16();
        final formatId = RegisterClipboardFormat(formatNamePtr);
        calloc.free(formatNamePtr);

        if (formatId == 0) return;

        final hMem = GlobalAlloc(GHND, sizeOf<DWORD>());
        if (hMem.address == 0) return;

        final pMem = GlobalLock(hMem);
        if (pMem.address == 0) {
          GlobalFree(hMem);
          return;
        }

        pMem.cast<DWORD>().value = value;
        GlobalUnlock(hMem);
        SetClipboardData(formatId, hMem.address);
      }

      setDwordFormat('CanIncludeInClipboardHistory', 0);
      setDwordFormat('CanUploadToCloudClipboard', 0);
      setDwordFormat('Clipboard Viewer Ignore', 0);
      return true;
    } catch (e) {
      logger.e(
        () =>
            '[WindowsSensitiveClipboardWriter] Error writing sensitive text: $e',
      );
      return false;
    } finally {
      CloseClipboard();
    }
  }
}
