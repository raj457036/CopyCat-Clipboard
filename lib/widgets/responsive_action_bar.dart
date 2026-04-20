import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:flutter/material.dart';

/// Represents a single action in the responsive action bar
class ActionItem {
  final String key;
  final String label;
  final IconData icon;
  final VoidCallback action;
  final bool isCustomButton;
  final Widget? customButton;

  ActionItem({
    required this.key,
    required this.label,
    required this.icon,
    required this.action,
    this.isCustomButton = false,
    this.customButton,
  });
}

/// A responsive action bar that automatically moves items to an overflow menu
/// when there's not enough space to display them all.
///
/// The widget calculates available width and determines how many actions can fit
/// as individual buttons before remaining actions are moved to a dropdown menu.
class ResponsiveActionBar extends StatelessWidget {
  /// List of actions to display
  final List<ActionItem> actions;

  /// Estimated width of each button in pixels (default: 56)
  final double buttonWidth;

  /// Estimated width of the "more" button in pixels (default: 56)
  final double moreButtonWidth;

  /// Spacing between buttons in pixels (default: 6)
  final double spacingWidth;

  /// Trailing spacing (default: 12)
  final double trailingSpacing;

  /// Tooltip for the more options button
  final String? moreButtonTooltip;

  /// Icon for the more options button
  final IconData moreButtonIcon;

  const ResponsiveActionBar({
    super.key,
    required this.actions,
    this.buttonWidth = kMinInteractiveDimension,
    this.moreButtonWidth = kMinInteractiveDimension,
    this.spacingWidth = padding6,
    this.trailingSpacing = padding12,
    this.moreButtonTooltip,
    this.moreButtonIcon = Icons.more_vert,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var availableWidth = constraints.maxWidth;

        // Handle infinite width case
        if (!availableWidth.isFinite) {
          availableWidth = 600; // Default to show all actions
        }

        // Calculate how many buttons can fit
        final buttonsCanFit =
            ((availableWidth - moreButtonWidth) / (buttonWidth + spacingWidth))
                .floor()
                .clamp(0, actions.length);

        // Determine which actions to show directly
        final numToShow = buttonsCanFit.clamp(0, actions.length);
        final visibleActions = actions.take(numToShow).toList();
        final hiddenActions = actions.skip(numToShow).toList();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show visible action buttons
            for (var i = 0; i < visibleActions.length; i++) ...[
              if (visibleActions[i].isCustomButton &&
                  visibleActions[i].customButton != null)
                visibleActions[i].customButton!
              else
                IconButton(
                  onPressed: visibleActions[i].action,
                  tooltip: visibleActions[i].label,
                  icon: Icon(visibleActions[i].icon),
                ),
              if (i < visibleActions.length - 1) SizedBox(width: spacingWidth),
            ],

            // Show more button if there are hidden actions
            if (hiddenActions.isNotEmpty) SizedBox(width: spacingWidth),
            if (hiddenActions.isNotEmpty)
              PopupMenuButton<String>(
                tooltip:
                    moreButtonTooltip ??
                    MaterialLocalizations.of(context).moreButtonTooltip,
                onSelected: (value) {
                  final action = hiddenActions.firstWhere(
                    (a) => a.key == value,
                  );
                  action.action();
                },
                itemBuilder: (BuildContext context) {
                  return hiddenActions.map((action) {
                    return PopupMenuItem(
                      value: action.key,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(action.icon),
                          width8,
                          Text(action.label),
                        ],
                      ),
                    );
                  }).toList();
                },
                icon: Icon(moreButtonIcon),
              ),
            SizedBox(width: trailingSpacing),
          ],
        );
      },
    );
  }
}
