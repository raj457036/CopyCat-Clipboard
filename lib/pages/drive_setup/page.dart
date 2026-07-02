import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DriveSetupPage extends StatefulWidget {
  final String? code;
  final List<String>? scopes;

  const DriveSetupPage({super.key, this.code, this.scopes});

  @override
  State<DriveSetupPage> createState() => _DriveSetupPageState();
}

class _DriveSetupPageState extends State<DriveSetupPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final code = widget.code;
      final scopes = widget.scopes;
      if (code == null || scopes == null || scopes.isEmpty) {
        context.read<DriveSetupCubit>().setupError("invalid-drive-callback");
        return;
      }
      context.read<DriveSetupCubit>().verifyAuthCodeAndSetup(code, scopes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [CloseButton(), width8],
      ),
      body: BlocConsumer<DriveSetupCubit, DriveSetupState>(
        listener: (context, state) {
          switch (state) {
            case DriveSetupDone():
              context.pop();
              InAppNotificationService.i.notify(
                NotificationMessage(
                  id: "drive_setup_success",
                  body: context.locale.drive__snackbar__success,
                ),
              );
          }
        },
        builder: (context, state) {
          switch (state) {
            case DriveSetupError(:final failure):
              return Center(child: Text(failure.message));
            case DriveSetupVerifyingCode():
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    height10,
                    Text(
                      context.locale.drive__text__setting_up,
                      textAlign: TextAlign.center,
                    ),
                    height10,
                    Text(
                      context.locale.drive__text__setting_up__warning,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
