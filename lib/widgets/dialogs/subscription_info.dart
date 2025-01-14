import 'package:clipboard/widgets/subscription/apply_coupon.dart';
import 'package:clipboard/widgets/subscription/paywall/manage_subscription_button.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:copycat_pro/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:copycat_pro/utils/monetization.dart';
import 'package:copycat_pro/widgets/subscription/paywall/paywall.dart';
import 'package:copycat_pro/widgets/subscription/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureTabs extends StatelessWidget {
  const FeatureTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final freePlanIncludes = [
      (
        null,
        context.locale.sub_dialog__text__included,
        null,
      ),
      (
        const Icon(Icons.paste_rounded),
        context.locale.sub_dialog__f1__title,
        context.locale.sub_dialog__f1__subtitle,
      ),
      (
        const Icon(Icons.devices),
        context.locale.sub_dialog__f2__title,
        context.locale.sub_dialog__f2__subtitle,
      ),
      (
        const Icon(Icons.fiber_smart_record_outlined),
        context.locale.sub_dialog__f3__title,
        context.locale.sub_dialog__f3__subtitle,
      ),
      (
        const Icon(Icons.storage_rounded),
        context.locale.sub_dialog__f4__title,
        context.locale.sub_dialog__f4__subtitle,
      ),
      (
        const Icon(Icons.security_rounded),
        context.locale.sub_dialog__f5__title,
        context.locale.sub_dialog__f5__subtitle,
      ),
      (
        const Icon(Icons.add_to_drive_rounded),
        context.locale.sub_dialog__f6__title,
        context.locale.sub_dialog__f6__subtitle,
      ),
      (
        const Icon(Icons.manage_search_rounded),
        context.locale.sub_dialog__f7__title,
        context.locale.sub_dialog__f7__subtitle,
      ),
      (
        const Icon(Icons.cloud_sync_rounded),
        context.locale.sub_dialog__f8__title,
        context.locale.sub_dialog__f8__subtitle,
      ),
      (
        const Icon(Icons.collections_bookmark_rounded),
        context.locale.sub_dialog__f9__title,
        context.locale.sub_dialog__f9__subtitle,
      ),
      (
        const Icon(Icons.sync_alt_rounded),
        context.locale.sub_dialog__f10__title,
        context.locale.sub_dialog__f10__subtitle,
      )
    ];

    final proPlanIncludes = [
      (
        null,
        context.locale.sub_dialog__text__pro_title,
        context.locale.sub_dialog__text__pro_subtitle,
      ),
      (
        const Icon(Icons.rule_rounded),
        context.locale.sub_dialog__f11__title,
        context.locale.sub_dialog__f11__subtitle,
      ),
      (
        const Icon(Icons.highlight_alt_rounded),
        context.locale.sub_dialog__f12__title,
        context.locale.sub_dialog__f12__subtitle,
      ),
      (
        const Icon(Icons.color_lens_rounded),
        context.locale.sub_dialog__f13__title,
        context.locale.sub_dialog__f13__subtitle,
      ),
      (
        const Icon(Icons.collections_bookmark_rounded),
        context.locale.sub_dialog__f14__title,
        context.locale.sub_dialog__f14__subtitle,
      ),
      (
        const Icon(Icons.history_rounded),
        context.locale.sub_dialog__f15__title,
        context.locale.sub_dialog__f15__subtitle,
      ),
      (
        const Icon(Icons.sync_rounded),
        context.locale.sub_dialog__f16__title,
        context.locale.sub_dialog__f16__subtitle,
      ),
      (
        const Icon(Icons.support_agent_rounded),
        context.locale.sub_dialog__f17__title,
        context.locale.sub_dialog__f17__subtitle,
      ),
      (
        const Icon(Icons.new_releases_rounded),
        context.locale.sub_dialog__f18__title,
        context.locale.sub_dialog__f18__subtitle,
      ),
    ];
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TabBar(tabs: [
            Tab(text: "Free"),
            Tab(text: "PRO ✨"),
          ]),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: freePlanIncludes.length,
                  itemBuilder: (context, index) {
                    final (icon, title, subtitle) = freePlanIncludes[index];
                    return ListTile(
                      leading: icon,
                      title: Text(title),
                      subtitle: subtitle != null ? Text(subtitle) : null,
                    );
                  },
                ),
                ListView.builder(
                  itemCount: proPlanIncludes.length,
                  itemBuilder: (context, index) {
                    final (icon, title, subtitle) = proPlanIncludes[index];
                    return ListTile(
                      leading: icon,
                      title: Text(title),
                      subtitle: Text(subtitle),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionInfoDialog extends StatelessWidget {
  final bool entitlementGrantMode;
  const SubscriptionInfoDialog({
    super.key,
    this.entitlementGrantMode = false,
  });

  Future<void> open(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => this,
    );
  }

  Future<void> upgradeByPromoCode(BuildContext context) async {
    if (entitlementGrantMode) {
      const ApplyCouponDialog().open(context);
    }
  }

  Future<void> upgrade(BuildContext context) async {
    final monetizationCubit = context.read<MonetizationCubit>();
    if (isMobilePlatform) {
      presentPaywall();
      return;
    }
    CustomPaywallDialog(
      localization: CustomPaywallDialogLocalization(
        month: context.locale.paywall_dialog__text__month,
        year: context.locale.paywall_dialog__text__year,
        subscription: context.locale.paywall_dialog__text__subscription,
        subscribeInSupportedPlatform:
            context.locale.paywall_dialog__text__supported_platform,
        unlockPremiumFeatures: context.locale.paywall_dialog__text__unlock_pro,
        upgradeToPro: context.locale.paywall_dialog__text__unlock_pro_p1,
        tryAgain: context.locale.paywall_dialog__text__try_again,
        continue_: context.mlocale.continueButtonLabel.title,
        cancel: context.mlocale.cancelButtonLabel,
      ),
      onSubscription: monetizationCubit.onSubscriptionChange,
    ).open(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Breakpoints.isMobile(constraints.maxWidth);

        return SubscriptionBuilder(
          builder: (context, state) {
            if (state == null) {
              return AlertDialog(
                title: Text(context.locale.paywall_dialog__text__subscription),
                content: const Center(
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      "...",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            final expired = !state.isActive;
            final isTrial = state.isTrial;
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: AlertDialog(
                title: Row(
                  children: [
                    Text(context.locale.paywall_dialog__text__subscription),
                    const Spacer(),
                    const CloseButton(),
                  ],
                ),
                insetPadding: isMobile
                    ? const EdgeInsets.all(padding8)
                    : const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 24.0),
                contentPadding: isMobile ? EdgeInsets.zero : null,
                content: SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          expired
                              ? context
                                  .locale.paywall_dialog__text__expired_plan
                              : context
                                  .locale.paywall_dialog__text__current_plan,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.planName,
                              style: textTheme.titleLarge,
                            ),
                            height2,
                            if (isTrial && state.trialEnd != null)
                              Text(
                                context.locale.paywall_dialog__text__trial_till(
                                  till: state.trialEnd!,
                                ),
                              ),
                          ],
                        ),
                        trailing: expired || state.isFree
                            ? ElevatedButton.icon(
                                onPressed: () => upgrade(context),
                                onLongPress: () => upgradeByPromoCode(context),
                                icon:
                                    const Icon(Icons.workspace_premium_rounded),
                                label: Text(
                                  context.locale.paywall_dialog__text__upgrade,
                                ),
                              )
                            : const ManageSubscriptionButton(),
                      ),
                      const Expanded(child: FeatureTabs())
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
