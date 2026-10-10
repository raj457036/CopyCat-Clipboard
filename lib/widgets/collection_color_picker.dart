import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

/// A compact color swatch row + "custom" option for picking a collection color.
///
/// [value] is the current 24-bit RGB int (or null for no color).
/// [onChanged] receives the new 24-bit RGB int, or null when cleared.
class CollectionColorPicker extends StatelessWidget {
  final int? value;
  final void Function(int? rgbColor) onChanged;

  static const List<int> _swatches = [
    0xE53935, // red
    0xF4511E, // deep-orange
    0xFB8C00, // orange
    0xF9A825, // amber
    0x43A047, // green
    0x00897B, // teal
    0x1E88E5, // blue
    0x3949AB, // indigo
    0x8E24AA, // purple
    0xD81B60, // pink
    0x6D4C41, // brown
    0x546E7A, // blue-grey
  ];

  const CollectionColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _openFullPicker(BuildContext context) async {
    Color current = value != null
        ? Color(0xFF000000 | value!)
        : const Color(0xFF1E88E5);
    Color picked = current;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Custom color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: current,
            onColorChanged: (c) => picked = c,
            enableAlpha: false,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onChanged(picked.toARGB32() & 0xFFFFFF);
            },
            child: const Text("Select"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // "None" chip
            _ColorDot(
              color: null,
              isSelected: value == null,
              onTap: () => onChanged(null),
            ),
            // Preset swatches
            for (final swatch in _swatches)
              _ColorDot(
                color: Color(0xFF000000 | swatch),
                isSelected: value == swatch,
                onTap: () => onChanged(swatch),
              ),
            // Custom picker button
            InkWell(
              onTap: () => _openFullPicker(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.outlineVariant, width: 1.5),
                  gradient: const SweepGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                      Colors.red,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? colors.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? colors.primary : colors.outlineVariant,
              width: isSelected ? 2.5 : 1.5,
            ),
          ),
          child: const SizedBox(width: 36, height: 36),
        ),
      ),
    );
  }
}
