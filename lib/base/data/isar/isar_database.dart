import 'package:clipboard/base/data/isar/adapters/isar_app_config.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clip_collection.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/data/isar/adapters/isar_subscription.dart';
import 'package:clipboard/base/data/isar/adapters/isar_sync_status.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

/// Opens the Isar database with all adapter schemas registered.
Future<Isar> openIsarDatabase(String path, String name) async {
  return Isar.open(
    [
      IsarClipboardItemSchema,
      IsarAppConfigSchema,
      IsarSyncStatusSchema,
      IsarClipCollectionSchema,
      IsarSubscriptionSchema,
    ],
    directory: path,
    relaxedDurability: true,
    inspector: kDebugMode,
    name: name,
  );
}
