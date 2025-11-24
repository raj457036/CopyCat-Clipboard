import 'package:clipboard/widgets/empty.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TitleTextExclusionTab extends StatefulWidget {
  const TitleTextExclusionTab({super.key});

  @override
  State<TitleTextExclusionTab> createState() => _TitleTextExclusionTabState();
}

class _TitleTextExclusionTabState extends State<TitleTextExclusionTab> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void update(AppConfigCubit cubit, List<String> excluded) {
    final ExclusionRules updatedRules = cubit.exclusionRules.copyWith(
      titles: excluded,
    );
    cubit.updateExclusionRule(updatedRules);
  }

  void deleteItem(BuildContext context, int index) {
    final cubit = context.read<AppConfigCubit>();
    final rules = cubit.exclusionRules;
    final excluded = [
      ...rules.titles.take(index),
      ...rules.titles.skip(index + 1)
    ];
    update(cubit, excluded);
  }

  void addEntry(BuildContext context, String entry) async {
    controller.clear();
    final cubit = context.read<AppConfigCubit>();
    if (entry.isEmpty) return;
    final excluded = {entry, ...cubit.exclusionRules.titles}.toList();
    update(cubit, excluded);
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // dense: true,
          title: Text(context.locale.custom_er__tile__title),
          subtitle: TextField(
            focusNode: focusNode,
            controller: controller,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
            onSubmitted: (value) => addEntry(context, value),
          ),
        ),
        height10,
        Expanded(
          child: BlocSelector<AppConfigCubit, AppConfigState, List<String>>(
            selector: (state) {
              switch (state) {
                case AppConfigLoaded(:final config):
                  return config.copyExclusionRules.titles;
                default:
                  return const [];
              }
            },
            builder: (context, rules) {
              if (rules.isEmpty) {
                return EmptyNote(
                  note: context.locale.custom_er__text__no_title,
                );
              }
              return ListView.builder(
                itemCount: rules.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = rules[index];
                  return ListTile(
                    title: Text(item),
                    dense: true,
                    leading: IconButton(
                      onPressed: () => deleteItem(context, index),
                      icon: const Icon(Icons.remove_circle_rounded),
                      tooltip: context.locale.custom_er__button__remove_title,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
