import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/paste_stack/widgets/paste_stack_body.dart';
import 'package:clipboard/utils/common_extension.dart'
    show BuildContextExtension;
import 'package:clipboard/utils/datetime_extension.dart';
import 'package:clipboard/utils/subscription_actions.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasteStackPage extends StatelessWidget {
  final int count;

  const PasteStackPage({super.key, required this.count});

  void reverseStack(BuildContext context) {
    context.read<PasteStackCubit>().reverseStack();
  }

  @override
  Widget build(BuildContext context) {
    final pasteStackLimit = context.select<MonetizationCubit, int>(
      (cubit) => cubit.state.maybeWhen(
        active: (s) => s.isFree ? s.pasteStackLimit : 0,
        orElse: () => defaultPasteStackLimit,
      ),
    );

    final banner = PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: MaterialBanner(
        content: Text(
          context.locale.paste_stack__limit_note(count: pasteStackLimit),
        ),
        actions: [
          TextButton(
            onPressed: showUpgradePlanDialog,
            child: Text(context.locale.paywall_dialog__text__upgrade),
          ),
        ],
        minActionBarHeight: 40,
      ),
    );

    return CanPasteBuilder(
      builder: (context, canPaste) {
        return BlocSelector<AppConfigCubit, AppConfigState, DateTime?>(
          selector: (state) {
            switch (state) {
              case AppConfigLoaded(:final config):
                return config.pausedTill;
              default:
                return null;
            }
          },
          builder: (context, pausedTill) {
            final inActive = pausedTill != null;
            return CustomScaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                // scrolledUnderElevation: 0,
                leading: BackButton(
                  onPressed: context.pop,
                  style: IconButton.styleFrom(
                    iconSize: 20,
                    padding: const EdgeInsets.all(padding8),
                    minimumSize: Size.zero,
                  ),
                ),
                titleSpacing: 0,
                backgroundColor: context.colors.surface,
                title: Text(context.locale.paste_stack__title(count: count)),
                centerTitle: false,
                titleTextStyle: context.textTheme.titleMedium,
                toolbarHeight: 40,
                bottom: pasteStackLimit != 0 ? banner : null,
                actions: [
                  IconButton.filledTonal(
                    onPressed: () => reverseStack(context),
                    tooltip: context.locale.paste_stack__reverse_tooltip,
                    icon: const Icon(Icons.unfold_more_rounded),
                    iconSize: 20,
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(padding8),
                      minimumSize: Size.zero,
                    ),
                  ),
                  width10,
                ],
              ),
              body: Column(
                children: [
                  if (inActive)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.info_outline_rounded),
                      title: Text(
                        context.locale.tray__tooltip__paused_till(
                          time: dateTimeFormatter().format(pausedTill),
                        ),
                      ),
                    ),
                  const Expanded(child: PasteStackBody()),
                ],
              ),
              activeIndex: -1,
            );
          },
        );
      },
    );
  }
}
