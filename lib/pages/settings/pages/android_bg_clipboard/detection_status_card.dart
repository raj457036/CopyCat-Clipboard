import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/color_extension.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class DetectionStatusCard extends StatelessWidget {
  final String state;
  final String outcome;

  const DetectionStatusCard({
    super.key,
    required this.state,
    required this.outcome,
  });

  String _title() {
    return switch (state) {
      'inactive' => 'Detection inactive',
      'calibrating' => 'Calibrating detection',
      'running_heuristic' => 'Heuristic detection active',
      'running_aggressive' => 'Aggressive detection active',
      'running_overlay' => 'Overlay detection active',
      'starting' => 'Preparing detection',
      'stopped' => 'Detection service stopped',
      _ => 'Detection status unavailable',
    };
  }

  String _subtitle() {
    return switch (state) {
      'inactive' =>
        'Enable accessibility and select a mode to begin background clipboard detection.',
      'calibrating' =>
        'Please avoid switching apps or interacting until calibration finishes.',
      'running_heuristic' =>
        'CopyCat is running the acknowledgement heuristic.',
      'running_aggressive' =>
        'CopyCat is scanning broader accessibility events.',
      'running_overlay' =>
        'CopyCat is using the persistent overlay clipboard listener.',
      'starting' => 'CopyCat is preparing the selected detection mode.',
      'stopped' =>
        'Enable the accessibility service to resume background capture.',
      _ => 'Open the accessibility service if detection is not responding.',
    };
  }

  String? _outcomeText() {
    return switch (outcome) {
      'success' => 'Last calibration succeeded',
      'failure' => 'Last calibration fell back',
      'pending' => 'Calibration pending',
      _ => null,
    };
  }

  Color _accent(BuildContext context) {
    final colors = context.colors;
    return switch (state) {
      'calibrating' => Colors.amber,
      'stopped' => colors.error,
      _ => colors.primary,
    };
  }

  IconData _icon() {
    return switch (state) {
      'inactive' => Icons.radio_button_unchecked_rounded,
      'calibrating' => Icons.tune_rounded,
      'running_overlay' => Icons.layers_clear_rounded,
      'running_aggressive' => Icons.bolt_rounded,
      'running_heuristic' => Icons.auto_awesome_motion_rounded,
      'stopped' => Icons.pause_circle_outline_rounded,
      _ => Icons.info_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final isLight = context.theme.brightness == Brightness.light;
    final accent = _accent(context);
    final outcomeText = _outcomeText();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: padding12),
      padding: const EdgeInsets.all(padding16),
      decoration: BoxDecoration(
        borderRadius: radius16,
        color: accent.darker(12, isLight),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon(), color: accent),
              width10,
              Expanded(
                child: Text(
                  _title(),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          height8,
          Text(
            _subtitle(),
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          if (outcomeText != null) ...[
            height12,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: padding10,
                vertical: padding8,
              ),
              decoration: BoxDecoration(
                borderRadius: radius12,
                color: colors.surface.withValues(alpha: 0.65),
              ),
              child: Text(outcomeText, style: textTheme.labelLarge),
            ),
          ],
        ],
      ),
    );
  }
}
