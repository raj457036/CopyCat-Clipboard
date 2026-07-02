import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonalDrivesTile extends StatelessWidget {
  const PersonalDrivesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_to_drive_rounded),
      title: Text(context.locale.settings__personal_drive__title),
      subtitle: Text(context.locale.settings__personal_drive__subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => context.goNamed(RouteConstants.personalDrives),
    );
  }
}
