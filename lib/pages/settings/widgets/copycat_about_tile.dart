import 'package:clipboard/di/di.dart';
import 'package:copycat_base/common/custom_icons.dart';
import 'package:copycat_base/constants/strings/asset_constants.dart';
import 'package:copycat_base/constants/strings/strings.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CopycatAboutTile extends StatelessWidget {
  const CopycatAboutTile({super.key});

  Future<void> openWebsite() async {
    await launchUrlString(websiteUrl);
  }

  Future<void> openGithubRepo() async {
    await launchUrlString(githubUrl);
  }

  Future<void> openTutorialPage() async {
    await launchUrlString(tutorialsUrl);
  }

  Future<void> openYoutubeTutorials() async {
    await launchUrlString(youtubePlaylistUrl);
  }

  Future<void> openSupport() async {
    await launchUrlString(supportUrl);
  }

  Future<void> openDiscord() async {
    await launchUrlString(discordUrl);
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final info = sl<PackageInfo>();
    final version = info.version;
    final build = info.buildNumber;
    return AboutListTile(
      icon: const Icon(Icons.new_releases_rounded),
      applicationName: context.locale.app__name,
      applicationIcon: const Image(
        image: AssetImage(AssetConstants.copyCatIcon),
        width: 60,
      ),
      applicationVersion: "$version+$build",
      aboutBoxChildren: [
        height16,
        ListTile(
          leading: const Icon(Icons.discord_rounded, color: Color(0xFF5865F2)),
          title: Text(context.locale.about__tile__discord),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: openDiscord,
          shape: const RoundedRectangleBorder(borderRadius: radius12),
        ),
        ListTile(
          leading: const Icon(CustomIcons.youtube, color: Color(0xFFCD201F)),
          title: Text(context.locale.about__tile__youtube),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: openYoutubeTutorials,
          shape: const RoundedRectangleBorder(borderRadius: radius12),
        ),
        ListTile(
          leading: const Icon(Icons.book_rounded),
          title: Text(context.locale.about__tile__read_tut),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: openTutorialPage,
          shape: const RoundedRectangleBorder(borderRadius: radius12),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(CustomIcons.github),
          title: Text(context.locale.about__tile__github),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: openGithubRepo,
          shape: const RoundedRectangleBorder(borderRadius: radius12),
        ),
        ListTile(
          leading: const Icon(Icons.public_rounded),
          title: Text(context.locale.about__tile__website),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: openWebsite,
          shape: const RoundedRectangleBorder(borderRadius: radius12),
        ),
        ListTile(
          leading: const Icon(Icons.contact_support_rounded),
          title: Text(context.locale.about__tile__support),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: openSupport,
          shape: const RoundedRectangleBorder(borderRadius: radius12),
        ),
      ],
      applicationLegalese: "Copyright (c) $year Entility Studio",
    );
  }
}
