import 'dart:async';

import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/custom_icons.dart';
import 'package:clipboard/common/file_log_sink.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/universal_io.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CopycatAboutTile extends StatefulWidget {
  const CopycatAboutTile({super.key});

  @override
  State<CopycatAboutTile> createState() => _CopycatAboutTileState();
}

class _CopycatAboutTileState extends State<CopycatAboutTile> {
  int _iconTapCount = 0;
  Timer? _resetTimer;

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  void _onIconTap() {
    _resetTimer?.cancel();
    _iconTapCount++;

    if (_iconTapCount >= 10) {
      _iconTapCount = 0;
      _openLogFile();
      return;
    }

    _resetTimer = Timer(const Duration(seconds: 3), () {
      _iconTapCount = 0;
    });
  }

  Future<void> _openLogFile() async {
    final file = await FileLogSink.getLogFile();
    if (file == null) return;

    // openfilex not working on windows
    if (Platform.isWindows) {
      await Process.run('notepad', [file.path]);
      return;
    }
    await OpenFilex.open(file.path);
  }

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
    final year = systemTime().year;
    final info = sl<PackageInfo>();
    final version = info.version;
    final build = info.buildNumber;
    return AboutListTile(
      icon: const Icon(Icons.new_releases_rounded),
      applicationName: context.locale.app__name,
      applicationIcon: GestureDetector(
        onTap: _onIconTap,
        child: const ClipRRect(
          borderRadius: radius16,
          child: Image(
            image: AssetImage(AssetConstants.copyCatIcon),
            width: 85,
          ),
        ),
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
