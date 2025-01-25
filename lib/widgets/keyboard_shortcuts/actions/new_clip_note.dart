import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class CreateNewClipNoteIntent extends Intent {
  const CreateNewClipNoteIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyN,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class CreateNewClipNoteAction extends ContextAction<CreateNewClipNoteIntent> {
  @override
  void invoke(CreateNewClipNoteIntent intent, [BuildContext? context]) {
    context?.pushNamed(RouteConstants.createClipNote);
  }
}
