import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/encryption.dart';
import 'package:clipboard/base/data/services/manual_backup_restore_service.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  late final ManualBackupRestoreService _service;
  late final ClipboardCubit _clipboardCubit;

  bool _busy = false;
  String _busyLabel = '';

  BackupSummary? _backupSummary;
  RestoreSummary? _restoreSummary;

  @override
  void initState() {
    super.initState();
    _clipboardCubit = context.read<ClipboardCubit>();
    _service = ManualBackupRestoreService(
      sl<ClipboardSource>(instanceName: 'local'),
      sl<ClipCollectionSource>(instanceName: 'local'),
    );
  }

  Future<void> _createBackup() async {
    final config = await _showBackupOptionsDialog();
    if (!mounted || config == null) return;

    final savePath = await FilePicker.saveFile(
      dialogTitle: context.locale.backup_restore__dialog__save_as,
      fileName:
          'copycat_backup_${DateTime.now().millisecondsSinceEpoch}.ccbkup',
      type: FileType.custom,
      allowedExtensions: const ['ccbkup'],
    );

    if (!mounted || savePath == null) return;

    setState(() {
      _busy = true;
      _busyLabel = context.locale.backup_restore__busy__creating;
    });

    try {
      final appConfig = context.read<AppConfigCubit>();
      if (appConfig.isEncryptionEnabled &&
          !EncryptionWorker.instance.isEncryptionActive) {
        throw Exception(
          context.locale.backup_restore__error__encryption_unavailable,
        );
      }

      final shouldEncrypt = appConfig.isEncryptionEnabled;

      final result = await _service.createBackup(
        outputPath: savePath,
        password: config.password,
        includeCachedFiles: config.includeCachedFiles,
        encryptClipsInBackup: shouldEncrypt,
        clipTypes: config.clipTypes,
        fromDate: config.fromDate,
        toDate: config.toDate,
        maxFileSizeBytes: config.maxFileSizeBytes,
      );

      if (!mounted) return;
      setState(() {
        _backupSummary = result;
      });
      // showTextSnackbar(
      //   context.locale.backup_restore__snackbar__saved(
      //     outputPath: result.outputPath,
      //   ),
      //   success: true,
      // );
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "backup_created",
          body: context.locale.backup_restore__snackbar__saved(
            outputPath: result.outputPath,
          ),
          type: .success,
        ),
      );
    } catch (e) {
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "backup_create_failed",
          body: context.locale.backup_restore__snackbar__create_failed(
            message: '$e',
          ),
          type: .error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _busyLabel = '';
        });
      }
    }
  }

  Future<void> _restoreBackup() async {
    final selected = await FilePicker.pickFiles(
      dialogTitle: context.locale.backup_restore__dialog__select_file,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const ['ccbkup'],
    );

    if (!mounted || selected == null || selected.files.single.path == null) {
      return;
    }

    final password = await _showPasswordDialog(
      title: context.locale.backup_restore__dialog__restore_title,
      subtitle: context.locale.backup_restore__dialog__restore_subtitle,
      actionLabel: context.locale.backup_restore__dialog__restore_action,
    );

    if (!mounted || password == null) return;

    setState(() {
      _busy = true;
      _busyLabel = context.locale.backup_restore__busy__restoring;
    });

    try {
      final summary = await _service.restoreBackup(
        backupPath: selected.files.single.path!,
        password: password,
      );

      if (!mounted) return;
      setState(() {
        _restoreSummary = summary;
      });

      _clipboardCubit.refresh();

      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "backup_restore_completed",
          body: context.locale.backup_restore__snackbar__restore_completed(
            clips: summary.clipsRestored,
            collections: summary.collectionsRestored,
          ),
          type: .success,
        ),
      );
    } catch (e) {
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "backup_restore_failed",
          body: context.locale.backup_restore__snackbar__restore_failed(
            message: '$e',
          ),
          type: .error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _busyLabel = '';
        });
      }
    }
  }

  Future<_BackupOptions?> _showBackupOptionsDialog() {
    final locale = context.locale;
    final formKey = GlobalKey<FormState>();
    final scrollController = ScrollController();
    final passwordController = TextEditingController();
    final maxSizeController = TextEditingController();
    var protectWithPassword = false;
    DateTime? fromDate;
    DateTime? toDate;
    final selectedClipTypes = <ClipItemType>{
      ClipItemType.text,
      ClipItemType.url,
      ClipItemType.file,
      ClipItemType.media,
    };

    void onContinue(BuildContext context) {
      if (!formKey.currentState!.validate()) return;
      if (selectedClipTypes.isEmpty) {
        InAppNotificationService.i.notify(
          NotificationMessage(
            id: "backup_options_error",
            body: locale.backup_restore__error__select_clip_type,
            type: .error,
          ),
        );
        return;
      }
      if (fromDate != null && toDate != null && fromDate!.isAfter(toDate!)) {
        InAppNotificationService.i.notify(
          NotificationMessage(
            id: "backup_options_error",
            body: locale.backup_restore__error__from_after_to,
            type: .error,
          ),
        );
        return;
      }

      final maxSizeMb = int.tryParse(maxSizeController.text.trim());
      context.pop(
        _BackupOptions(
          clipTypes: selectedClipTypes,
          fromDate: fromDate,
          toDate: toDate,
          maxFileSizeBytes: (maxSizeMb != null && maxSizeMb > 0)
              ? maxSizeMb * 1024 * 1024
              : null,
          password: protectWithPassword ? passwordController.text.trim() : null,
        ),
      );
    }

    Future<void> pickDate({
      required bool isFrom,
      required StateSetter setModalState,
    }) async {
      final initial = isFrom
          ? (fromDate ?? DateTime.now().subtract(const Duration(days: 30)))
          : (toDate ?? DateTime.now());

      final picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2015),
        lastDate: DateTime.now().add(const Duration(days: 1)),
      );
      if (picked == null) return;

      setModalState(() {
        if (isFrom) {
          fromDate = DateTime(picked.year, picked.month, picked.day);
        } else {
          toDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            23,
            59,
            59,
            999,
          );
        }
      });
    }

    Widget buildFormBody(StateSetter setModalState, BuildContext context) {
      return Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.backup_restore__dialog__options__description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                height12,
                _DialogSectionTitle(locale.backup_restore__section__clip_types),
                Wrap(
                  spacing: padding8,
                  runSpacing: padding8,
                  children: [
                    _TypeChip(
                      type: ClipItemType.text,
                      selected: selectedClipTypes.contains(ClipItemType.text),
                      onSelected: (value) {
                        setModalState(() {
                          _toggleType(
                            selectedClipTypes,
                            ClipItemType.text,
                            value,
                          );
                        });
                      },
                    ),
                    _TypeChip(
                      type: ClipItemType.url,
                      selected: selectedClipTypes.contains(ClipItemType.url),
                      onSelected: (value) {
                        setModalState(() {
                          _toggleType(
                            selectedClipTypes,
                            ClipItemType.url,
                            value,
                          );
                        });
                      },
                    ),
                    _TypeChip(
                      type: ClipItemType.file,
                      selected: selectedClipTypes.contains(ClipItemType.file),
                      onSelected: (value) {
                        setModalState(() {
                          _toggleType(
                            selectedClipTypes,
                            ClipItemType.file,
                            value,
                          );
                        });
                      },
                    ),
                    _TypeChip(
                      type: ClipItemType.media,
                      selected: selectedClipTypes.contains(ClipItemType.media),
                      onSelected: (value) {
                        setModalState(() {
                          _toggleType(
                            selectedClipTypes,
                            ClipItemType.media,
                            value,
                          );
                        });
                      },
                    ),
                  ],
                ),
                height12,
                _DialogSectionTitle(
                  locale.backup_restore__section__cached_files,
                ),
                if (_hasCacheableClipTypes(selectedClipTypes))
                  TextFormField(
                    controller: maxSizeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText:
                          locale.backup_restore__input__max_cached_file_size,
                      hintText: locale
                          .backup_restore__input__max_cached_file_size__hint,
                    ),
                    validator: (value) {
                      if (!_hasCacheableClipTypes(selectedClipTypes)) {
                        return null;
                      }
                      final txt = value?.trim() ?? '';
                      if (txt.isEmpty) return null;
                      final parsed = int.tryParse(txt);
                      if (parsed == null || parsed <= 0) {
                        return locale.backup_restore__error__positive_number;
                      }
                      return null;
                    },
                  ),
                if (!_hasCacheableClipTypes(selectedClipTypes))
                  Text(
                    locale
                        .backup_restore__text__select_file_media_for_cache_limit,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                height12,
                _DialogSectionTitle(locale.backup_restore__section__date_range),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(locale.backup_restore__from_date),
                  subtitle: Text(
                    fromDate == null
                        ? locale.backup_restore__no_minimum_date
                        : fromDate!.toLocal().toString().split(' ').first,
                  ),
                  onTap: () =>
                      pickDate(isFrom: true, setModalState: setModalState),
                  trailing: IconButton(
                    onPressed: () =>
                        pickDate(isFrom: true, setModalState: setModalState),
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(locale.backup_restore__to_date),
                  subtitle: Text(
                    toDate == null
                        ? locale.backup_restore__no_maximum_date
                        : toDate!.toLocal().toString().split(' ').first,
                  ),
                  onTap: () =>
                      pickDate(isFrom: false, setModalState: setModalState),
                  trailing: IconButton(
                    onPressed: () =>
                        pickDate(isFrom: false, setModalState: setModalState),
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
                if (fromDate != null || toDate != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        setModalState(() {
                          fromDate = null;
                          toDate = null;
                        });
                      },
                      child: Text(locale.backup_restore__clear_date_filter),
                    ),
                  ),
                height12,
                _DialogSectionTitle(locale.backup_restore__section__security),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(locale.backup_restore__toggle__password_protect),
                  value: protectWithPassword,
                  onChanged: (value) {
                    setModalState(() {
                      protectWithPassword = value;
                      if (!protectWithPassword) {
                        passwordController.clear();
                      }
                    });
                  },
                ),
                if (protectWithPassword)
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: locale.backup_restore__input__password,
                      hintText: locale.backup_restore__input__password__hint,
                    ),
                    validator: (value) {
                      if (!protectWithPassword) return null;
                      if (value == null || value.trim().length < 6) {
                        return locale
                            .backup_restore__error__password_min_length;
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final isSmallScreen = MediaQuery.of(context).size.width < 700;

    if (isSmallScreen) {
      return showModalBottomSheet<_BackupOptions>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.88,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: padding16,
                    right: padding16,
                    top: padding8,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom + padding16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.backup_restore__dialog__create_manual_title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      height12,
                      Expanded(child: buildFormBody(setModalState, context)),
                      height12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(null),
                            child: Text(
                              context.mlocale.cancelButtonLabel.title,
                            ),
                          ),
                          width8,
                          FilledButton(
                            onPressed: () => onContinue(context),
                            child: Text(
                              context.mlocale.continueButtonLabel.title,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return showDialog<_BackupOptions>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(locale.backup_restore__dialog__create_manual_title),
              content: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 520,
                  maxWidth: 720,
                  maxHeight: 640,
                ),
                child: buildFormBody(setModalState, context),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(context.mlocale.cancelButtonLabel.title),
                ),
                ElevatedButton(
                  onPressed: () => onContinue(context),
                  child: Text(context.mlocale.continueButtonLabel.title),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showPasswordDialog({
    required String title,
    required String subtitle,
    required String actionLabel,
  }) {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(labelText: subtitle),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(context.mlocale.cancelButtonLabel.title),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: Text(actionLabel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final locale = context.locale;

    final backupStats = _backupSummary == null
        ? const <_StatItem>[]
        : [
            _StatItem(
              locale.backup_restore__label__collections,
              '${_backupSummary!.collectionsTotal}',
            ),
            _StatItem(
              locale.backup_restore__label__clips,
              '${_backupSummary!.clipsTotal}',
            ),
            _StatItem(
              locale.backup_restore__label__files_included,
              '${_backupSummary!.cachedFilesIncluded}',
            ),
            _StatItem(
              locale.backup_restore__label__files_missing,
              '${_backupSummary!.cachedFilesMissing}',
            ),
            _StatItem(
              locale.backup_restore__label__files_skipped_by_size,
              '${_backupSummary!.cachedFilesSkippedBySize}',
            ),
            _StatItem(
              locale.backup_restore__label__encrypted_clips,
              '${_backupSummary!.encryptedClipsInBackup}',
            ),
          ];

    final restoreStats = _restoreSummary == null
        ? const <_StatItem>[]
        : [
            _StatItem(
              locale.backup_restore__label__collections_restored,
              '${_restoreSummary!.collectionsRestored}',
            ),
            _StatItem(
              locale.backup_restore__label__collections_duplicates,
              '${_restoreSummary!.collectionsDuplicate}',
            ),
            _StatItem(
              locale.backup_restore__label__collections_failed,
              '${_restoreSummary!.collectionsFailed}',
            ),
            _StatItem(
              locale.backup_restore__label__clips_restored,
              '${_restoreSummary!.clipsRestored}',
            ),
            _StatItem(
              locale.backup_restore__label__clips_duplicates,
              '${_restoreSummary!.clipsDuplicate}',
            ),
            _StatItem(
              locale.backup_restore__label__clips_failed,
              '${_restoreSummary!.clipsFailed}',
            ),
            _StatItem(
              locale.backup_restore__label__attachments_restored,
              '${_restoreSummary!.attachmentsRestored}',
            ),
            _StatItem(
              locale.backup_restore__label__attachments_missing,
              '${_restoreSummary!.attachmentsMissing}',
            ),
            _StatItem(
              locale.backup_restore__label__attachments_failed,
              '${_restoreSummary!.attachmentsFailed}',
            ),
            _StatItem(
              locale.backup_restore__label__corrupt_entries,
              '${_restoreSummary!.corruptEntries}',
            ),
          ];

    return Scaffold(
      appBar: AppBar(title: Text(locale.backup_restore__appbar__title)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: ListView(
            padding: const EdgeInsets.all(padding16),
            children: [
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(padding16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.backup_restore__card__title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      height8,
                      Text(
                        locale.backup_restore__card__subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height16,
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(padding16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.backup_restore__actions__title,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      height12,
                      Wrap(
                        spacing: padding12,
                        runSpacing: padding12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _busy ? null : _createBackup,
                            icon: const Icon(Icons.archive_rounded),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primary,
                              foregroundColor: context.colors.onPrimary,
                            ),
                            label: Text(locale.backup_restore__button__create),
                          ),
                          ElevatedButton.icon(
                            onPressed: _busy ? null : _restoreBackup,
                            icon: const Icon(Icons.restore_page_rounded),
                            label: Text(locale.backup_restore__button__restore),
                          ),
                        ],
                      ),
                      if (_busy) ...[
                        height16,
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        height8,
                        Text(
                          _busyLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_backupSummary != null) ...[
                height16,
                _StatsSection(
                  title: locale.backup_restore__snapshot__backup_title,
                  subtitle: _backupSummary!.outputPath,
                  icon: Icons.backup_table_rounded,
                  stats: backupStats,
                ),
              ],
              if (_restoreSummary != null) ...[
                height16,
                _StatsSection(
                  title: locale.backup_restore__snapshot__restore_title,
                  subtitle: locale.backup_restore__snapshot__restore_subtitle,
                  icon: Icons.assignment_turned_in_rounded,
                  stats: restoreStats,
                ),
              ],
              if (_backupSummary == null && _restoreSummary == null) ...[
                height16,
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(padding16),
                    child: Text(
                      locale.backup_restore__empty_session,
                      style: textTheme.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<_StatItem> stats;

  const _StatsSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                width8,
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            height4,
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            height12,
            for (final stat in stats)
              _MetricRow(label: stat.label, value: stat.value),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: padding4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogSectionTitle extends StatelessWidget {
  final String text;

  const _DialogSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: padding8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final ClipItemType type;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _TypeChip({
    required this.type,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(_typeName(type)),
      selected: selected,
      onSelected: onSelected,
    );
  }
}

String _typeName(ClipItemType type) {
  switch (type) {
    case ClipItemType.text:
      return 'Text';
    case ClipItemType.url:
      return 'URL';
    case ClipItemType.file:
      return 'File';
    case ClipItemType.media:
      return 'Media';
  }
}

class _StatItem {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);
}

class _BackupOptions {
  final Set<ClipItemType> clipTypes;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? maxFileSizeBytes;
  final String? password;

  bool get includeCachedFiles => _hasCacheableClipTypes(clipTypes);

  const _BackupOptions({
    required this.clipTypes,
    required this.fromDate,
    required this.toDate,
    required this.maxFileSizeBytes,
    this.password,
  });
}

void _toggleType(Set<ClipItemType> types, ClipItemType type, bool selected) {
  if (selected) {
    types.add(type);
    return;
  }
  types.remove(type);
}

bool _hasCacheableClipTypes(Set<ClipItemType> types) {
  return types.contains(ClipItemType.file) ||
      types.contains(ClipItemType.media);
}
