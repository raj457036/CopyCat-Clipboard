import 'package:clipboard/base/domain/model/search_filter_state.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/datetime_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

const _allClipCategories = {
  ClipItemType.text,
  ClipItemType.url,
  ClipItemType.media,
  ClipItemType.file,
};

class FilterDialog extends StatefulWidget {
  final SearchFilterState state;
  const FilterDialog({super.key, required this.state});

  Future<SearchFilterState?> open(BuildContext context) {
    return showDialog<SearchFilterState?>(
      context: context,
      builder: (innerContext) => this,
    );
  }

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTime? from, to;
  late Set<ClipItemType> typeIncludes;
  late Set<TextCategory> textCategory;
  late ClipboardSortKey sortBy;
  late SortOrder sortOrder;

  @override
  void initState() {
    super.initState();
    typeIncludes = widget.state.typeIncludes != null
        ? {...widget.state.typeIncludes!}
        : {..._allClipCategories};
    textCategory = {...?widget.state.textCategories};
    sortBy = widget.state.sortBy ?? ClipboardSortKey.modified;
    sortOrder = widget.state.sortOrder ?? SortOrder.desc;
    from = widget.state.from;
    to = widget.state.to;
  }

  void _setTextCategory(bool include, TextCategory type) {
    setState(() {
      if (include) {
        textCategory.add(type);
      } else {
        textCategory.remove(type);
      }
    });
  }

  void _setTypeInclusion(bool include, ClipItemType type) {
    setState(() {
      if (include) {
        typeIncludes.add(type);
      } else {
        typeIncludes.remove(type);
      }
      if (typeIncludes.isEmpty) typeIncludes = {..._allClipCategories};
    });
  }

