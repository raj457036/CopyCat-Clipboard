import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class AppLayoutView {
  final AppLayout layout;
  final AppView view;

  const AppLayoutView(this.layout, this.view);
}

class AppLayoutBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    AppLayoutView layoutView,
    bool supported,
  )
  builder;

  const AppLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppConfigCubit, AppConfigState, AppLayoutView>(
      selector: (state) {
        return AppLayoutView(state.config.layout, state.config.view);
      },
      builder: (context, layoutView) {
        final width = context.mq.size.width;
        if (width > dockedLRMaxWidth && !isMobilePlatform) {
          return builder(
            context,
            AppLayoutView(AppLayout.grid, layoutView.view),
            false,
          );
        }
        return builder(context, layoutView, true);
      },
    );
  }
}
