import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScaffoldBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? background;
  final bool enabled;

  const ScaffoldBody({
    super.key,
    required this.child,
    this.margin,
    this.background,
    this.borderRadius,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    if (context.isMobile) return child;

    BorderRadius borderRadius_ = const BorderRadius.vertical(
      top: Radius.circular(18),
    );

    return BlocSelector<
      WindowActionCubit,
      WindowActionState,
      (BorderRadius, EdgeInsetsGeometry)
    >(
      selector: (state) {
        EdgeInsets margin_;
        switch (state.view) {
          case AppView.topDocked || AppView.bottomDocked:
            {
              borderRadius_ = BorderRadius.zero;
              margin_ = EdgeInsets.zero;
            }

          default:
            margin_ = const EdgeInsets.only(right: padding12);
        }

        return (borderRadius ?? borderRadius_, margin ?? margin_);
      },
      builder: (context, state) {
        final (radius_, margin_) = state;
        return Card(
          margin: margin_,
          color: background,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: radius_),
          child: child,
        );
      },
    );
  }
}
