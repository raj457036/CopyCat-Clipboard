import 'dart:async';

import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart' show AuthCubit;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    unawaited(context.read<AuthCubit>().checkForAuthentication());
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const YarnBallLoading(),
            Text(context.locale.splash__checking_authentication),
          ],
        ),
      ),
    );
  }
}
