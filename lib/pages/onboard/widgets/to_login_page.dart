import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ToLoginPageButton extends StatelessWidget {
  const ToLoginPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.goNamed(RouteConstants.login);
      },
      label: Text(context.locale.onboarding__button__to_login),
      icon: const Icon(Icons.login),
    );
  }
}
