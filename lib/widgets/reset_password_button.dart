import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordButton extends StatelessWidget {
  final bool iconButton;
  const ResetPasswordButton({
    super.key,
    this.iconButton = true,
  });

  Future<void> resetPassword(BuildContext context) async {
    context.pushNamed(RouteConstants.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    if (iconButton) {
      return IconButton.filledTonal(
        icon: const Icon(Icons.lock_person_rounded),
        tooltip: context.locale.reset_pass__text__label,
        onPressed: () => resetPassword(context),
      );
    }
    return FilledButton.icon(
      icon: const Icon(Icons.lock_person_rounded),
      label: Text(context.locale.reset_pass__text__label),
      onPressed: () => resetPassword(context),
    );
  }
}
