import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/src/localizations/supa_reset_password_localization.dart';
import 'package:supabase_auth_ui/src/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// UI component to create password reset form
class SupaResetPassword extends StatefulWidget {
  /// accessToken of the user
  final String? accessToken;

  /// Method to be called when the auth action is success
  final void Function(UserResponse response) onSuccess;

  /// Method to be called when the auth action threw an excepction
  final void Function(Object error)? onError;

  /// Localization for the form
  final SupaResetPasswordLocalization localization;

  const SupaResetPassword({
    super.key,
    this.accessToken,
    required this.onSuccess,
    this.onError,
    this.localization = const SupaResetPasswordLocalization(),
  });

  @override
  State<SupaResetPassword> createState() => _SupaResetPasswordState();
}

class _SupaResetPasswordState extends State<SupaResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = widget.localization;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return localization.passwordLengthError;
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              label: Text(localization.enterPassword),
            ),
            controller: _password,
          ),
          spacer(16),
          ElevatedButton(
            child: Text(
              localization.updatePassword,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              try {
                final response = await supabase.auth.updateUser(
                  UserAttributes(
                    password: _password.text,
                  ),
                );
                widget.onSuccess.call(response);
                // FIX use_build_context_synchronously
                if (!context.mounted) return;
                context.showSnackBar(localization.passwordResetSent);
              } on AuthException catch (error) {
                if (widget.onError == null && context.mounted) {
                  context.showErrorSnackBar(error.message);
                } else {
                  widget.onError?.call(error);
                }
              } catch (error) {
                if (widget.onError == null && context.mounted) {
                  context.showErrorSnackBar(
                      '${localization.passwordLengthError}: $error');
                } else {
                  widget.onError?.call(error);
                }
              }
            },
          ),
          spacer(10),
        ],
      ),
    );
  }
}
