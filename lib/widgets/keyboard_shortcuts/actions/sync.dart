import 'package:copycat_base/bloc/collection_sync_manager_cubit/collection_sync_manager_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class SyncIntent extends Intent {
  const SyncIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyR,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class SyncAction extends ContextAction<SyncIntent> {
  @override
  void invoke(SyncIntent intent, [BuildContext? context]) {
    final cubit = context?.read<CollectionSyncManagerCubit>();
    cubit?.syncCollections(manual: true);
  }
}
