import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/file_sizes.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DontAutoCopyOverDropdown extends StatelessWidget {
  const DontAutoCopyOverDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobilePlatform) return const SizedBox.shrink();
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<AppConfigCubit, AppConfigState, int>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.dontCopyOver.isNegative ? $10MB : config.dontCopyOver;
          default:
            return $10MB;
        }
      },
      builder: (context, state) {
        return ListTile(
          title: Text(
            context.locale.settings__dropdown__no_copy_over_limit__title,
          ),
          subtitle: Text(
            context.locale.settings__dropdown__no_copy_over_limit__subtitle(
              fileSize: formatBytes(
                state,
                precise: false,
              ),
            ),
            style: textTheme.bodyMedium?.copyWith(
              color: colors.outline,
            ),
          ),
          trailing: DropdownButtonHideUnderline(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: DropdownButton<int>(
                value: state,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: padding16),
                borderRadius: radius26,
                items: [
                  DropdownMenuItem(
                    value: $5MB,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox.square(
                          dimension: 24,
                          child: Icon(
                            Icons.circle,
                            size: 5,
                          ),
                        ),
                        width12,
                        Text(context.locale.settings__text__5MB),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: $10MB,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox.square(
                          dimension: 24,
                          child: Icon(
                            Icons.circle,
                            size: 10,
                          ),
                        ),
                        width12,
                        Text(context.locale.settings__text__10MB),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: $20MB,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox.square(
                          dimension: 24,
                          child: Icon(
                            Icons.circle,
                            size: 15,
                          ),
                        ),
                        width12,
                        Text(context.locale.settings__text__20MB),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: $50MB,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox.square(
                          dimension: 24,
                          child: Icon(
                            Icons.circle,
                            size: 20,
                          ),
                        ),
                        width12,
                        Text(context.locale.settings__text__50MB),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: $100MB,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, size: 24),
                        width12,
                        Text(context.locale.settings__text__100MB),
                      ],
                    ),
                  ),
                ],
                onChanged: cubit.changeDontCopyOver,
              ),
            ),
          ),
        );
      },
    );
  }
}
