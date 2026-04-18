import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteItemIntent extends Intent {
  const DeleteItemIntent();

  static const activator = SingleActivator(
    LogicalKeyboardKey.backspace,
    shift: true,
    includeRepeats: false,
  );
}

class DeleteSelectedItemsAction extends ContextAction<DeleteItemIntent> {
  @override
  void invoke(DeleteItemIntent intent, [BuildContext? context]) async {
    final selectionCubit = context?.read<SelectedClipsCubit>();

    if (selectionCubit == null) return;

    final selectedClips = selectionCubit.state.whenOrNull(
      clipSelected: (value) => value,
    );
    if (selectedClips == null || selectedClips.isEmpty) return;

    if (context != null) {
      final deleted = await deleteClipboardItem(context, selectedClips);
      if (deleted) {
        selectionCubit.clear();
      }
    }
  }
}
