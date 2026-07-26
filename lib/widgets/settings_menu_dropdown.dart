import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

typedef SettingsDropdownItemBuilder<T> =
    ({Widget? leading, Widget child, Widget? trailing}) Function(
      BuildContext context,
      T value,
    );

class SettingsDropdownItem<T> {
  const SettingsDropdownItem({required this.value, this.enabled = true});

  final T value;
  final bool enabled;
}

class SettingsMenuDropdown<T> extends StatefulWidget {
  const SettingsMenuDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemBuilder,
    this.onSelected,
  });

  final T value;
  final List<SettingsDropdownItem<T>> items;
  final SettingsDropdownItemBuilder<T> itemBuilder;
  final ValueChanged<T>? onSelected;

  @override
  State<SettingsMenuDropdown<T>> createState() =>
      _SettingsMenuDropdownState<T>();
}

class _SettingsMenuDropdownState<T> extends State<SettingsMenuDropdown<T>> {
  final MenuController _controller = MenuController();

  void _toggle() {
    if (_controller.isOpen) {
      _controller.close();
    } else {
      _controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final selected = widget.itemBuilder(context, widget.value);
    const menuWidth = 180.0;

    final anchor = MenuAnchor(
      controller: _controller,
      animated: true,
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      alignmentOffset: const Offset(0, -18),
      style: MenuStyle(
        alignment: Alignment.topLeft,
        minimumSize: const Size(menuWidth, 0).wsp,
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: radius16),
        ),
      ),
      menuChildren: [
        for (final item in widget.items)
          Builder(
            builder: (context) {
              final details = widget.itemBuilder(context, item.value);
              return MenuItemButton(
                leadingIcon: details.leading,
                trailingIcon: widget.value == item.value
                    ? const Icon(Icons.check_rounded, size: 18)
                    : details.trailing,
                closeOnActivate: true,
                onPressed: widget.onSelected == null || !item.enabled
                    ? null
                    : () => widget.onSelected!(item.value),
                style: MenuItemButton.styleFrom(
                  enabledMouseCursor: SystemMouseCursors.click,
                ),
                child: SizedBox(width: menuWidth - 72, child: details.child),
              );
            },
          ),
      ],
      builder: (context, controller, child) {
        final button = ElevatedButton(
          onPressed: widget.onSelected == null ? null : _toggle,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.surfaceContainerHigh,
            foregroundColor: colors.primary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected.leading != null) ...[selected.leading!, width8],
              Flexible(child: selected.child),
              width4,
              Icon(
                controller.isOpen
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
                size: 20,
              ),
            ],
          ),
        );

        return button;
      },
    );

    return anchor;
  }
}
