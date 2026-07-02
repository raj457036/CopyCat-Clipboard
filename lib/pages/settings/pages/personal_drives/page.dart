import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/widgets/google_drive_setup_tile.dart';
import 'package:flutter/material.dart';

class PersonalDrivesPage extends StatelessWidget {
  const PersonalDrivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Drives')),
      body: ListView(
        padding: const EdgeInsets.all(padding12),
        children: [
          Text(context.locale.settings__text__gdrive__info),
          height12,
          const GoogleDriveSetupTile(),
        ],
      ),
    );
  }
}
