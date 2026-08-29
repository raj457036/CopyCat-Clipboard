import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/widgets/personal_drive_setup_tiles/google_drive_tile.dart';
import 'package:clipboard/pages/settings/widgets/personal_drive_setup_tiles/webdav_tile.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class PersonalDrivesPage extends StatelessWidget {
  const PersonalDrivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Personal Drives'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 800,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: padding16,
              vertical: padding12,
            ),
            children: [
              Text(
                context.locale.settings__text__gdrive__info,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.outline,
                ),
              ),
              height16,
              const GoogleDriveSetupTile(),
              const WebDavSetupTile(),
            ],
          ),
        ),
      ),
    );
  }
}
