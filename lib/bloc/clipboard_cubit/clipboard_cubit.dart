import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/data/repositories/clipboard.dart';
import 'package:clipboard/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

part 'clipboard_cubit.freezed.dart';
part 'clipboard_state.dart';

@singleton
class ClipboardCubit extends Cubit<ClipboardState> {
  final ClipboardRepository repo;
  final Isar db;

  ClipboardCubit(
    @Named("offline") this.repo,
    this.db,
  ) : super(const ClipboardState.loaded(items: []));

  Future<void> fixDatabase() async {
    // await db
    //     .writeTxn(() async => await .deleteAll([77, 87, 79]));
  }

  void reset() {
    emit(const ClipboardState.loaded(items: []));
  }

  Future<ClipboardItem?> getItem({required int id}) async {
    ClipboardItem? item = state.items.findFirst((item) => item.id == id);

    if (item == null) {
      final result = await repo.get(id: id);
      result.fold((l) => logger.e(l), (r) => item = r);
    }
    return item;
  }

  void put(ClipboardItem item, {bool isNew = false}) {
    if (isNew) {
      emit(state.copyWith(items: [item, ...state.items]));
    } else {
      final items = state.items.replaceWhere((it) => it.id == item.id, item);
      emit(
        state.copyWith(items: items),
      );
    }
  }

  Future<void> fetch({bool fromTop = false}) async {
    await fixDatabase();
    emit(
      state.copyWith(
        loading: true,
        offset: fromTop ? 0 : state.offset,
      ),
    );

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

  Future<void> deleteItem(ClipboardItem item) async {
    emit(
      state.copyWith(
        items: state.items.where((it) => it.id != item.id).toList(),
      ),
    );
  }
}
