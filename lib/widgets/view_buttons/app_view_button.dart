import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/dock_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppViewButton extends StatelessWidget {
  const AppViewButton({super.key});

  void _changeView(BuildContext context, AppView view) {
    final appConfigCubit = context.read<AppConfigCubit>();
    final windowActionCubit = context.read<WindowActionCubit>();

    appConfigCubit.changeAppView(view);

    // MARK: Forced Nav Logic
    //
    // Note(raj): should we navigate to home? the reason is when the app is in
    // docked mode, we have very limited space to show any page other than home or
    // the collection page. since not all pages are optimized yet for docked mode,
    // it might be better to always navigate to home when changing to docked mode.
    //
    // On the other hand, it might be disruptive if the user is in the middle of doing
    // something and suddenly gets navigated to home.
    //
    // A better approach might be to actually check the current route and only navigate
    // to home if the current route is not optimized for docked mode.
    // TODO! (raj): implement the above logic and remove the forced navigation to home.
    // if (view != AppView.windowed) {
    //   rootNavigationKey.currentContext?.goNamed(RouteConstants.home);
    // }

    if (view == AppView.windowed) {
      windowActionCubit.setup(view, initialWindowSize);
    } else {
      final currentSize = appConfigCubit.state.config.windowSize;
      windowActionCubit.setup(view, currentSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WindowActionCubit, WindowActionState>(
      builder: (context, state) {
        if (state.loading) return const SizedBox.shrink();

        return MenuAnchor(
          consumeOutsideTap: true,
          builder:
              (BuildContext context, MenuController controller, Widget? child) {
                return IconButton(
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                  ),
                  iconSize: 20,
                  icon: const Icon(Icons.dashboard_rounded),
                  tooltip: context.locale.view_button__change_view,
                );
              },
          menuChildren: [
            MenuItemButton(
              leadingIcon: const Icon(Icons.crop_landscape, size: 26),
              child: Text(context.locale.view_button__view_window),
              onPressed: () => _changeView(context, AppView.windowed),
            ),
            MenuItemButton(
              leadingIcon: const Icon(DockIcons.dockRight),
              child: Text(context.locale.view_button__view_dock_right),
              onPressed: () => _changeView(context, AppView.rightDocked),
            ),
            MenuItemButton(
              leadingIcon: const Icon(DockIcons.dockBottom),
              child: Text(context.locale.view_button__view_dock_bottom),
              onPressed: () => _changeView(context, AppView.bottomDocked),
            ),
            MenuItemButton(
              leadingIcon: const Icon(DockIcons.dockLeft),
              child: Text(context.locale.view_button__view_dock_left),
              onPressed: () => _changeView(context, AppView.leftDocked),
            ),
            MenuItemButton(
              leadingIcon: const Icon(DockIcons.dockTop),
              child: Text(context.locale.view_button__view_dock_top),
              onPressed: () => _changeView(context, AppView.topDocked),
            ),
          ],
        );
      },
    );
  }
}
