import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/pages/login/widgets/login_form.dart';
import 'package:clipboard/pages/login/widgets/login_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormPage extends StatelessWidget {
  const LoginFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        switch (state) {
          case UnauthenticatedAuthState(:final failure):
            if (failure == null) return;
            InAppNotificationService.i.notify(
              NotificationMessage(id: "login_failed", body: failure.message),
            );
          default:
        }
      },
      child: const LoginPageScaffold(child: LoginForm()),
    );
  }
}
