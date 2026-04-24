import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipSyncStatusFooter extends StatelessWidget {
  final ClipboardItem item;

  const ClipSyncStatusFooter({super.key, required this.item});

  Future<void> _sync(BuildContext context) async {
    context.read<OfflinePersistenceCubit>().persist([
      item.copyWith(userIntent: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!item.hasUnsyncedChanges || item.driveFileId != null) {
      return const SizedBox.shrink();
    }
    final colors = context.colors;

    String buttonText;

    if (item.isSyncing) {
      if (item.uploading) {
        if (item.uploadProgress != null && item.uploadProgress! > 0) {
          final percent = ((item.uploadProgress ?? 0) * 100) ~/ 1;
          buttonText = '↑ $percent%';
        } else {
          buttonText = context.locale.app__uploading;
        }
      } else {
        buttonText = context.locale.app__syncing;
      }
    } else {
      buttonText = context.locale.app__sync;
    }

    return SizedBox.fromSize(
      size: const Size.fromHeight(35),
      child: ColoredBox(
        color: colors.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(padding8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.sync_problem_rounded, size: 18),
                  width6,
                  if (width > 200)
                    Text(
                      context.locale.app__local,
                      style: context.textTheme.labelMedium,
                    ),
                  const Spacer(),
                  Focus(
                    canRequestFocus: false,
                    skipTraversal: true,
                    descendantsAreFocusable: false,
                    descendantsAreTraversable: false,
                    child: ElevatedButton(
                      onPressed: item.isSyncing ? null : () => _sync(context),
                      child: Text(
                        buttonText,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontVariations: fontVarW700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
