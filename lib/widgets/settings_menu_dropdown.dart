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

class SettingsMenuDropdown<T> extends StatelessWidget {
  const SettingsMenuDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemBuilder,
    this.onSelected,
    this.maxWidth,
  });

  final T value;
  final List<SettingsDropdownItem<T>> items;
  final SettingsDropdownItemBuilder<T> itemBuilder;
  final ValueChanged<T>? onSelected;
  final double? maxWidth;

  void handleToggle(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = itemBuilder(context, value);
    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selected.leading != null) ...[selected.leading!, width8],
        Flexible(child: selected.child),
        width4,
        const Icon(Icons.arrow_drop_down_rounded, size: 20),
      ],
    );

    final dropdown = MenuAnchor(
      style: MenuStyle(
        shape: const RoundedRectangleBorder(borderRadius: radius12).msp,
        mouseCursor: SystemMouseCursors.click.msp,
        alignment: Alignment.bottomLeft,
      ),
      menuChildren: [
        for (final item in items)
          Builder(
            builder: (context) {
              final details = itemBuilder(context, item.value);
              return MenuItemButton(
                leadingIcon: details.leading,
                trailingIcon: value == item.value
                    ? const Icon(Icons.check_rounded)
                    : details.trailing,
                onPressed: onSelected == null || !item.enabled
                    ? null
                    : () => onSelected!(item.value),
                child: details.child,
              );
            },
          ),
      ],
      child: buttonChild,
      builder: (context, controller, child) {
        return ElevatedButton(
          onPressed: onSelected == null ? null : () => handleToggle(controller),
          child: child,
        );
      },
    );

    if (maxWidth == null) {
      return dropdown;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: dropdown,
    );
  }
}
