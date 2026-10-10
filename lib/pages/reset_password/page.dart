import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/forms/reset_password_form.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.locale.reset_password__appbar__title)),
      body: Center(
        child: BlocSelector<AuthCubit, AuthState, String?>(
          selector: (state) {
            if (state is AuthenticatedAuthState) {
              return state.accessToken;
            }
            return null;
          },
          builder: (context, accessToken) {
            if (accessToken == null) {
              return const Center(child: YarnBallLoading());
            }
            return SizedBox(
              width: 300,
              height: 300,
              child: ResetPasswordForm(
                accessToken: accessToken,
                onSuccess: (user) {
                  context.pop();
                },
                onError: (error) {
                  InAppNotificationService.i.notify(
                    NotificationMessage(
                      id: "reset_password_error",
                      body: error.toString(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
