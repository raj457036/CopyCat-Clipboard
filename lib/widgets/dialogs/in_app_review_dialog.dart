import 'package:animate_do/animate_do.dart' show SlideInUp;
import 'package:clipboard/base/bloc/review_prompt_cubit/review_prompt_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/services/review_prompt_service.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/routes/routes.dart' show rootNavigationKey;
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/cat_introduction_avatar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shows the in-app review dialog
Future<void> showInAppReviewDialog({required ReviewPromptCubit cubit}) async {
  final context = rootNavigationKey.currentContext;
  if (context == null) {
    logger.w('Cannot show review dialog: root navigator context is null');
    return;
  }

  final response = await showDialog<ReviewResponse>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _InAppReviewDialog(),
    routeSettings: const RouteSettings(name: "in_app_review_dialog"),
  );

  if (response == null) return;

  if (response == ReviewResponse.rateNow) {
    final result = await cubit.requestReview();
    if (result) {
      await cubit.recordReviewResponse(response);
    }
    return;
  }
  await cubit.recordReviewResponse(response);
}

class _NeverButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _NeverButton({required this.label, required this.onPressed});

  @override
  State<_NeverButton> createState() => _NeverButtonState();
}

class _NeverButtonState extends State<_NeverButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TextButton(
        clipBehavior: Clip.hardEdge,
        onPressed: widget.onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideInUp(
              animate: _hovered,
              duration: Durations.short2,
              curve: Curves.easeInOut,
              child: const Text('😿 '),
            ),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}

class _InAppReviewDialog extends StatelessWidget {
  const _InAppReviewDialog();

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            padding20,
            padding20,
            padding20,
            padding16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CatIntroductionAvatar(),
              height16,
              Text(
                locale.review__dialog__title,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              height10,
              Text(
                locale.review__dialog__message,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
              height20,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.pop(ReviewResponse.rateNow),
                  icon: const Icon(Icons.star_rounded),
                  label: Text(
                    locale.review__dialog__rate_now,
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: colors.onPrimary,
                    backgroundColor: colors.primary,
                  ),
                ),
              ),
              height12,
              OverflowBar(
                alignment: MainAxisAlignment.center,
                overflowAlignment: OverflowBarAlignment.center,
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () => context.pop(ReviewResponse.remindLater),
                    child: Text(locale.review__dialog__remind_later),
                  ),
                  _NeverButton(
                    label: locale.review__dialog__never,
                    onPressed: () => context.pop(ReviewResponse.never),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
