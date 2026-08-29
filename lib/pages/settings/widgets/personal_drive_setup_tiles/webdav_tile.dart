import 'package:clipboard/base/bloc/webdav_setup_cubit/webdav_setup_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/widgets/personal_drive_setup_tiles/personal_drive_trailing.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WebDavSetupTile extends StatefulWidget {
  const WebDavSetupTile({super.key});

  @override
  State<WebDavSetupTile> createState() => _WebDavSetupTileState();
}

class _WebDavSetupTileState extends State<WebDavSetupTile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WebDavSetupCubit>().fetch();
      }
    });
  }

  void _onConfigure(BuildContext context) {
    context.goNamed(RouteConstants.webdavSetup);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return BlocBuilder<WebDavSetupCubit, WebDavSetupState>(
      builder: (context, state) {
        bool isConfigured = false;
        bool isLoading = false;
        String subtitle = context.locale.settings__drive__disconnected;

        switch (state) {
          case WebDavSetupInitial() || WebDavSetupLoading():
            subtitle = context.locale.settings__drive__loading;
            isLoading = true;
          case WebDavSetupConfigured(:final config):
            if (config.password.isNotEmpty) {
              final host =
                  Uri.tryParse(config.serverUrl)?.host ?? config.serverUrl;
              subtitle =
                  '${context.locale.settings__drive__connected} - ${config.username}@$host';
              isConfigured = true;
            } else {
              subtitle = context.locale.settings__drive__disconnected;
              isConfigured = false;
            }
          case WebDavSetupDisconnected():
            subtitle = context.locale.settings__drive__disconnected;
          case WebDavSetupError(:final failure):
            subtitle = failure.message;
        }

        return ListTile(
          leading: Icon(Icons.dns_rounded, size: 24, color: colors.primary),
          title: Text(
            context.locale.settings__text__webdav__name,
            style: textTheme.titleMedium?.copyWith(fontVariations: fontVarW700),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PersonalDriveTrailing(
            isLoading: isLoading,
            isConnected: isConfigured,
            provider: ActiveCloudStorageProvider.webdav,
          ),
          onTap: isLoading ? null : () => _onConfigure(context),
        );
      },
    );
  }
}
