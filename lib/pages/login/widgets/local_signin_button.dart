import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalSigninButton extends StatelessWidget {
  const LocalSigninButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Tooltip(
        message: context.locale.login__local_signin__tooltip,
        child: OutlinedButton.icon(
          onPressed: () {
            final cubit = context.read<AuthCubit>();
            cubit.localAuthenticated();
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
          ),
          icon: const Icon(Icons.cloud_off_rounded),
          label: Text(context.locale.login__local_signin__btn__label),
        ),
      ),
    );
  }
}