  Future<DateTime?> _pickDate({
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initial,
  }) {
    return showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initial,
    );
  }

  Future<void> _selectFrom() async {
    final picked = await _pickDate(
      firstDate: DateTime(2023),
      lastDate: to?.subtract(const Duration(days: 1)) ?? systemTime(),
      initial: from,
    );
    if (mounted) setState(() => from = picked);
  }

  Future<void> _selectTo() async {
    final lastDate = systemTime();
    final picked = await _pickDate(
      firstDate: from?.add(const Duration(days: 1)) ?? DateTime(2023),
      lastDate: lastDate,
      initial: to,
    );
    if (mounted) {
      setState(() {
        to = picked?.add(
          Duration(
            hours: lastDate.hour,
            minutes: lastDate.minute,
            seconds: lastDate.second,
          ),
        );
      });
    }
  }

  void _applyFilter() {
    final searchState = SearchFilterState(
      from: from,
      to: to,
      sortBy: sortBy,
      sortOrder: sortOrder,
      textCategories:
          textCategory.isEmpty || !typeIncludes.contains(ClipItemType.text)
          ? null
          : textCategory,
      typeIncludes:
          typeIncludes.isEmpty ||
              typeIncludes.length == _allClipCategories.length
          ? null
          : typeIncludes,
    );
    Navigator.pop(context, searchState);
  }

  void _resetFilter() {
    Navigator.pop(context, const SearchFilterState());
  }

  void _setSortOrder(Set<SortOrder> order) {
    setState(() => sortOrder = order.first);
  }

  void _selectSortBy(ClipboardSortKey? key) {
    if (key == null) return;
    setState(() => sortBy = key);
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colors.primary,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required String title,
    required String value,
    required bool isSet,
    required IconData leading,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: isSet ? colors.secondaryContainer : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                leading,
                size: 18,
                color: isSet ? colors.onSecondaryContainer : colors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.outline,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isSet
                            ? colors.onSecondaryContainer
                            : colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (onClear != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 16),
                  tooltip: context.locale.search_filter__tooltip__clear,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mq.size;
    if (size.width < 300) {
      return AlertDialog(
        content: Center(child: Text(context.locale.search_filter__empty)),
      );
    }
    final locale = context.locale;
    final localeName = locale.localeName;
    final dateFormatter = getLocaleDateFormatter(localeName);
    final colors = context.colors;
    final textTheme = context.textTheme;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      title: Row(
        children: [
          Icon(Icons.filter_list_rounded, color: colors.primary, size: 20),
          const SizedBox(width: 8),
          Text(locale.search_filter__text__title),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // MARK: - Date Range
              _sectionLabel(context, locale.search_filter__text__from),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: _buildDateSelector(
                      context: context,
                      title: locale.search_filter__text__from,
                      value: from != null
                          ? dateFormatter.format(from!)
                          : locale.search_filter__text__select,
                      leading: Icons.calendar_today_rounded,
                      isSet: from != null,
                      onTap: _selectFrom,
                      onClear: from != null
                          ? () => setState(() => from = null)
                          : null,
                    ),
                  ),
                  Text(
                    '→',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.outline,
                    ),
                  ),
                  Expanded(
                    child: _buildDateSelector(
                      context: context,
                      title: locale.search_filter__text__to,
                      value: to != null
                          ? dateFormatter.format(to!)
                          : locale.search_filter__text__now,
                      leading: Icons.event_rounded,
                      isSet: to != null,
                      onTap: _selectTo,
                      onClear: to != null
                          ? () => setState(() => to = null)
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // MARK: - Content Type
              _sectionLabel(context, locale.search_filter__text__including),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    avatar: const Icon(Icons.text_fields_rounded, size: 16),
                    label: Text(locale.search_filter__chip__text),
                    onSelected: (v) => _setTypeInclusion(v, ClipItemType.text),
                    selected: typeIncludes.contains(ClipItemType.text),
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.link_rounded, size: 16),
                    label: Text(locale.search_filter__chip__url),
                    onSelected: (v) => _setTypeInclusion(v, ClipItemType.url),
                    selected: typeIncludes.contains(ClipItemType.url),
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.image_rounded, size: 16),
                    label: Text(locale.search_filter__chip__media),
                    onSelected: (v) => _setTypeInclusion(v, ClipItemType.media),
                    selected: typeIncludes.contains(ClipItemType.media),
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.description_rounded, size: 16),
                    label: Text(locale.search_filter__chip__docs),
                    onSelected: (v) => _setTypeInclusion(v, ClipItemType.file),
                    selected: typeIncludes.contains(ClipItemType.file),
                  ),
                ],
              ),

              // MARK: - Text Categories (Conditional)
              AnimatedSize(
                duration: Durations.short4,
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: typeIncludes.contains(ClipItemType.text)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _sectionLabel(
                            context,
                            locale.search_filter__text__textCategories,
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilterChip(
                                avatar: const Icon(
                                  Icons.email_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  locale.search_filter__text_cat__email,
                                ),
                                onSelected: (v) =>
                                    _setTextCategory(v, TextCategory.email),
                                selected: textCategory.contains(
                                  TextCategory.email,
                                ),
                              ),
                              FilterChip(
                                avatar: const Icon(
                                  Icons.phone_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  locale.search_filter__text_cat__phone,
                                ),
                                onSelected: (v) =>
                                    _setTextCategory(v, TextCategory.phone),
                                selected: textCategory.contains(
                                  TextCategory.phone,
                                ),
                              ),
                              FilterChip(
                                avatar: const Icon(
                                  Icons.palette_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  locale.search_filter__text_cat__color,
                                ),
                                onSelected: (v) =>
                                    _setTextCategory(v, TextCategory.color),
                                selected: textCategory.contains(
                                  TextCategory.color,
                                ),
                              ),
                              FilterChip(
                                avatar: const Icon(
                                  Icons.code_rounded,
                                  size: 16,
                                ),
                                label: Text(
                                  locale.search_filter__text_cat__struct,
                                ),
                                onSelected: (v) =>
                                    _setTextCategory(v, TextCategory.struct),
                                selected: textCategory.contains(
                                  TextCategory.struct,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),
              Divider(color: colors.outlineVariant),
              const SizedBox(height: 12),

              // MARK: - Sort
              _sectionLabel(context, locale.search_filter__text__sort_by),
              DropdownMenu<ClipboardSortKey>(
                width: 360,
                menuStyle: const MenuStyle(
                  visualDensity: VisualDensity.compact,
                ),
                textStyle: textTheme.bodyMedium,
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: colors.surfaceContainerLow,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                initialSelection: sortBy,
                onSelected: _selectSortBy,
                dropdownMenuEntries: [
                  DropdownMenuEntry(
                    value: ClipboardSortKey.modified,
                    label: locale.search_filter__sort_by__last_mod,
                  ),
                  DropdownMenuEntry(
                    value: ClipboardSortKey.created,
                    label: locale.search_filter__sort_by__created,
                  ),
                  DropdownMenuEntry(
                    value: ClipboardSortKey.copyCount,
                    label: locale.search_filter__sort_by__copy_count,
                  ),
                  DropdownMenuEntry(
                    value: ClipboardSortKey.lastCopied,
                    label: locale.search_filter__sort_by__last_copied,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _sectionLabel(context, locale.search_filter__text__sort_order),
              SegmentedButton<SortOrder>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: SortOrder.desc,
                    icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                    label: Text(locale.search_filter__sort_ord__desc),
                  ),
                  ButtonSegment(
                    value: SortOrder.asc,
                    icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                    label: Text(locale.search_filter__sort_ord__asc),
                  ),
                ],
                onSelectionChanged: _setSortOrder,
                selected: {sortOrder},
                style: const ButtonStyle(visualDensity: VisualDensity.compact),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetFilter,
          child: Text(
            locale.search_filter__button__reset,
            style: TextStyle(color: colors.error),
          ),
        ),
        FilledButton.icon(
          onPressed: _applyFilter,
          icon: const Icon(Icons.check_rounded, size: 18),
          label: Text(locale.search_filter__button__apply),
        ),
      ],
    );
  }
}
