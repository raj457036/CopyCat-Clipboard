import 'package:copycat_base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedClipProvider extends StatelessWidget {
  final Widget Function(BuildContext context, Set<ClipboardItem> clipIds)
      builder;
  const SelectedClipProvider({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedClipsCubit, SelectedClipsState>(
      builder: (context, state) {
        final Set<ClipboardItem> items = switch (state) {
          NoClipSelected() => const {},
          ClipSelected(:final selectedClipIds) => selectedClipIds,
        };
        return builder(context, items);
      },
    );
  }
}
