import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/domain/model/localization.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/widgets/forms/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.reset_password__appbar__title),
      ),
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SizedBox(
              width: 300,
              height: 300,
              child: ResetPasswordForm(
                localization: AuthUserResetPasswordFormLocalization(
                  passwordResetSent: context.locale.reset_password__success_ack,
                  enterPassword: context.locale.login__form__input__password,
                  passwordLengthError:
                      context.locale.login__form__input__error_password_length,
                  updatePassword:
                      context.locale.login__form__button__update_password,
                  unexpectedError: context.locale.app__unknown_error,
                ),
                accessToken: accessToken,
                onSuccess: (user) {
                  context.pop();
                },
                onError: (error) {
                  showTextSnackbar(error.toString(), failure: true);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
