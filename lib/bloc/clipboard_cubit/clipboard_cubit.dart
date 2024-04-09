import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/bloc/clipboard_cubit/utils.dart';
import 'package:clipboard/bloc/sync_manager_cubit/sync_manager_cubit.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/data/repositories/clipboard.dart';
import 'package:clipboard/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:super_clipboard/super_clipboard.dart';

part 'clipboard_cubit.freezed.dart';
part 'clipboard_state.dart';

@singleton
class ClipboardCubit extends Cubit<ClipboardState> with ClipboardListener {
  final ClipboardRepository repo;
  final AuthCubit authCubit;
  final SyncManagerCubit syncManager;

  bool _writing = false;

  ClipboardCubit(
    this.repo,
    this.authCubit,
    this.syncManager,
  ) : super(const ClipboardState.loaded(items: [])) {
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();
  }

  Future<void> fetch({bool fromTop = false}) async {
    emit(state.copyWith(loading: true));

    final items = await repo.getList(
      limit: state.limit,
      offset: fromTop ? 0 : state.offset,
    );

    emit(
      items.fold(
        (l) => state.copyWith(
          failure: l,
          loading: false,
        ),
        (r) => state.copyWith(
          loading: false,
          items: fromTop ? r.results : [...state.items, ...r.results],
          offset: state.offset + r.results.length,
          limit: state.limit,
          hasMore: r.hasMore,
        ),
      ),
    );
  }

  Future<bool> copyToClipboard(ClipboardItem item,
      [bool copyFileContent = false]) async {
    _writing = true;
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      logger.severe("Clipboard is not available.");
      return false;
    }

    final data = await getFormatForClipboardItem(item, copyFileContent);
    if (data == null) return false;

    final items = DataWriterItem()..add(data);
    await clipboard.write([items]);
    await Future.delayed(Durations.short1, () => _writing = false);
    return true;
  }

  bool isSameAsLastItem(ClipboardItem item) {
    return state.items.isNotEmpty &&
        state.items.first.type == item.type &&
        state.items.first.value == item.value;
  }

  Future<void> addItem(ClipboardItem item) async {
    if (isSameAsLastItem(item)) {
      logger.info("Ignored Duplicate item");
      return;
    }

    final result = await repo.create(item);

    await result.fold((l) async {
      logger.severe(l);
    }, (r) async {
      emit(state.copyWith(items: [r, ...state.items]));
      await syncManager.updateSyncTime();
    });
  }

  Future<Failure?> deleteItem(ClipboardItem item) async {
    emit(state.copyWith(items: state.items.where((it) => it != item).toList()));
    await item.cleanUp();

    final result = await repo.delete(item);
    return result.fold((l) => l, (r) => null);
  }

  Future<void> _readClipboard() async {
    await Future.delayed(Durations.short3);
    if (authCubit.userId == null) return;
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      logger.severe("Clipboard is not available.");
      return;
    }

    final reader = await clipboard.read();

    final priority = [
      Formats.png,
      Formats.jpeg,
      Formats.gif,
      Formats.tiff,
      Formats.webp,
      Formats.heic,
      Formats.svg,
      Formats.fileUri,
      Formats.uri,
      Formats.plainTextFile,
      Formats.plainText,
    ];

    if (reader.items.isEmpty) {
      logger.warning("No item in clipboard");
      return;
    }

    final res = <DataFormat>{};

    for (final item in reader.items) {
      DataFormat? selectedFormat;
      final itemFormats = item.getFormats(Formats.standardFormats);
      for (final format in itemFormats) {
        if (selectedFormat == null) {
          selectedFormat = format;
          continue;
        }

        final pref = priority.indexOf(format);
        final selectedPref = priority.indexOf(selectedFormat);

        if ((pref != -1 && pref < selectedPref) || selectedPref == -1) {
          selectedFormat = format;
        }
      }
      if (selectedFormat != null) {
        res.add(selectedFormat);
      }
    }

    final items = await Future.wait(res.map((format) =>
        getClipboardItemForFormat(authCubit.userId!, format, reader)));

    for (var item in items.where((element) => element != null)) {
      await addItem(item!);
    }
  }

  @override
  void onClipboardChanged() {
    if (_writing) {
      return;
    }
    logger.info("Copy Event Captured");

    _readClipboard();
  }

  @override
  Future<void> close() {
    clipboardWatcher.removeListener(this);
    clipboardWatcher.stop();
    return super.close();
  }
}
