import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalSigninButton extends StatelessWidget {
  const LocalSigninButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Tooltip(
      message: context.locale.login__local_signin__tooltip,
      child: FilledButton.icon(
        onPressed: () {
          final cubit = context.read<AuthCubit>();
          cubit.localAuthenticated();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
        ),
        icon: const Icon(Icons.cloud_off_outlined),
        label: Text(context.locale.login__local_signin__btn__label),
      ),
    );
  }
}
