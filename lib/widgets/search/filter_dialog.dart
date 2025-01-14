import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/domain/model/search_filter_state.dart';
import 'package:copycat_base/domain/sources/clipboard.dart';
import 'package:copycat_base/enums/clip_type.dart';
import 'package:copycat_base/enums/sort.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/datetime_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';

const _allClipCatergories = {
  ClipItemType.text,
  ClipItemType.url,
  ClipItemType.media,
  ClipItemType.file,
};

class FilterDialog extends StatefulWidget {
  final SearchFilterState state;
  const FilterDialog({
    super.key,
    required this.state,
  });

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
  SortOrder sortOrder = SortOrder.desc;

  @override
  void initState() {
    super.initState();
    if (widget.state.typeIncludes == null) {
      typeIncludes = {..._allClipCatergories};
    } else {
      typeIncludes = {...?widget.state.typeIncludes};
    }

    textCategory = {...?widget.state.textCategories};

    sortBy = widget.state.sortBy ?? ClipboardSortKey.modified;
    sortOrder = widget.state.sortOrder ?? SortOrder.desc;
    from = widget.state.from;
    to = widget.state.to;
  }

  void setTextCategory(bool include, TextCategory type) {
    setState(() {
      if (include) {
        textCategory.add(type);
      } else {
        textCategory.remove(type);
      }
    });
  }

  void setTypeInclusion(bool include, ClipItemType type) {
    setState(() {
      if (include) {
        typeIncludes.add(type);
      } else {
        typeIncludes.remove(type);
      }
      if (typeIncludes.isEmpty) {
        typeIncludes = {..._allClipCatergories};
      }
    });
  }

