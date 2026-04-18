import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/repositories/restoration_status.dart';
import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncRestoreStep extends StatefulWidget {
  final VoidCallback onContinue;
  final ClipboardRepository clipboardRepository;
  final ClipCollectionRepository collectionRepository;
  final RestorationStatusRepository restorationStatusRepository;

  const SyncRestoreStep({
    super.key,
    required this.onContinue,
    required this.clipboardRepository,
    required this.collectionRepository,
    required this.restorationStatusRepository,
  });

  @override
  State<SyncRestoreStep> createState() => _SyncRestoreStepState();
}

class _SyncRestoreStepState extends State<SyncRestoreStep> {
  bool fetchingCounts = false;
  late final SyncStatusCubit syncCubit;
  SyncStatus? syncStatus;
  Map<String, SyncProgress> _lastProgress = const {};

  @override
  void initState() {
    super.initState();
    syncCubit = context.read<SyncStatusCubit>();
    startRestoration();
  }

  Future<void> startRestoration() async {
    if (!mounted) return;
    setState(() => fetchingCounts = true);

    try {
      final statRes = await widget.restorationStatusRepository.getStatus();
      statRes.fold((l) => null, (r) => syncStatus = r);
      final lastSync =
          syncStatus?.lastSyncPoint ?? DateTime.fromMillisecondsSinceEpoch(0);

      final results = await Future.wait([
        widget.collectionRepository.getCount(local: false),
        widget.clipboardRepository.getClipCounts(lastSync),
      ]);

      int colTotal = 0, clipTotal = 0;
      results[0].fold((l) => showFailureSnackbar(l), (r) => colTotal = r);
      results[1].fold((l) => showFailureSnackbar(l), (r) => clipTotal = r);

      final progress = {'collection': colTotal, 'clip': clipTotal};
      _lastProgress = progress.map(
        (key, value) => MapEntry(key, SyncProgress(synced: 0, total: value)),
      );
      syncCubit.initializeProgress(SyncProgressInitParams(progress));
      await wait(800);
      syncCubit.syncAll(const SyncAllParams(force: true));
    } finally {
      if (mounted) setState(() => fetchingCounts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(padding20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _RestoreGlyph(),
            height20,
            FadeIn(
              child: Text(
                context.locale.sync_restore__title,
                textAlign: TextAlign.center,
                style: text.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            height8,
            Text(
              context.locale.sync_restore__subtitle,
              textAlign: TextAlign.center,
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            height24,
            if (fetchingCounts)
              _Preparing(colors: colors, text: text)
            else
              BlocConsumer<SyncStatusCubit, SyncStatusState>(
                listener: (context, state) {
                  if (state case SyncingStatus(:final progress)) {
                    _lastProgress = progress;
                  }
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    syncing: (progress) => _RestorePanel(
                      progress: progress,
                      colors: colors,
                      text: text,
                    ),
                    complete: () => _RestorePanel(
                      progress: _lastProgress,
                      colors: colors,
                      text: text,
                      complete: true,
                      onContinue: widget.onContinue,
                    ),
                    failed: (failure) => _RestoreFailure(
                      message: failure.message,
                      onRetry: startRestoration,
                      colors: colors,
                      text: text,
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _RestoreGlyph extends StatelessWidget {
  const _RestoreGlyph();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.square(
          dimension: 76,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primaryContainer.withValues(alpha: 0.38),
            ),
          ),
        ),
        SizedBox.square(
          dimension: 48,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius16,
              color: colors.surfaceContainerHigh,
              border: Border.all(color: colors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.content_paste_go_rounded,
              color: colors.primary,
              size: 24,
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: SizedBox.square(
            dimension: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.secondaryContainer,
                border: Border.all(color: colors.surface, width: 2),
              ),
              child: Icon(
                Icons.check_rounded,
                color: colors.onSecondaryContainer,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Preparing extends StatelessWidget {
  final ColorScheme colors;
  final TextTheme text;

  const _Preparing({required this.colors, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(padding20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: radius16,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          width16,
          Expanded(
            child: Text(
              context.locale.sync_restore__checking_backup,
              style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestorePanel extends StatelessWidget {
  final Map<String, SyncProgress> progress;
  final ColorScheme colors;
  final TextTheme text;
  final bool complete;
  final VoidCallback? onContinue;

  const _RestorePanel({
    required this.progress,
    required this.colors,
    required this.text,
    this.complete = false,
    this.onContinue,
  });

  int get restoredCount =>
      progress.values.fold(0, (count, item) => count + item.synced);

  int get expectedCount =>
      progress.values.fold(0, (count, item) => count + item.total);

  double? get totalProgress {
    if (expectedCount <= 0) return null;
    return (restoredCount / expectedCount).clamp(0.0, 1.0);
  }

  String restoredLabel(AppLocalizations locale) {
    if (complete && expectedCount == 0 && restoredCount == 0) {
      return locale.sync_restore__no_synced_items;
    }
    if (complete) {
      return locale.sync_restore__restored_count(count: restoredCount);
    }
    if (expectedCount > 0 && restoredCount <= expectedCount) {
      return locale.sync_restore__restored_of_total(
        synced: restoredCount,
        total: expectedCount,
      );
    }
    return locale.sync_restore__restored_count(count: restoredCount);
  }

  String stageLabel(
    AppLocalizations locale,
    SyncProgress collectionProgress,
    SyncProgress clipProgress,
  ) {
    if (complete) return locale.sync_restore__data_ready;
    if (!collectionProgress.isComplete) {
      return locale.sync_restore__restoring_collections;
    }
    if (!clipProgress.isComplete) {
      return locale.sync_restore__restoring_clips;
    }
    return locale.sync_restore__finishing_checks;
  }

  String progressLabel(AppLocalizations locale) {
    if (complete) return locale.sync_restore__progress_complete;
    if (expectedCount <= 0) return locale.sync_restore__progress_estimating;
    return "${((totalProgress ?? 0) * 100).round()}%";
  }

  @override
  Widget build(BuildContext context) {
    final collectionProgress =
        progress['collection'] ?? const SyncProgress(synced: 0, total: 0);
    final clipProgress =
        progress['clip'] ?? const SyncProgress(synced: 0, total: 0);
    final locale = context.locale;

    return FadeIn(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(padding28),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: radius16,
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complete
                                ? locale.sync_restore__workspace_restored
                                : restoredLabel(locale),
                            style: text.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          height4,
                          Text(
                            stageLabel(
                              locale,
                              collectionProgress,
                              clipProgress,
                            ),
                            style: text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    width16,
                    _StatusPill(
                      complete: complete,
                      colors: colors,
                      text: text,
                      locale: locale,
                    ),
                  ],
                ),
                height24,
                LinearProgressIndicator(
                  value: complete ? 1 : totalProgress,
                  minHeight: 6,
                  borderRadius: radius8,
                  backgroundColor: colors.surfaceContainerHighest,
                ),
                height10,
                Row(
                  children: [
                    Text(
                      progressLabel(locale),
                      style: text.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      restoredLabel(locale),
                      style: text.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                height20,
                _RestoreRow(
                  title: locale.sync_restore__collections_title,
                  description: locale.sync_restore__collections_description,
                  progress: collectionProgress,
                  complete: complete,
                  colors: colors,
                  text: text,
                  locale: locale,
                ),
                height16,
                _RestoreRow(
                  title: locale.sync_restore__clipboard_items_title,
                  description: locale.sync_restore__clipboard_items_description,
                  progress: clipProgress,
                  complete: complete,
                  colors: colors,
                  text: text,
                  locale: locale,
                ),
              ],
            ),
          ),
          if (complete) ...[
            height20,
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.check_rounded),
                label: Text(locale.sync_restore__continue_to_copycat),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool complete;
  final ColorScheme colors;
  final TextTheme text;
  final AppLocalizations locale;

  const _StatusPill({
    required this.complete,
    required this.colors,
    required this.text,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final bg = complete ? colors.primaryContainer : colors.secondaryContainer;
    final fg = complete
        ? colors.onPrimaryContainer
        : colors.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: padding10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: radius8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (complete)
            Icon(Icons.done_rounded, size: 16, color: fg)
          else
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: fg),
            ),
          width6,
          Text(
            complete
                ? locale.sync_restore__status_ready
                : locale.sync_restore__status_restoring,
            style: text.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RestoreRow extends StatelessWidget {
  final String title;
  final String description;
  final SyncProgress progress;
  final bool complete;
  final ColorScheme colors;
  final TextTheme text;
  final AppLocalizations locale;

  const _RestoreRow({
    required this.title,
    required this.description,
    required this.progress,
    required this.complete,
    required this.colors,
    required this.text,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = complete || progress.isComplete;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: padding12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.7)),
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Durations.short3,
            width: 9,
            height: 40,
            decoration: BoxDecoration(
              color: isDone ? colors.primary : colors.outlineVariant,
              borderRadius: radius8,
            ),
          ),
          width14,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                height2,
                Text(
                  description,
                  style: text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          width12,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${progress.visibleSynced}",
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              Text(
                progress.total > 0
                    ? locale.sync_restore__count_of_total(total: progress.total)
                    : locale.sync_restore__restored_count(
                        count: progress.visibleSynced,
                      ),
                style: text.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RestoreFailure extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final ColorScheme colors;
  final TextTheme text;

  const _RestoreFailure({
    required this.message,
    required this.onRetry,
    required this.colors,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(padding20),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: radius16,
        border: Border.all(color: colors.error.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(Icons.sync_problem_rounded, color: colors.onErrorContainer),
          height12,
          Text(
            context.locale.sync_restore__failed_title,
            style: text.titleMedium?.copyWith(
              color: colors.onErrorContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
          height6,
          Text(
            message,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: colors.onErrorContainer),
          ),
          height16,
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.locale.app__try_again),
          ),
        ],
      ),
    );
  }
}
