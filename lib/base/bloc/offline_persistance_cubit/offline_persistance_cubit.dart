import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/common/logging.dart';
import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/analytics.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import "package:universal_io/io.dart";

part 'offline_persistance_cubit.freezed.dart';
part 'offline_persistance_state.dart';

@lazySingleton
class OfflinePersistenceCubit extends Cubit<OfflinePersistanceState> {
  final AuthCubit auth;
  final ClipboardRepository repo;
  final ClipboardService clipboard;
  final CopyToClipboard copy;
  final AppConfigCubit appConfig;
  final String deviceId;
  final AnalyticsRepository analyticsRepo;

  bool _listening = false;

  StreamSubscription<List<ClipItem?>>? copySub;

  OfflinePersistenceCubit(
    this.auth,
    @Named("local") this.repo,
    this.clipboard,
    this.appConfig,
    this.analyticsRepo,
    @Named("device_id") this.deviceId,
  )   : copy = CopyToClipboard(clipboard),
        super(const OfflinePersistanceState.initial());

  Future<ClipboardItem?> getItem({required int id}) async {
    final result = await repo.get(id: id);
    final item = result.fold((l) {
      logger.e(l);
      return null;
    }, (r) {
      return r;
    });
    return item;
  }

  Future<void> onCaptureClipboard() async {
    emit(const OfflinePersistanceState.initial());
    if (appConfig.isCopyingPaused) {
      logger.i("Copying is paused!");
      emit(
        const OfflinePersistanceState.error(
          Failure(
            message: "Copying is paused!",
            code: "copy-paused",
          ),
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
    clipboard.start(onCaptureClipboard);
    copySub = clipboard.onCopy?.listen(onClips);
    _listening = true;
  }

  void stopListeners() {
    if (!_listening) return;
    clipboard.dispose();
    copySub?.cancel();
    copySub = null;
    _listening = false;
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

  Future<void> shareClipboardItem(
    BuildContext context,
    ClipboardItem item,
  ) async {
    // _onShare method:
    final box = context.findRenderObject() as RenderBox?;

    Rect? origin;

    if (box != null) {
      origin = box.localToGlobal(Offset.zero) & box.size;
    }

    switch (item.type) {
      case ClipItemType.text:
        await Share.share(
          item.text!,
          subject: item.title,
          sharePositionOrigin: origin,
        );
      case ClipItemType.url:
        await Share.shareUri(
          Uri.parse(item.url!),
          sharePositionOrigin: origin,
        );
      case ClipItemType.media:
      case ClipItemType.file:
        if (item.localPath == null) return;
        await Share.shareXFiles(
          [XFile(item.localPath!)],
          subject: item.title,
          text: item.description,
          sharePositionOrigin: origin,
        );
    }

    analyticsRepo.logFeatureUsed(feature: "share");
  }

  Future<bool> copyToClipboard(
    ClipboardItem item, {
    bool saveFile = false,
  }) async {
    bool copied = false;
    switch (item.type) {
      case ClipItemType.text:
        copied = await copy.text(item.text ?? "");
      case ClipItemType.url:
        copied = await copy.url(Uri.tryParse(item.url ?? ""));
      case ClipItemType.media:
      case ClipItemType.file:
        if (item.localPath == null) return false;
        if (saveFile) {
          copied = await copy.saveFile(File(item.localPath!));
        } else {
          copied = await copy.fileContent(
            File(item.localPath!),
            mimeType: item.fileMimeType,
          );
        }
    }

    if (copied) {
      persist(
        [
          item.copyWith(
            copiedCount: item.copiedCount + 1,
            lastCopied: now(),
          )..applyId(item)
        ],
        updatedFields: ["copiedCount"],
      );
    }

    return copied;
  }

  Future<ClipboardItem> _convertToClipboardItem(ClipItem clip) async {
    final userId = auth.userId;

    switch (clip.type) {
      case ClipItemType.text:
        return ClipboardItem.fromText(
          clip.text!,
          userId: userId,
          category: clip.textCategory,
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
          );
        }
      case ClipItemType.file:
        {
          final path = clip.file!.path;

          return ClipboardItem.fromFile(
            path,
            userId: userId,
            preview: clip.text?.substring(0, 1024),
            fileName: clip.fileName,
            fileMimeType: clip.fileMimeType,
            fileExtension: clip.fileExtension,
            fileSize: clip.fileSize,
          );
        }
      case ClipItemType.url:
        return ClipboardItem.fromURL(
          clip.uri!,
          userId: userId,
        );
    }
  }

  Future<void> onClips(
    List<ClipItem?> clips, {
    bool manualPaste = false,
  }) async {
    if (clips.isEmpty) return;

    final activity = appConfig.lastActivity;

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
        logger.i("Auto copy is disabled for files over the limit.");
        clip.cleanup();

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
            Failure(
              message: "Duplicate Clip Detected",
              code: "duplicate-clip",
            ),
          ),
        );
        return;
      }

      final item = await _convertToClipboardItem(clip);

      if (manualPaste) {
        final userItem = item.copyWith(userIntent: manualPaste)..applyId(item);
        await persist([userItem]);
        continue;
      }
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
        .map((item) => item.copyWith(deviceId: deviceId)..applyId(item))
        .toList();
    final nonPersisted = items
        .where((item) => !item.isPersisted)
        .map((item) => item.copyWith(deviceId: deviceId)..applyId(item))
        .toList();

    if (nonPersisted.isNotEmpty) {
      emit(OfflinePersistanceState.creatingItems(nonPersisted));
      final created =
          await Future.wait(nonPersisted.map((item) => repo.create(item)));

      for (var item in created) {
        emit(
          item.fold(
            (l) => OfflinePersistanceState.error(l),
            (r) => OfflinePersistanceState.saved(
              [r],
              created: true,
              synced: synced,
              updatedFields: updatedFields,
            ),
          ),
        );
      }
    } else {
      emit(OfflinePersistanceState.updatingItems(persited));
      final updated =
          await Future.wait(persited.map((item) => repo.update(item)));

      for (var item in updated) {
        emit(
          item.fold(
            (l) => OfflinePersistanceState.error(l),
            (r) => OfflinePersistanceState.saved(
              [r],
              synced: synced,
              updatedFields: updatedFields,
            ),
          ),
        );
      }
    }
  }

  Future<void> delete(List<ClipboardItem> items) async {
    emit(OfflinePersistanceState.deletingItems(items));
    await Future.wait(items.map((item) => item.cleanUp()));
    final items_ = items.where((item) => !item.isSynced).map(
          (item) => item.copyWith(deviceId: deviceId)..applyId(item),
        );
    await repo.deleteMany(items_.toList());
    emit(OfflinePersistanceState.deletedItems(items));
  }

  @override
  Future<void> close() {
    stopListeners();
    return super.close();
  }
}
