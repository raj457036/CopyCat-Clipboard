import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/domain/model/application_meta/activity_meta_payload.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/analytics.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/data/services/lan_sync_service.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:focus_window/platform/activity_info.dart';
import 'package:share_plus/share_plus.dart';
import "package:universal_io/io.dart";

part 'offline_persistance_cubit.freezed.dart';
part 'offline_persistance_state.dart';

@lazySingleton
class OfflinePersistenceCubit extends Cubit<OfflinePersistanceState> {
  final AuthCubit auth;
  final ClipboardRepository repo;
  final ClipboardService clipboard;
  final AppConfigCubit appConfig;
  final ApplicationMetaResolver appMetaResolver;
  final String deviceId;
  final AnalyticsRepository analyticsRepo;
  final SyncEventBus syncEventBus;
  final StreamController<ClipboardItem> _newClipboardItem =
      StreamController<ClipboardItem>.broadcast();

  bool _listening = false;

  StreamSubscription<List<ClipItem?>>? copySub;

  OfflinePersistenceCubit(
    this.auth,
    @Named("local") this.repo,
    this.clipboard,
    this.appConfig,
    this.appMetaResolver,
    this.analyticsRepo,
    @Named("device_id") this.deviceId,
    this.syncEventBus,
  ) : super(const OfflinePersistanceState.initial());

  Stream<ClipboardItem> get newClipboardItemStream => _newClipboardItem.stream;

  void clearTransientState() {
    if (state is OfflinePersistanceInitial) return;
    emit(const OfflinePersistanceState.initial());
  }

  ActivityMetaPayload? _toActivityMetaPayload(ActivityInfo? activity) {
    if (activity == null) return null;
    return ActivityMetaPayload(
      identifier: activity.identifier,
      appName: activity.app,
      appFilePath: activity.appFilePath,
      os: currentPlatformOS(),
    );
  }

  Future<ClipboardItem?> getItem({required int id}) async {
    final result = await repo.get(id: id);
    final item = result.fold(
      (l) {
        logger.e(l);
        return null;
      },
      (r) {
        return r;
      },
    );
    return item;
  }

  Future<void> onCaptureClipboard() async {
    emit(const OfflinePersistanceState.initial());
    if (appConfig.isCopyingPaused) {
      logger.i("Copying is paused!");
      emit(
        const OfflinePersistanceState.error(
          Failure(message: "Copying is paused!", code: "copy-paused"),
        ),
      );
      return;
    }
    if (await appConfig.isCopyingAllowedByActivity()) {
      await clipboard.readClipboard(
        preventDuplicate: appConfig.duplicatePrevention,
      );
    }
  }

  Future<void> startListeners() async {
    if (_listening) return;
    // Always sync capture mode from current config before listening.
    // This guarantees rich data capture follows the toggle from app startup.
    clipboard.setRichDataEnabled(appConfig.state.config.richDataCapture);
    clipboard.start(onCaptureClipboard);
    copySub = clipboard.onCopy?.listen(onClips);
    _listening = true;
  }

  Future<void> paste([String? content]) async {
    if (content == null) {
      final clips = await clipboard.readClipboard(manual: true);
      if (clips != null) {
        await onClips(clips, manualPaste: true);
      }
    } else if (content.isNotEmpty) {
      final clip = ClipItem.text(text: content);
      await onClips([clip], manualPaste: true);
    }
  }

  Future<bool> shareClipboardItem(
    BuildContext context,
    ClipboardItem item,
  ) async {
    return shareClipboardItems(context, [item]);
  }

  Future<bool> shareClipboardItems(
    BuildContext context,
    List<ClipboardItem> items,
  ) async {
    if (items.isEmpty) return false;

    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    final shareableItems = items.where((item) => item.inCache).toList();
    if (shareableItems.isEmpty) return false;

    final fileItems = <XFile>[];
    final textPayload = <String>[];

    for (final item in shareableItems) {
      switch (item.type) {
        case ClipItemType.text:
          final text = item.text?.trim();
          if (text != null && text.isNotEmpty) {
            textPayload.add(text);
          }
        case ClipItemType.url:
          final url = item.url?.trim();
          if (url != null && url.isNotEmpty) {
            textPayload.add(url);
          }
        case ClipItemType.media:
        case ClipItemType.file:
          final path = item.localPath;
          if (path != null && path.isNotEmpty) {
            fileItems.add(XFile(path));
          }
      }
    }

    final text = textPayload.join("\n\n");
    final firstItem = shareableItems.first;

    if (fileItems.isNotEmpty) {
      await Share.shareXFiles(
        fileItems,
        subject: firstItem.title,
        text: text.isEmpty ? firstItem.description : text,
        sharePositionOrigin: origin,
      );
    } else if (text.isNotEmpty) {
      await Share.share(
        text,
        subject: firstItem.title,
        sharePositionOrigin: origin,
      );
    } else {
      return false;
    }

    analyticsRepo.logFeatureUsed(feature: "share");
    return true;
  }

