import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart'
    show SelectedClipsCubit, SelectedClipsState, ClipSelected;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;

typedef OnSelectedClip =
    Widget Function(BuildContext context, Set<ClipboardItem> selectedItems);

class SelectedClipBuilder extends StatelessWidget {
  final OnSelectedClip builder;
  const SelectedClipBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedClipsCubit, SelectedClipsState>(
      builder: (context, state) {
        if (state is ClipSelected) {
          return builder(context, state.selectedClipIds);
        }
        return builder(context, {});
      },
    );
  }
}