  Future<DateTime?> selectDate({
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initial,
  }) async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initial,
    );
    return selectedDate;
  }

  Future<void> selectFrom() async {
    final firstDate = DateTime(2023);
    final lastDate = to?.subtract(const Duration(days: 1)) ?? now();
    final from_ = await selectDate(
      firstDate: firstDate,
      lastDate: lastDate,
      initial: from,
    );

    if (mounted) {
      setState(() {
        from = from_;
      });
    }
  }

  Future<void> selectTo() async {
    final firstDate = from?.add(const Duration(days: 1)) ?? DateTime(2023);
    final lastDate = now();
    final to_ = await selectDate(
      firstDate: firstDate,
      lastDate: lastDate,
      initial: to,
    );

    if (mounted) {
      setState(() {
        to = to_?.add(Duration(
          hours: lastDate.hour,
          minutes: lastDate.minute,
          seconds: lastDate.second,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.mq.size;
    if (size.width < 300) {
      return const AlertDialog(
        content: Center(child: Text("∅")),
      );
    }
    final locale = context.locale;
    final localeName = locale.localeName;
    final dateFormatter = getLocaleDateFormatter(localeName);
    final textTheme = context.textTheme;
    final colors = context.colors;
    return AlertDialog(
      contentPadding: const EdgeInsets.only(bottom: padding10),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      title: Row(
        children: [
          Text(locale.search_filter__text__title),
          const Spacer(),
          if (size.height < 300)
            ElevatedButton(
              onPressed: applyFilter,
              child: Text(locale.search_filter__button__apply),
            ),
        ],
      ),
      content: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: padding16,
          vertical: padding16,
        ),
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(locale.search_filter__text__from),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: selectFrom,
                    child: Text(
                      from != null
                          ? dateFormatter.format(from!)
                          : locale.search_filter__text__select,
                    ),
                  )
                ],
              ),
              height8,
              Row(
                children: [
                  Text(locale.search_filter__text__to),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: selectTo,
                    child: Text(
                      to != null
                          ? dateFormatter.format(to!)
                          : locale.search_filter__text__now,
                    ),
                  )
                ],
              ),
              height8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(locale.search_filter__text__including),
                  height8,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: Text(locale.search_filter__chip__text),
                        onSelected: (value) =>
                            setTypeInclusion(value, ClipItemType.text),
                        selected: typeIncludes.contains(ClipItemType.text),
                      ),
                      FilterChip(
                        label: Text(locale.search_filter__chip__url),
                        onSelected: (value) =>
                            setTypeInclusion(value, ClipItemType.url),
                        selected: typeIncludes.contains(ClipItemType.url),
                      ),
                      FilterChip(
                        label: Text(locale.search_filter__chip__media),
                        onSelected: (value) =>
                            setTypeInclusion(value, ClipItemType.media),
                        selected: typeIncludes.contains(ClipItemType.media),
                      ),
                      FilterChip(
                        label: Text(locale.search_filter__chip__docs),
                        onSelected: (value) =>
                            setTypeInclusion(value, ClipItemType.file),
                        selected: typeIncludes.contains(ClipItemType.file),
                      ),
                    ],
                  )
                ],
              ),
              height12,
              if (typeIncludes.contains(ClipItemType.text))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(TextSpan(
                        text: locale.search_filter__text__textCategories,
                        children: [
                          TextSpan(
                            text: " ${locale.search_filter__text__exclusive}",
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.outline,
                            ),
                          ),
                        ])),
                    height8,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: Text(locale.search_filter__text_cat__email),
                          onSelected: (value) =>
                              setTextCategory(value, TextCategory.email),
                          selected: textCategory.contains(TextCategory.email),
                        ),
                        FilterChip(
                          label: Text(locale.search_filter__text_cat__phone),
                          onSelected: (value) =>
                              setTextCategory(value, TextCategory.phone),
                          selected: textCategory.contains(TextCategory.phone),
                        ),
                        FilterChip(
                          label: Text(locale.search_filter__text_cat__color),
                          onSelected: (value) =>
                              setTextCategory(value, TextCategory.color),
                          selected: textCategory.contains(TextCategory.color),
                        ),
                      ],
                    )
                  ],
                ),
              height8,
              const Divider(),
              height8,
              OverflowBar(
                spacing: 10,
                overflowSpacing: 10,
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.search_filter__text__sort_by),
                  DropdownMenu<ClipboardSortKey>(
                    hintText: locale.search_filter__text__select,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: radius12,
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.black12,
                      filled: true,
                      isDense: true,
                    ),
                    textStyle: textTheme.bodyMedium,
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
                    onSelected: selectSortBy,
                    initialSelection: sortBy,
                  )
                ],
              ),
              height8,
              OverflowBar(
                spacing: 10,
                overflowSpacing: 10,
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.search_filter__text__sort_order),
                  SegmentedButton<SortOrder>(
                    segments: [
                      ButtonSegment(
                        value: SortOrder.asc,
                        label: Text(locale.search_filter__sort_ord__asc),
                      ),
                      ButtonSegment(
                        value: SortOrder.desc,
                        label: Text(locale.search_filter__sort_ord__desc),
                      ),
                    ],
                    onSelectionChanged: setSortOrder,
                    selected: {sortOrder},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: size.height > 300
          ? [
              ElevatedButton(
                onPressed: applyFilter,
                child: Text(locale.search_filter__button__apply),
              ),
            ]
          : null,
    );
  }

  void applyFilter() {
    final searchState = SearchFilterState(
      from: from,
      to: to,
      sortBy: sortBy,
      sortOrder: sortOrder,
      textCategories:
          textCategory.isEmpty || !typeIncludes.contains(ClipItemType.text)
              ? null
              : textCategory,
      typeIncludes: typeIncludes.isEmpty || typeIncludes.length == 4
          ? null
          : typeIncludes,
    );
    Navigator.pop(context, searchState);
  }

  void setSortOrder(Set<SortOrder> order) {
    setState(() => sortOrder = order.first);
  }

  void selectSortBy(ClipboardSortKey? sortKey) {
    if (sortKey == null) return;
    setState(() => sortBy = sortKey);
  }
}