  /// Replaces any preview-only items with their fully-loaded counterparts so
  /// that truncated text or stripped rich data is never written to the system
  /// clipboard.
  Future<List<ClipboardItem>> _resolvePreviewItems(
    List<ClipboardItem> items,
  ) async {
    if (items.every((e) => !e.previewOnly)) return items;
    return Future.wait(
      items.map((item) async {
        if (!item.previewOnly || item.id == null) return item;
        return (await getItem(id: item.id!)) ?? item;
      }),
    );
  }

  Future<bool> copyToClipboard(
    List<ClipboardItem> items, {
    bool saveFile = false,
    TextPasteFormat textPasteFormat = TextPasteFormat.auto,
  }) async {
    items = await _resolvePreviewItems(items);
    final copy = CopyToClipboard();

    for (final item in items) {
      switch (item.type) {
        case ClipItemType.text:
          await copy.writeRichText(
            clipboard,
            text: item.text ?? "",
            richData: item.richData,
            mode: textPasteFormat,
          );
        case ClipItemType.url:
          copy.writeUrl(Uri.tryParse(item.url ?? ""));
        case ClipItemType.media:
        case ClipItemType.file:
          if (item.localPath == null) return false;
          if (saveFile) {
            await copy.saveFile(File(item.localPath!));
          } else {
            await copy.writeFileContent(
              File(item.localPath!),
              mimeType: item.fileMimeType,
            );
          }
      }
    }

    final copied = await copy.commit(clipboard);

    if (copied) {
      persist(
        items
            .skipWhile((item) => item.id == null)
            .map(
              (item) => item.copyWith(
                copiedCount: item.copiedCount + 1,
                lastCopied: systemTime(),
              ),
            )
            .toList(),
        updatedFields: ["copiedCount"],
      );
    }

    return copied;
  }

  Future<ClipboardItem> _convertToClipboardItem(
    ClipItem clip, {
    ActivityInfo? activity,
    String? sourceId,
  }) async {
    final userId = auth.userId;
    final sourceApp = (activity?.app ?? "").trim().isEmpty
        ? null
        : activity!.app;
    final sourceUrl = (activity?.url ?? "").trim().isEmpty
        ? null
        : activity!.url;

    switch (clip.type) {
      case ClipItemType.text:
        return ClipboardItem.fromText(
          clip.text!,
          userId: userId,
          category: clip.textCategory,
          sourceApp: sourceApp,
          sourceUrl: sourceUrl,
          sourceId: sourceId,
          richData: clip.richData,
        );
      case ClipItemType.media:
        {
          final path = clip.file!.path;
          return ClipboardItem.fromMedia(
            path,
            userId: userId,
            fileName: clip.fileName,
            fileMimeType: clip.fileMimeType,
            fileExtension: clip.fileExtension,
            fileSize: clip.fileSize,
            blurHash: clip.blurHash,
            sourceApp: sourceApp,
            sourceUrl: sourceUrl ?? clip.uri?.toString(),
            sourceId: sourceId,
          );
        }
      case ClipItemType.file:
        {
          final path = clip.file!.path;

          return ClipboardItem.fromFile(
            path,
            userId: userId,
            preview: clip.text?.sub(end: 256),
            fileName: clip.fileName,
            fileMimeType: clip.fileMimeType,
            fileExtension: clip.fileExtension,
            fileSize: clip.fileSize,
            sourceApp: sourceApp,
            sourceUrl: sourceUrl ?? clip.uri?.toString(),
            sourceId: sourceId,
          );
        }
      case ClipItemType.url:
        return ClipboardItem.fromURL(
          clip.uri!,
          userId: userId,
          sourceApp: sourceApp,
          sourceUrl: sourceUrl,
          sourceId: sourceId,
        );
    }
  }

