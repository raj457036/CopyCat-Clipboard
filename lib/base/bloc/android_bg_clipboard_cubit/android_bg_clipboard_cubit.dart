import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:bloc/bloc.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'android_bg_clipboard_cubit.freezed.dart';
part 'android_bg_clipboard_state.dart';

@injectable
class AndroidBgClipboardCubit extends Cubit<AndroidBgClipboardState> {
  final SyncEventBus syncEventBus;
  final AndroidBackgroundClipboard plugin;
  final ClipboardRepository clipRepo;
  final String deviceId;
  bool isSyncing = false;

  AndroidBgClipboardCubit(
    this.plugin,
    this.syncEventBus,
    @Named("local") this.clipRepo,
    @Named("device_id") this.deviceId,
  ) : super(const AndroidBgClipboardState.unknown());

  Future<void> updateExclusionRule(ExclusionRules? rules) async {
    if (rules != null && rules.enable) {
      plugin.writeShared('exclude-email', rules.email);
      plugin.writeShared('exclude-phone', rules.phone);
      plugin.writeShared('exclude-pass-mgr', rules.passwordManager);
      plugin.writeShared(
        '<set>excludedPackages',
        rules.apps.map((e) => e.identifier).join(","),
      );
    } else {
      plugin.deleteShared([
        'exclude-email',
        'exclude-phone',
        'exclude-pass-mgr',
        'excludedPackages',
      ]);
    }
  }

  Future<bool> writeToLocal(ClipboardItem item) async {
    final result = await clipRepo.updateOrCreate(item);
    return result.fold((failure) => false, (item) async {
      item = await item.decrypt();
      syncEventBus.emit<ClipboardItem>((CrossSyncEventType.create, item));
      return true;
    });
  }

  ClipboardItem parseClip(Map clip) {
    final ClipItemType clipType = switch (clip["type"]) {
      "Text" => ClipItemType.text,
      "Url" => ClipItemType.url,
      "Email" => ClipItemType.text,
      "Phone" => ClipItemType.text,
      "FileUrl" => ClipItemType.file, // TODO(raj): add support for files
      _ => ClipItemType.text,
    };
    final TextCategory? textCategory = switch (clip["type"]) {
      "Email" => TextCategory.email,
      "Phone" => TextCategory.phone,
      _ => null,
    };
    final desc = clip["label"] as String?;
    final serverIdRaw = clip["serverId"];
    final serverId = serverIdRaw is num ? serverIdRaw.toInt() : -1;
    final timestampRaw = clip["timestamp"];
    final timestamp = timestampRaw is num
        ? DateTime.fromMillisecondsSinceEpoch(timestampRaw.toInt())
        : systemTime();
    final clipText = clip["text"] as String?;
    final encrypted = clip["encrypted"] == true;
    final iv = clip["iv"] as String?;
    final encMode = clip["encMode"] as String?;
    return ClipboardItem(
      created: timestamp,
      modified: timestamp,
      type: clipType,
      os: PlatformOS.android,
      encrypted: encrypted,
      iv: iv,
      encMode: encMode,
      textCategory: textCategory,
      text: clipType == ClipItemType.text ? clipText : null,
      url: clipType == ClipItemType.url ? clipText : null,
      title: desc,
      description: desc,
      serverId: serverId == -1 ? null : serverId,
      lastSynced: systemTime(),
      deviceId: deviceId,
    );
  }

  Future<void> syncStates() async {
    if (isSyncing) return;
    isSyncing = true;
    try {
      final endMark = await plugin.readShared<int>("endId") ?? -1;
      if (endMark == -1) return;

      const batchSize = 100;
      final deleteKeys = <String>[];
      final seenKeys = <String>{};

      for (var start = 0; start <= endMark; start += batchSize) {
        final end = (start + batchSize - 1 > endMark)
            ? endMark
            : start + batchSize - 1;
        final clips = await plugin.readClipsBatch(start, end);

        for (final clip in clips) {
          if (clip.isEmpty) continue;

          final clipKey = clip['id'] as String?;
          if (clipKey == null || clipKey.isEmpty) continue;

          seenKeys.add(clipKey);
          final clipItem = parseClip(clip);
          final success = await writeToLocal(clipItem);
          if (success) {
            deleteKeys.add(clipKey);
          }
        }
      }

      for (var i = 0; i < endMark + 1; i++) {
        final clipKey = "Clip-$i";
        if (!seenKeys.contains(clipKey)) {
          deleteKeys.add(clipKey);
        }
      }

      await plugin.writeShared("endId", -1);
      await plugin.deleteShared(deleteKeys);
    } finally {
      isSyncing = false;
    }
  }
}
