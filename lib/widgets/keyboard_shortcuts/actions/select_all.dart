import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart'
    show SelectedClipsCubit;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class SelectAllIntent extends Intent {
  const SelectAllIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyA,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class SelectAllAction extends ContextAction<SelectAllIntent> {
  @override
  void invoke(SelectAllIntent intent, [BuildContext? context]) {
    if (context == null) return;

    final allClips = ClipsProvider.of(context)?.clips;
    if (allClips == null || allClips.isEmpty) return;
    final selectCubit = context.read<SelectedClipsCubit?>();
    if (selectCubit == null) return;
    selectCubit.selectAll(allClips);
  }
}
