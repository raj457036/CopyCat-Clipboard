import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/app_lock_cubit/app_lock_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// MARK: - Widget

class LocalAuthSettingsTile extends StatefulWidget {
  const LocalAuthSettingsTile({super.key});

  @override
  State<LocalAuthSettingsTile> createState() => _LocalAuthSettingsTileState();
}

class _LocalAuthSettingsTileState extends State<LocalAuthSettingsTile> {
  bool _checking = false;

  Future<void> _onToggle(bool value, AppConfigCubit cubit) async {
    setState(() => _checking = true);
    final proceed = await sl<AppLockCubit>().prepareToggle(value);
    if (!mounted) return;
    setState(() => _checking = false);
    if (!proceed) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.locale.settings__app_lock__no_biometrics),
          ),
        );
      }
      return;
    }
    await cubit.toggleLocalAuth(value);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) => state.config.enableLocalAuth,
      builder: (context, enabled) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.fingerprint),
                title: Text(context.locale.settings__app_lock__title),
                subtitle: Text(
                  context.locale.settings__app_lock__tile__subtitle,
                  style: textTheme.bodyMedium?.copyWith(color: colors.outline),
                ),
                onTap: () => context.goNamed(RouteConstants.appLockSettings),
              ),
            ),
            const SizedBox(
              height: 55,
              child: VerticalDivider(width: 1, indent: 5, endIndent: 5),
            ),
            SizedBox(
              height: 55,
              child: InkWell(
                mouseCursor: SystemMouseCursors.click,
                onTap: _checking ? null : () => _onToggle(!enabled, cubit),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding10),
                  child: Switch(
                    value: enabled,
                    onChanged: _checking ? null : (v) => _onToggle(v, cubit),
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
