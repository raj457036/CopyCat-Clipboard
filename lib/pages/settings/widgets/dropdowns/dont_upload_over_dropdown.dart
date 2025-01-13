import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/constants/numbers/file_sizes.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DontAutoUploadOverDropdown extends StatelessWidget {
  const DontAutoUploadOverDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<AppConfigCubit, AppConfigState, int>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.dontUploadOver;
          default:
            return $10MB;
        }
      },
      builder: (context, state) {
        return ListTile(
          title: Text(
              context.locale.settings__dropdown__no_upload_over_limit__title),
          subtitle: Text(
            context.locale.settings__dropdown__no_upload_over_limit__subtitle(
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
              constraints: const BoxConstraints(maxWidth: 120),
              child: DropdownButton<int>(
                value: state,
                isExpanded: true,
                alignment: Alignment.centerRight,
                enableFeedback: true,
                padding: const EdgeInsets.symmetric(horizontal: padding16),
                borderRadius: radius26,
                items: [
                  DropdownMenuItem(
                    value: $5MB,
                    child: Text(context.locale.settings__text__5MB),
                  ),
                  DropdownMenuItem(
                    value: $10MB,
                    child: Text(context.locale.settings__text__10MB),
                  ),
                  DropdownMenuItem(
                    value: $20MB,
                    child: Text(context.locale.settings__text__20MB),
                  ),
                  DropdownMenuItem(
                    value: $50MB,
                    child: Text(context.locale.settings__text__50MB),
                  ),
                  DropdownMenuItem(
                    value: $100MB,
                    child: Text(context.locale.settings__text__100MB),
                  ),
                ],
                onChanged: cubit.changeDontUploadOver,
              ),
            ),
          ),
        );
      },
    );
  }
}
