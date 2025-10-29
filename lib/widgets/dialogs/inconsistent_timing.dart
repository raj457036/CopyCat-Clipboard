import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import 'package:universal_io/io.dart';

bool _visible = false;

class InconsistentTiming extends StatefulWidget {
  const InconsistentTiming({super.key});

  @override
  State<InconsistentTiming> createState() => _InconsistentTimingState();

  Future<void> open() async {
    if (_visible) return;
    await Future.delayed(const Duration(seconds: 5));
    windowManager
      ..show()
      ..focus();
    _visible = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAdaptiveDialog(
        context: rootNavKey.currentContext!,
        barrierDismissible: false,
        routeSettings: const RouteSettings(
          name: "Inconsistent-Time",
        ),
        builder: (context) {
          return this;
        },
      );
    });
  }
}

class _InconsistentTimingState extends State<InconsistentTiming> {
  bool autoFixing = false;
  bool checking = false;

  Future<void> autoFix(BuildContext context) async {
    // TODO(raj): add method to automatically fix the time.

    if (!Platform.isWindows || autoFixing) return;

    setState(() {
      autoFixing = true;
    });

    await Process.run(
      'powershell',
      [
        '-Command',
        'Start-Process powershell -Verb runAs -WindowStyle Hidden -ArgumentList \'-Command "w32tm /resync;"\''
      ],
      runInShell: true,
    );
    await wait(5000);
    setState(() {
      autoFixing = false;
    });
    if (!context.mounted) return;
    final fixed = await checkAgain(context);
    if (!fixed) {
      await Process.run(
        'explorer.exe', // Open the URI with Windows Explorer
        ['ms-settings:dateandtime'],
        runInShell: true,
      );
    }
  }

  Future<bool> checkAgain(BuildContext context) async {
    if (checking) return false;
    setState(() {
      checking = true;
    });
    final cubit = context.read<AppConfigCubit>();
    final result = await cubit.syncClocks();
    setState(() {
      checking = false;
    });
    if (result == true && context.mounted) {
      context.pop();
      _visible = false;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const loading = SizedBox.square(
      dimension: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
    final actionDisabled = autoFixing || checking;
    return AlertDialog.adaptive(
      title: Text(context.locale.dialog__text__inconsistent_time__title,
          textAlign: TextAlign.center),
      content: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(padding10),
          child: Text(
            context.locale.dialog__text__inconsistent_time__content,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      actions: [
        if (Platform.isWindows)
          TextButton(
            onPressed: actionDisabled ? null : () => autoFix(context),
            child: autoFixing
                ? loading
                : Text(context.locale.dialog__button__try_fix),
          ),
        TextButton(
          onPressed: actionDisabled ? null : () => checkAgain(context),
          child: checking
              ? loading
              : Text(context.locale.dialog__button__try_again),
        ),
      ],
    );
  }
}
