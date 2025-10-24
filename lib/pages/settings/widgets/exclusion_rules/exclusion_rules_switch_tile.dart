import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class ExclusionRulesSwitchTile extends StatelessWidget {
  const ExclusionRulesSwitchTile({super.key});

  Future<void> onChanged(BuildContext context, bool value) async {
    final cubit = context.read<AppConfigCubit>();
    final granted = await cubit.confirmAccessibilityPermission();
    if (!granted) return;
    final config = cubit.exclusionRules.copyWith(enable: value);
    cubit.updateExclusionRule(config);
  }

  Future<void> openDetail(BuildContext context) async {
    context.goNamed(RouteConstants.exclusionRules);
  }

  @override
  Widget build(BuildContext context) {
    final isSupported = isDesktopPlatform || Platform.isAndroid;
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.copyExclusionRules.enable;
          default:
            return false;
        }
      },
      builder: (context, enabled) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListTile(
                title: Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.locale.settings__tile__er_title),
                    if (Platform.isAndroid) const Icon(Icons.science_rounded),
                  ],
                ),
                subtitle: isSupported
                    ? Text(context.locale.settings__tile__er_subtitle)
                    : Text(context.locale.app__feature_unavailable),
                subtitleTextStyle: textTheme.bodyMedium?.copyWith(
                  color: colors.outline,
                ),
                onTap: () => openDetail(context),
                enabled: isSupported,
              ),
            ),
            const SizedBox(
              height: 55,
              child: VerticalDivider(
                width: 1,
                indent: 5,
                endIndent: 5,
              ),
            ),
            SizedBox(
              height: 55,
              child: InkWell(
                onTap: () => onChanged(context, !enabled),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding10),
                  child: Switch(
                    value: enabled,
                    onChanged: isSupported
                        ? (value) => onChanged(context, value)
                        : null,
                  ),
                ),
              ),
            ),
            width14,
          ],
        );
      },
    );
  }
}
