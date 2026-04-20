import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class MultiPasteOptions {
  final String? textMergeSeparator;
  final Duration waitBetweenPastes;

  const MultiPasteOptions({
    required this.textMergeSeparator,
    required this.waitBetweenPastes,
  });
}

enum _SeparatorPreset { newLine, space, custom }

class MultiPasteDialog extends StatefulWidget {
  final List<ClipboardItem> items;

  const MultiPasteDialog({super.key, required this.items});

  Future<MultiPasteOptions?> show(BuildContext context) async {
    return await showDialog<MultiPasteOptions>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<MultiPasteDialog> createState() => _MultiPasteDialogState();
}

class _MultiPasteDialogState extends State<MultiPasteDialog> {
  static const _defaultWaitMs = 50;

  bool mergeConsecutiveText = true;
  _SeparatorPreset separatorPreset = _SeparatorPreset.newLine;
  late final TextEditingController customSeparatorController;
  late final TextEditingController waitMsController;

  @override
  void initState() {
    super.initState();
    customSeparatorController = TextEditingController();
    waitMsController = TextEditingController(text: "$_defaultWaitMs");
  }

  @override
  void dispose() {
    customSeparatorController.dispose();
    waitMsController.dispose();
    super.dispose();
  }

  String _resolveSeparator() {
    switch (separatorPreset) {
      case _SeparatorPreset.newLine:
        return "\n";
      case _SeparatorPreset.space:
        return " ";
      case _SeparatorPreset.custom:
        return _decodeEscapes(customSeparatorController.text);
    }
  }

  String _separatorLabel(_SeparatorPreset preset) {
    switch (preset) {
      case _SeparatorPreset.newLine:
        return 'New line';
      case _SeparatorPreset.space:
        return 'Space';
      case _SeparatorPreset.custom:
        return 'Custom';
    }
  }

  String _decodeEscapes(String input) {
    return input
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\r', '\r');
  }

  void _submit() {
    final waitMs = int.tryParse(waitMsController.text.trim());
    if (waitMs == null || waitMs < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wait time must be a positive number.')),
      );
      return;
    }

    if (mergeConsecutiveText &&
        separatorPreset == _SeparatorPreset.custom &&
        customSeparatorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a custom separator.')),
      );
      return;
    }

    Navigator.pop(
      context,
      MultiPasteOptions(
        textMergeSeparator: mergeConsecutiveText ? _resolveSeparator() : null,
        waitBetweenPastes: Duration(milliseconds: waitMs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textClipCount = widget.items.where((item) => item.isTextType).length;
    final mediaClipCount = widget.items.length - textClipCount;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: AlertDialog(
        title: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.content_paste_go_outlined,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            width12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Multi Paste Setup',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Control how selected clips are merged and paced.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: 'Selected',
                          value: '${widget.items.length}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                          label: 'Text',
                          value: '$textClipCount',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatTile(
                          label: 'Non-text',
                          value: '$mediaClipCount',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card.outlined(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Merge consecutive text clips',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Text clips merge until a non-text clip interrupts the sequence.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Switch.adaptive(
                              value: mergeConsecutiveText,
                              onChanged: (value) {
                                setState(() {
                                  mergeConsecutiveText = value;
                                });
                              },
                            ),
                          ],
                        ),
                        if (mergeConsecutiveText) ...[
                          const SizedBox(height: 16),
                          Text('Separator', style: theme.textTheme.labelLarge),
                          const SizedBox(height: 10),
                          SegmentedButton<_SeparatorPreset>(
                            showSelectedIcon: false,
                            segments: [
                              for (final preset in [
                                _SeparatorPreset.newLine,
                                _SeparatorPreset.space,
                                _SeparatorPreset.custom,
                              ])
                                ButtonSegment<_SeparatorPreset>(
                                  value: preset,
                                  label: Text(_separatorLabel(preset)),
                                ),
                            ],
                            selected: {separatorPreset},
                            onSelectionChanged: (selection) {
                              setState(() {
                                separatorPreset = selection.first;
                              });
                            },
                          ),
                          if (separatorPreset == _SeparatorPreset.custom) ...[
                            const SizedBox(height: 12),
                            TextField(
                              controller: customSeparatorController,
                              decoration: const InputDecoration(
                                labelText: 'Custom separator',
                                hintText:
                                    'Supports escape sequences like \\n and \\t',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card.outlined(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paste pacing',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Increase the delay if the target app misses paste events.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: waitMsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Wait time between pastes',
                            suffixText: 'ms',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height10,
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Paste'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.headlineSmall),
      ],
    );
  }
}
