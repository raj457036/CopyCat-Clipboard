import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriveSetupPage extends StatelessWidget {
  const DriveSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [
          CloseButton(),
          width8,
        ],
      ),
      body: BlocConsumer<DriveSetupCubit, DriveSetupState>(
        listener: (context, state) {
          switch (state) {
            case DriveSetupDone():
              Navigator.pop(context);
              showTextSnackbar(context.locale.drive__snackbar__success);
          }
        },
        builder: (context, state) {
          switch (state) {
            case DriveSetupError(:final failure):
              return Center(
                child: Text(failure.message),
              );
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
