import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final authCubit = context.read<AuthCubit>();
    await authCubit.checkForAuthentication();

    if (!mounted) return;

    authCubit.state.maybeWhen(
      authenticated: (user, accessToken, onBoarded) {
        if (!onBoarded) {
          context.goNamed(RouteConstants.onboard);
        } else {
          context.goNamed(RouteConstants.home);
        }
      },
      orElse: () => context.goNamed(RouteConstants.login),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Text(context.locale.splash__checking_authentication),
          ],
        ),
      ),
    );
  }
}
