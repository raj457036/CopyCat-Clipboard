import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ClipGridViewBuilder =
    Widget Function(
      BuildContext context,
      SliverGridDelegate delegate,
      Axis scrollDirection,
    );

class ClipGridDelegateProvider extends StatelessWidget {
  final ClipGridViewBuilder builder;

  const ClipGridDelegateProvider({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WindowActionCubit, WindowActionState>(
      builder: (context, state) {
        final SliverGridDelegate gridDelegate;
        final Axis scrollDirection;
        switch (state.view) {
          case AppView.bottomDocked || AppView.topDocked:
            gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: padding8,
              mainAxisSpacing: padding8,
            );
            scrollDirection = Axis.horizontal;
          case AppView.windowed:
            gridDelegate = const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260.0,
              crossAxisSpacing: padding8,
              mainAxisSpacing: padding8,
            );
            scrollDirection = Axis.vertical;
          case AppView.leftDocked || AppView.rightDocked:
            gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: padding8,
              mainAxisSpacing: padding8,
            );
            scrollDirection = Axis.vertical;
        }
        return builder(context, gridDelegate, scrollDirection);
      },
    );
  }
}
