import 'package:clipboard/pages/settings/widgets/switches/tray_icon_switch.dart';
import 'package:clipboard/pages/settings/widgets/copycat_about_tile.dart';
import 'package:clipboard/pages/settings/widgets/download_desktop_client.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/dont_copy_over_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/switches/pause_till_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/startup_launch_switch.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/review_prompt_cubit/review_prompt_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/locale_dropdown.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  Future<void> _onRateTap(BuildContext context) async {
    final cubit = context.read<ReviewPromptCubit>();
    await cubit.requestReview();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final dense = context.isMobile;
    return ListView(
      padding: dense
          ? const EdgeInsets.symmetric(vertical: padding12)
          : const EdgeInsets.all(padding12),
      children: [
        const DownloadDesktopClientTile(),
        height16,
        const LocaleDropdownTile(),
        height10,
        if (!Platform.isIOS) const DontAutoCopyOverDropdown(),
        if (isDesktopPlatform) const PauseTillSwitch(),
        if (isDesktopPlatform) const StartUpLaunchSwitch(),
        if (isDesktopPlatform) const TrayIconSwitch(),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.backup_rounded),
          title: Text(locale.settings__tile__backup_restore__title),
          subtitle: Text(locale.settings__tile__backup_restore__subtitle),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => context.goNamed(RouteConstants.backupRestore),
        ),
        height10,
        BlocBuilder<AppConfigCubit, AppConfigState>(
          buildWhen: (prev, curr) =>
              prev.config.reviewNeverAsk != curr.config.reviewNeverAsk,
          builder: (context, state) {
            if (state.config.reviewNeverAsk) return const SizedBox.shrink();
            return ListTile(
              leading: const Icon(Icons.star_rounded),
              title: Text(locale.settings__tile__review__title),
              subtitle: Text(locale.settings__tile__review__subtitle),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => _onRateTap(context),
            );
          },
        ),
        height10,
        const CopycatAboutTile(),
      ],
    );
  }
}
