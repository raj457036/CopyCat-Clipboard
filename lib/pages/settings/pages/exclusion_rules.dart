import 'package:clipboard/pages/settings/widgets/exclusion_rules/exclude_custom_rules.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class ExclusionRulesPage extends StatelessWidget {
  const ExclusionRulesPage({super.key});

  Future<void> updateExclusionRules(
    BuildContext context,
    ExclusionRules rules,
  ) async {
    final cubit = context.read<AppConfigCubit>();
    final granted = await cubit.confirmAccessibilityPermission();
    if (!granted) return;
    cubit.updateExclusionRule(rules);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppConfigCubit, AppConfigState, ExclusionRules>(
      selector: (state) {
        return state.config.copyExclusionRules;
      },
      builder: (context, state) {
        final enable = state.enable;
        return CustomScaffold(
          activeIndex: 2,
          appBar: AppBar(
            // automaticallyImplyLeading: true,
            centerTitle: false,
            title: Text(context.locale.settings__appbar__er__title),
            actions: [
              Switch(
                value: state.enable,
                onChanged: (value) {
                  updateExclusionRules(
                    context,
                    state.copyWith(enable: value),
                  );
                },
              ),
              width16,
            ],
          ),
          body: ScaffoldBody(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: ListView(
                  children: [
                    ExcludeCustomRules(enabled: enable),
                    const Divider(),
                    height8,
                    SettingHeader(
                      name: context.locale.settings__text__er__predefine,
                    ),
                    SwitchListTile(
                      title: Text(
                        context.locale.settings__text__er__pass_manager,
                      ),
                      value: state.passwordManager,
                      onChanged: enable
                          ? (value) {
                              updateExclusionRules(
                                context,
                                state.copyWith(passwordManager: value),
                              );
                            }
                          : null,
                    ),
                    if (isDesktopPlatform)
                      SwitchListTile(
                        title: Text(context.locale.settings__text__er__cc),
                        value: state.creditCard,
                        onChanged: enable
                            ? (value) {
                                updateExclusionRules(
                                  context,
                                  state.copyWith(creditCard: value),
                                );
                              }
                            : null,
                      ),
                    SwitchListTile(
                      title: Text(context.locale.settings__text__er__phone),
                      value: state.phone,
                      onChanged: enable
                          ? (value) {
                              updateExclusionRules(
                                context,
                                state.copyWith(phone: value),
                              );
                            }
                          : null,
                    ),
                    SwitchListTile(
                      title: Text(context.locale.settings__text__er__email),
                      value: state.email,
                      onChanged: enable
                          ? (value) {
                              updateExclusionRules(
                                context,
                                state.copyWith(email: value),
                              );
                            }
                          : null,
                    ),
                    if (Platform.isMacOS)
                      SwitchListTile(
                        title: Text(context.locale.settings__text__er__url),
                        value: state.sensitiveUrls,
                        onChanged: enable
                            ? (value) {
                                updateExclusionRules(
                                  context,
                                  state.copyWith(sensitiveUrls: value),
                                );
                              }
                            : null,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
