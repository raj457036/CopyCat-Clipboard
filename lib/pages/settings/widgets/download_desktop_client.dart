import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DownloadDesktopClientTile extends StatelessWidget {
  const DownloadDesktopClientTile({super.key});

  Future<void> openDownloadPage() async {
    if (await canLaunchUrlString(downloadUrl)) {
      launchUrlString(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    String title = context.locale.settings__tile__desk_client__title;
    IconData icon = Icons.desktop_mac_rounded;

    if (isDesktopPlatform) {
      title = context.locale.settings__tile__mobile_client__title;
      icon = Icons.phone_android_sharp;
    }

    return ListTile(
      title: Text(title),
      subtitle: Text(context.locale.settings__tile__client__subtitle),
      leading: Icon(icon),
      trailing: const Icon(Icons.open_in_new),
      tileColor: colors.primary,
      textColor: colors.onPrimary,
      iconColor: colors.onPrimary,
      onTap: openDownloadPage,
    );
  }
}
