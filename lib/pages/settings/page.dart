import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/sections/customization_settings.dart';
import 'package:clipboard/pages/settings/sections/experimental_settings.dart';
import 'package:clipboard/pages/settings/sections/general_settings.dart';
import 'package:clipboard/pages/settings/pages/android_bg_clipboard/android_bg_clipboard_settings.dart';
import 'package:clipboard/pages/settings/sections/security_settings.dart';
import 'package:clipboard/pages/settings/sections/syncing_settings.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/account_detail_button.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/logout_button.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:clipboard/widgets/subscription/active_plan_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class SettingsPage extends StatelessWidget {
  final int initialIndex;

  const SettingsPage({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dense = context.isMobile;
    final tabs = [
      Tab(
        icon: const Icon(Icons.settings_rounded),
        text: context.locale.settings__tab__1,
      ),
      Tab(
        icon: const Icon(Icons.color_lens_rounded),
        text: context.locale.settings__tab__2,
      ),
      Tab(
        icon: const Icon(Icons.wb_cloudy),
        text: context.locale.settings__tab__3,
      ),
      if (Platform.isAndroid)
        Tab(
          icon: const Icon(Icons.android_rounded),
          text: context.locale.abc_title,
        ),
      Tab(
        icon: const Icon(Icons.security_rounded),
        text: context.locale.settings__tab__4,
      ),
      Tab(
        icon: const Icon(Icons.science_rounded),
        text: context.locale.settings__tab__5,
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: CustomScaffold(
        activeIndex: 2,
        appBar: AppBar(
          backgroundColor: colors.surface,
          scrolledUnderElevation: 0,
          title: Text(context.locale.settings__appbar__title),
          actions: const [
            ActivePlanButton(),
            width12,
            DisableForLocalUser(child: AccountDetailButton()),
            width12,
            LogoutButton(),
            width12,
          ],
        ),
        body: ScaffoldBody(
          enabled: !dense,
          margin: const EdgeInsets.only(right: padding12),
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                onTap: (i) => context.go('/settings?tab=$i'),
                tabs: tabs,
              ),
              Expanded(
                child: ListTileTheme(
                  data: ListTileThemeData(
                    shape: dense
                        ? const RoundedRectangleBorder()
                        : const RoundedRectangleBorder(borderRadius: radius12),
                  ),
                  child: SizedBox(
                    width: 800,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const GeneralSettings(),
                        const CustomizationSettings(),
                        const SyncingSettings(),
                        if (Platform.isAndroid)
                          AndroidBgClipboardSettings(
                            bgService: sl(),
                            deviceId: sl(instanceName: "device_id"),
                          ),
                        const SecuritySettings(),
                        const ExperimentalSettings(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
