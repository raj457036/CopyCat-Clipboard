import 'dart:async';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/pages/ime/ime_service.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImeBottomBar extends StatefulWidget {
  final ImeService imeService;

  const ImeBottomBar({super.key, required this.imeService});

  @override
  State<ImeBottomBar> createState() => _ImeBottomBarState();
}

class _ImeBottomBarState extends State<ImeBottomBar> {
  Timer? _backspaceDelayTimer;
  Timer? _backspaceRepeatTimer;

  void _onBackspaceDown() {
    HapticFeedback.lightImpact();
    widget.imeService.deleteBackward();

    _backspaceDelayTimer?.cancel();
    _backspaceRepeatTimer?.cancel();

    _backspaceDelayTimer = Timer(const Duration(milliseconds: 400), () {
      _backspaceRepeatTimer = Timer.periodic(const Duration(milliseconds: 70), (
        _,
      ) {
        HapticFeedback.selectionClick();
        widget.imeService.deleteBackward();
      });
    });
  }

  void _onBackspaceUp() {
    _backspaceDelayTimer?.cancel();
    _backspaceRepeatTimer?.cancel();
    _backspaceDelayTimer = null;
    _backspaceRepeatTimer = null;
  }

  @override
  void dispose() {
    _onBackspaceUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(padding12, padding6, padding12, 60),
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: padding12,
            children: [
              Expanded(
                child: Material(
                  borderRadius: radius12,
                  elevation: 1,
                  child: InkWell(
                    borderRadius: radius12,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.imeService.commitText(' ');
                    },
                    onLongPress: () {
                      HapticFeedback.mediumImpact();
                      widget.imeService.showInputMethodPicker();
                    },
                    child: Center(child: Text('Space', style: tt.labelLarge)),
                  ),
                ),
              ),

              // Backspace button (tap: single delete, hold: repeat delete)
              Material(
                color: cs.surface,
                elevation: 1,
                borderRadius: radius12,
                child: InkWell(
                  borderRadius: radius12,
                  onTapDown: (_) => _onBackspaceDown(),
                  onTapUp: (_) => _onBackspaceUp(),
                  onTapCancel: () => _onBackspaceUp(),
                  child: const SizedBox(
                    width: 65,
                    height: 44,
                    child: Icon(Icons.backspace_outlined),
                  ),
                ),
              ),

              // Submit / editor action button
              ValueListenableBuilder<ImeActionType>(
                valueListenable: widget.imeService.activeAction,
                builder: (context, action, _) => Material(
                  color: cs.primaryContainer,
                  elevation: 1,
                  borderRadius: radius12,
                  child: InkWell(
                    borderRadius: radius12,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.imeService.performEditorAction();
                    },
                    child: SizedBox(
                      width: 65,
                      height: 44,
                      child: Icon(
                        _actionIcon(action),
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _actionIcon(ImeActionType action) => switch (action) {
        ImeActionType.send => Icons.send_rounded,
        ImeActionType.search => Icons.search_rounded,
        ImeActionType.done => Icons.check_rounded,
        ImeActionType.go || ImeActionType.next => Icons.arrow_forward_rounded,
        ImeActionType.previous => Icons.arrow_back_rounded,
        _ => Icons.keyboard_return_rounded,
      };
}