  Future<void> onClips(
    List<ClipItem?> clips, {
    bool manualPaste = false,
  }) async {
    if (clips.isEmpty) return;

    final activity = appConfig.lastActivity;
    final sourceId = await appMetaResolver.syncFromActivity(
      _toActivityMetaPayload(activity),
    );

    for (final clip in clips) {
      if (clip == null) continue;
      if (exclusionChecker != null && clip.isTextSubType) {
        final content = clip.text ?? clip.uri?.toString();
        if (content != null &&
            !exclusionChecker!.isClipAllowed(clip, activity)) {
          continue;
        }
      }

      if (!manualPaste &&
          clip.fileSize != null &&
          !appConfig.canCopyFile(clip.fileSize!)) {
        unawaited(clip.cleanup());

        emit(
          const OfflinePersistanceState.error(
            Failure(
              message: "Auto copy is disabled for files over the limit",
              code: "auto-copy-restrictions",
            ),
          ),
        );
        return;
      }

      if (clip.isDuplicate) {
        emit(
          const OfflinePersistanceState.error(
            Failure(message: "Duplicate Clip Detected", code: "duplicate-clip"),
          ),
        );
        return;
      }

      final item = await _convertToClipboardItem(
        clip,
        activity: activity,
        sourceId: sourceId,
      );

      if (manualPaste) {
        final userItem = item.copyWith(userIntent: manualPaste);
        await persist([userItem]);
        continue;
      }
      _newClipboardItem.add(item);
      await persist([item]);
    }
  }

  Future<void> persist(
    List<ClipboardItem> items, {
    bool synced = false,
    List<String>? updatedFields,
  }) async {
    final persited = items
        .where((item) => item.isPersisted)
        .map(
          (item) => item.copyWith(
            deviceId: deviceId,
            userId: auth.userId ?? kLocalUserId,
          ),
        )
        .toList();
    final nonPersisted = items
        .where((item) => !item.isPersisted)
        .map(
          (item) => item.copyWith(
            deviceId: deviceId,
            userId: auth.userId ?? kLocalUserId,
          ),
        )
        .toList();

    if (nonPersisted.isNotEmpty) {
      emit(OfflinePersistanceState.creatingItems(nonPersisted.length));
      final results = await Future.wait(
        nonPersisted.map((item) => repo.create(item)),
      );

      for (var result in results) {
        result.fold((l) => emit(OfflinePersistanceState.error(l)), (r) {
          syncEventBus.emit<ClipboardItem>((
            synced ? CrossSyncEventType.update : CrossSyncEventType.create,
            r,
          ));
          if (!synced &&
              appConfig.state.config.lanInstantSync &&
              !Platform.isAndroid &&
              !Platform.isIOS) {
            unawaited(sl<LanSyncService>().broadcastClip(r));
          }
          emit(
            OfflinePersistanceState.saved(
              count: 1,
              created: true,
              synced: synced,
              updatedFields: updatedFields,
            ),
          );
        });
      }
      return;
    }

    // If all items are already persisted, we just need to update the items.
    emit(OfflinePersistanceState.updatingItems(persited.length));
    final updated = await Future.wait(
      persited.map((item) => repo.update(item)),
    );

    for (var result in updated) {
      result.fold((l) => emit(OfflinePersistanceState.error(l)), (r) {
        syncEventBus.emit<ClipboardItem>((CrossSyncEventType.update, r));
        emit(
          OfflinePersistanceState.saved(
            synced: synced,
            updatedFields: updatedFields,
            count: 1,
          ),
        );
      });
    }
  }

  Future<void> delete(List<ClipboardItem> items) async {
    emit(OfflinePersistanceState.deletingItems(items.length));
    final items_ = items.map((item) => item.copyWith(deviceId: deviceId));
    await repo.deleteMany(items_.toList());
    final deleteEvents = items
        .map<CrossSyncEvent<ClipboardItem>>(
          (item) => (CrossSyncEventType.delete, item),
        )
        .toList();
    if (deleteEvents.length == 1) {
      syncEventBus.emit<ClipboardItem>(deleteEvents.first);
    } else if (deleteEvents.isNotEmpty) {
      syncEventBus.emitBatch<ClipboardItem>(deleteEvents);
    }
    emit(OfflinePersistanceState.deletedItems(items.length));
  }

  void stopListeners() {
    if (!_listening) return;
    clipboard.dispose();
    copySub?.cancel();
    copySub = null;
    _listening = false;
  }

  @override
  Future<void> close() {
    stopListeners();
    return super.close();
  }
}
