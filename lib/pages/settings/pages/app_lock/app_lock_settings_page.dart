import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/app_lock_cubit/app_lock_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// MARK: - Timeout options

const _timeoutMinutes = [0, 1, 5, 15, 30];

String _timeoutLabel(BuildContext context, int minutes) {
  if (minutes == 0) {
    return context.locale.settings__app_lock__timeout__immediately;
  }
  return context.locale.settings__app_lock__timeout__minutes(count: minutes);
}

// MARK: - Page

class AppLockSettingsPage extends StatefulWidget {
  const AppLockSettingsPage({super.key});

  @override
  State<AppLockSettingsPage> createState() => _AppLockSettingsPageState();
}

class _AppLockSettingsPageState extends State<AppLockSettingsPage> {
  bool _checking = false;

  Future<void> _onToggle(bool value) async {
    final cubit = context.read<AppConfigCubit>();
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
    return BlocSelector<
      AppConfigCubit,
      AppConfigState,
      ({bool enabled, int timeout})
    >(
      selector: (state) => (
        enabled: state.config.enableLocalAuth,
        timeout: state.config.localAuthTimeoutMinutes,
      ),
      builder: (context, data) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(context.locale.settings__app_lock__title),
            actions: [
              if (_checking)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Switch(value: data.enabled, onChanged: _onToggle),
              width16,
            ],
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 800,
              child: ListView(
                children: [
                  ListTile(
                    enabled: data.enabled,
                    title: Text(
                      context.locale.settings__app_lock__lock_after__title,
                    ),
                    subtitle: Text(
                      context.locale.settings__app_lock__lock_after__subtitle,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.outline,
                      ),
                    ),
                    trailing: SettingsMenuDropdown<int>(
                      value: data.timeout,
                      maxWidth: 190,
                      items: _timeoutMinutes
                          .map((m) => SettingsDropdownItem(value: m))
                          .toList(),
                      itemBuilder: (context, value) => (
                        leading: null,
                        child: Text(_timeoutLabel(context, value)),
                        trailing: null,
                      ),
                      onSelected: data.enabled
                          ? (v) => context
                                .read<AppConfigCubit>()
                                .setLocalAuthTimeout(v)
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
