import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipSyncStatusFooter extends StatelessWidget {
  final ClipboardItem item;

  const ClipSyncStatusFooter({super.key, required this.item});

  void _sync(BuildContext context) {
    context.read<OfflinePersistenceCubit>().persist([
      item.copyWith(userIntent: true, failure: null),
    ]);
  }

  String _syncingLabel(AppLocalizations locale) {
    if (item.uploading && item.needsFileUpload) {
      final progress = item.uploadProgress;
      if (progress != null && progress > 0) {
        return '↑ ${(progress * 100) ~/ 1}%';
      }
      return locale.app__uploading;
    }
    return locale.app__syncing;
  }

  @override
  Widget build(BuildContext context) {
    final hasSyncState =
        item.isQueued ||
        item.isSyncing ||
        item.failure != null ||
        item.serverId == null;

    if (!hasSyncState || item.driveFileId != null) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;
    final locale = context.locale;

    final IconData icon;
    final Widget trailing;

    if (item.isSyncing) {
      icon = Icons.sync_rounded;
      trailing = _SyncingButton(isSyncing: true, label: _syncingLabel(locale));
    } else if (item.isQueued) {
      icon = Icons.schedule_rounded;
      trailing = Text(locale.app__queued);
    } else {
      icon = Icons.sync_problem_rounded;
      trailing = _SyncingButton(
        onPressed: () => _sync(context),
        isSyncing: false,
      );
    }

    return SizedBox(
      height: 35,
      child: DefaultTextStyle(
        style: context.textTheme.labelMedium!.copyWith(
          color: colors.onTertiaryContainer,
        ),
        child: ColoredBox(
          color: colors.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(padding8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: colors.onTertiaryContainer),
                width6,
                Expanded(
                  child: Text(
                    locale.app__local,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SyncingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isSyncing;
  final String? label;

  const _SyncingButton({this.onPressed, required this.isSyncing, this.label});

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      descendantsAreFocusable: false,
      descendantsAreTraversable: false,
      child: ElevatedButton(
        onPressed: isSyncing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: padding12,
            vertical: 0,
          ),
          minimumSize: const Size(0, 30),
        ),
        child: Text(
          label ??
              (isSyncing
                  ? context.locale.app__syncing
                  : context.locale.app__sync),
          style: context.textTheme.labelSmall,
        ),
      ),
    );
  }
}
