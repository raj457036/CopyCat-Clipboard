import 'dart:async';

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
import 'package:synchronized/synchronized.dart';

part 'android_bg_clipboard_cubit.freezed.dart';
part 'android_bg_clipboard_state.dart';

@injectable
class AndroidBgClipboardCubit extends Cubit<AndroidBgClipboardState> {
  final SyncEventBus syncEventBus;
  final AndroidBackgroundClipboard plugin;
  final ClipboardRepository clipRepo;
  final String deviceId;
  final _lock = Lock();
  StreamSubscription<String>? _lanClipSub;

  AndroidBgClipboardCubit(
    this.plugin,
    this.syncEventBus,
    @Named("local") this.clipRepo,
    @Named("device_id") this.deviceId,
  ) : super(const AndroidBgClipboardState.unknown()) {
    _lanClipSub = plugin.lanClipReceivedStream().listen((clipKey) {
      _syncOneLanClip(clipKey);
    });
  }

  @override
  Future<void> close() {
    _lanClipSub?.cancel();
    return super.close();
  }

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
      "FileUrl" => ClipItemType.file,
      _ => ClipItemType.text,
    };
    final TextCategory? textCategory = switch (clip["type"]) {
      "Email" => TextCategory.email,
      "Phone" => TextCategory.phone,
      _ => null,
    };
    final rawDesc = (clip["label"] as String?)?.trim();
    final desc =
        (rawDesc == null || rawDesc.isEmpty || rawDesc.toLowerCase() == 'null')
        ? null
        : rawDesc;
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
    final sourceId = (clip["sourceId"] as String?)?.trim();
    final sourceApp = (clip["sourceApp"] as String?)?.trim();
    final originId = clip["originId"] as String?;

    // For file/media types the "text" field carries the local file path stored
    // by the Android background service when a LAN binary clip was received.
    final isFileClip = clipType == ClipItemType.file;
    final localPath = isFileClip ? clipText : null;

    // Infer MIME type and upgrade to media type from the cached file extension.
    // The Android file storage format does not persist fileMimeType, so we
    // derive it from the extension written by writeBinaryClip() / handleBinaryClip().
    String? fileMimeType;
    ClipItemType resolvedType = clipType;
    if (isFileClip && localPath != null) {
      final ext = localPath.split('.').last.toLowerCase();
      const imageExts = {
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'bmp',
        'heic',
        'heif',
        'svg',
      };
      const videoExts = {'mp4', 'mov', 'avi', 'mkv', 'm4v', 'webm', '3gp'};
      if (imageExts.contains(ext)) {
        fileMimeType = ext == 'jpg'
            ? 'image/jpeg'
            : ext == 'heif'
            ? 'image/heic'
            : 'image/$ext';
        resolvedType = ClipItemType.media;
      } else if (videoExts.contains(ext)) {
        fileMimeType = ext == 'mov' ? 'video/quicktime' : 'video/$ext';
        resolvedType = ClipItemType.media;
      }
    }

    return ClipboardItem(
      created: timestamp,
      modified: timestamp,
      type: resolvedType,
      os: PlatformOS.android,
      encrypted: encrypted,
      iv: iv,
      encMode: encMode,
      textCategory: textCategory,
      text: resolvedType == ClipItemType.text ? clipText : null,
      url: resolvedType == ClipItemType.url ? clipText : null,
      localPath: localPath,
      fileName: isFileClip ? desc : null,
      fileMimeType: fileMimeType,
      title: desc,
      description: desc,
      sourceId: sourceId?.isEmpty == true ? null : sourceId,
      sourceApp: sourceApp?.isEmpty == true ? null : sourceApp,
      serverId: serverId == -1 ? null : serverId,
      lastSynced: systemTime(),
      deviceId: deviceId,
      originId: originId?.isEmpty == true ? null : originId,
    );
  }

  Future<void> _syncOneLanClip(String clipKey) async {
    await _lock.synchronized(() async {
      final index = int.tryParse(clipKey.replaceFirst('Clip-', ''));
      if (index == null) return;
      final clips = await plugin.readClipsBatch(index, index);
      if (clips.isEmpty || clips.first.isEmpty) return;
      final clipItem = parseClip(clips.first);
      final success = await writeToLocal(clipItem);
      if (success) {
        await plugin.deleteShared([clipKey]);
      }
    });
  }

  Future<void> syncStates() async {
    await _lock.synchronized(() async {
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

          final rawType = (clip['type'] as String?)?.trim();
          final rawText = (clip['text'] as String?)?.trim();
          // Legacy malformed URI captures may be stored as Text="null".
          // These should never be restored into app history.
          if (rawType == 'Text' && rawText?.toLowerCase() == 'null') {
            deleteKeys.add(clipKey);
            continue;
          }

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
    });
  }
}
