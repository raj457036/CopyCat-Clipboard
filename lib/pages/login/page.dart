// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/pages/login/widgets/login_form.dart';
import 'package:clipboard/widgets/dialogs/attention.dart';
import 'package:copycat_base/bloc/auth_cubit/auth_cubit.dart';
import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/strings/asset_constants.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> showIntoDialog() async {
    if (!isDesktopPlatform) return;
    final context = rootNavKey.currentContext;
    if (context != null) {
      const AttentionDialog().show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = context.mq;
    final isMobile = Breakpoints.isMobile(mq.size.width) ||
        mq.orientation == Orientation.portrait;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        switch (state) {
          case AuthenticatedAuthState():
            Future.delayed(
              const Duration(seconds: 2),
              showIntoDialog,
            );
          case UnauthenticatedAuthState(:final failure):
            if (failure != null) {
              showFailureSnackbar(failure);
            }
          default:
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;
            final bg = ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: isMobile ? Alignment.topCenter : Alignment.center,
                  end:
                      isMobile ? Alignment.bottomCenter : Alignment.centerRight,
                  colors: const [Colors.black, Colors.transparent],
                ).createShader(
                  Rect.fromLTRB(0, 0, rect.width, rect.height),
                );
              },
              blendMode: BlendMode.dstIn,
              child: Image(
                image: const AssetImage(AssetConstants.catInValley),
                fit: BoxFit.cover,
                height: height,
                width: width,
              ),
            );
            if (!isMobile) {
              final child = Row(
                children: [
                  Expanded(
                    flex: isMobile ? 2 : 1,
                    child: bg,
                  ),
                  Expanded(flex: isMobile ? 4 : 1, child: const LoginForm()),
                ],
              );

              return child;
            }

            return Stack(
              children: [
                Positioned(
                  height: 250,
                  child: bg,
                ),
                const LoginForm(),
              ],
            );
          },
        ),
      ),
    );
  }
}
