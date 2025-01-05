import 'package:clipboard/widgets/layout/bottom_navbar.dart';
import 'package:clipboard/widgets/layout/dynamic_floating_actions.dart';
import 'package:clipboard/widgets/layout/navrail_layout.dart';
import 'package:copycat_base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/db/app_config/appconfig.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomScaffold extends StatelessWidget {
  final int activeIndex;
  final PreferredSizeWidget? appBar;
  final Drawer? endDrawer;
  final Widget body;

  const CustomScaffold({
    super.key,
    required this.activeIndex,
    required this.body,
    this.appBar,
    this.endDrawer,
  });

  @override
  Widget build(BuildContext context) {
    final width = context.mq.size.width;
    final smallScreen = Breakpoints.isMobile(width);

    Widget scaffoldBody = body;
    Widget? bottomNavBar;

    if (smallScreen) {
      bottomNavBar = BottomNavBar(navbarActiveIndex: activeIndex);
    }

    return BlocBuilder<WindowActionCubit, WindowActionState>(
        builder: (context, state) {
      final verticalDock =
          state.view == AppView.topDocked || state.view == AppView.bottomDocked;
      final floatingActions = DynamicFloatingActions(
        activeIndex: activeIndex,
        reversed: state.view != AppView.windowed || smallScreen,
        showCopyCatLogo: (activeIndex == 0 || activeIndex == 1) &&
            !smallScreen &&
            !verticalDock,
      );

      Widget scaffold = Scaffold(
        appBar: appBar,
        endDrawer: endDrawer,
        body: scaffoldBody,
        floatingActionButton: smallScreen && state.view == AppView.windowed
            ? floatingActions
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: bottomNavBar,
      );

      if (state.view != AppView.windowed || smallScreen) {
        return scaffold;
      }
      return NavrailLayout(
        navbarActiveIndex: activeIndex,
        floatingActionButton: floatingActions,
        child: scaffold,
      );
    });
  }
}
