import 'dart:math' show Random;

import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import "package:universal_io/io.dart";
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}

T clamp<T extends num>(T value, [T? min, T? max]) {
  if (min != null && value < min) return min;
  if (max != null && value > max) return max;
  return value;
}

Color? hexToColor(ClipboardItem item) {
  if (item.textCategory != TextCategory.color) return null;
  String hex = item.text!.replaceAll('#', '');

  if (hex.length == 3) {
    hex = 'FF${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
  } else if (hex.length == 6) {
    hex = 'FF$hex';
  }

  return Color(int.parse(hex, radix: 16));
}

Color? getFg(Color? bg) {
  if (bg == null) return null;
  return bg.computeLuminance() < 0.5 ? Colors.white70 : Colors.black87;
}

Future<void> screenshotAsFile(
  BuildContext context,
  DeviceScreenshot screenshot,
) async {
  final filePath = await FilePicker.platform.saveFile(
    dialogTitle: 'Save to',
    type: FileType.image,
    fileName: 'screenshot_${const Uuid().v4()}.png',
    bytes: screenshot.bytes,
  );

  if (filePath != null) {
    final file = File(filePath);

    file.writeAsBytesSync(screenshot.bytes);
  }
}

String keyboardShortcut({bool meta = true, required String key}) {
  if (Platform.isMacOS || Platform.isIOS) {
    return "⌘ + $key";
  }
  return "Ctrl + $key";
}

final _mediaMimeTypeRegex = RegExp(
  r'^(image|video|audio)/',
  caseSensitive: false,
);
bool isMediaType(ClipboardItem item) {
  return (item.fileMimeType?.startsWith(_mediaMimeTypeRegex) ?? false);
}

const _uuid4 = UuidV4();

/// Generates a random UUID.
String getId() => _uuid4.generate();

Duration? systemToInternetTimeOffset;

DateTime now() {
  final now_ = DateTime.now();

  // if (systemToInternetTimeOffset != null) {
  //   logger.d(
  //     "System to internet time offset: $systemToInternetTimeOffset",
  //   );
  // }
  return now_;
}

DateTime nowUTC() {
  return DateTime.now().toUtc();
}

final _random = Random();
int getRandomIndex(int max) {
  return _random.nextInt(max);
}

Future<String> getPersistedRootDirPath([String? root]) async {
  final docDir = await getApplicationDocumentsDirectory();
  final dirPath = p.join(docDir.path, "offline", root);
  await createDirectoryIfNotExists(dirPath);
  return dirPath;
}

Future<void> clearPersistedRootDirPath([String? root]) async {
  final dirPath = await getPersistedRootDirPath(root);
  final dir = Directory(dirPath);
  try {
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  } catch (e) {
    logger.e(
      "Couldn't delete directory from cache storage.",
      error: e,
    );
  }
}

Future<void> createDirectoryIfNotExists(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
}

Future<void> deleteTempFile(File file) async {
  try {
    await file.delete();
  } catch (e) {
    logger.e(
      "Couldn't delete file from temp storage.",
      error: e,
    );
  }
}

Future<void> clearPersistedRootDir() async {
  try {
    final docDir = await getApplicationDocumentsDirectory();
    final dirPath = p.join(docDir.path, "offline");
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  } catch (e) {
    logger.e(e);
  }
}

bool get isAnalyticsSupported =>
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

String formatBytes(int sizeInBytes, {bool precise = true}) {
  const mb = 1024 * 1024;
  const gb = mb * 1024;
  if (sizeInBytes < 1024) {
    return '$sizeInBytes b';
  } else if (sizeInBytes < gb) {
    return '${(sizeInBytes / mb).toStringAsFixed(precise ? 2 : 0)} MB';
  } else {
    return '${(sizeInBytes / gb).toStringAsFixed(precise ? 2 : 0)} GB';
  }
}

// Text cleanup
final cleanUpStringRegex = RegExp(r'[\x00-\x09\x0B-\x0C\x0E-\x1F\x7F]');
String? cleanUpString(String? input) {
  if (input == null) return null;
  // Problematic characters to be replaced them with an empty string

  final problematicCharacters = [
    '\u0000', // Null character
    '\uFFFD', // Replacement character
    '\uFEFF', // Byte Order Mark (BOM)
    '\u00A0', // Non-breaking space
    '\u00AD', // Soft hyphen
    '\u200B', // Zero width space
  ];

  String cleanedString = input;

  for (var char in problematicCharacters) {
    cleanedString = cleanedString.replaceAll(char, '');
  }

  // Remove other control characters (U+0001 to U+001F, U+007F), but allow newlines (\n) and carriage returns (\r)
  cleanedString = cleanedString.replaceAll(cleanUpStringRegex, '');

  return cleanedString;
}

final isDesktopPlatform =
    Platform.isLinux || Platform.isMacOS || Platform.isWindows;

final isApplePlatform = Platform.isIOS || Platform.isMacOS;

final isMobilePlatform = Platform.isIOS || Platform.isAndroid;

/// Simple wrapper around [Future.delayed] to wait for few seconds.
///
/// Default: 2 seconds
Future<void> wait([int milliSeconds = 2000]) async {
  await Future.delayed(Duration(milliseconds: milliSeconds));
}

bool get iapCatSupportedPlatform =>
    Platform.isIOS || Platform.isMacOS || Platform.isAndroid;
