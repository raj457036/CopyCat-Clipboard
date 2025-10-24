import 'package:bloc/bloc.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:universal_io/io.dart';
import 'package:window_manager/window_manager.dart';

part 'window_action_cubit.freezed.dart';
part 'window_action_state.dart';

@injectable
class WindowActionCubit extends Cubit<WindowActionState> {
  Display? primaryDisplay;
  bool isCompactMode = false;
  bool isFocused = false;

  WindowActionCubit() : super(const WindowActionState.loaded());

  double get displayHeight {
    if (primaryDisplay != null) {
      final height = primaryDisplay?.visibleSize?.height ??
          primaryDisplay!.size.height -
              (primaryDisplay?.visiblePosition?.dy ?? 0);
      return height;
    }
    return initialWindowSize.height;
  }

  double get displayWidth {
    if (primaryDisplay != null) {
      final width = primaryDisplay?.visibleSize?.width ??
          primaryDisplay!.size.width -
              (primaryDisplay?.visiblePosition?.dx ?? 0);
      return width;
    }
    return initialWindowSize.width;
  }

  Future<void> checkFocus() async {
    if (isDesktopPlatform) {
      isFocused = await windowManager.isFocused();
    }
  }

  Future<void> setupScreenInfo() async {
    primaryDisplay = await screenRetriever.getPrimaryDisplay();
    checkFocus();
    emit(
      const WindowActionState.loaded(loading: false),
    );
  }

  Future<void> setup(AppView view, [Size? size]) async {
    if (!isDesktopPlatform) return;
    await setupScreenInfo();
    await changeView(view, size);
  }

  Future<void> changeView(AppView view, [Size? size]) async {
    await setupScreenInfo();
    if (view == AppView.windowed) {
      await setWindowdView(size);
    } else {
      await setDockedView(view, size);
    }
  }

  Future<void> setDockedView(AppView view, [Size? size]) async {
    if (!isDesktopPlatform) return;
    assert(view != AppView.windowed, "Only docked views allowed");

    final Alignment alignment = switch (view) {
      AppView.leftDocked => Alignment.centerLeft,
      AppView.rightDocked => Alignment.topRight,
      AppView.topDocked => Alignment.topCenter,
      AppView.bottomDocked => Alignment.bottomCenter,
      _ => Alignment.center,
    };

    final Size dockedMaxSize = switch (view) {
      AppView.leftDocked || AppView.rightDocked => Size(
          dockedLRMaxWidth,
          displayHeight,
        ),
      AppView.topDocked ||
      AppView.bottomDocked =>
        Size(displayWidth, dockedTBMaxHeight),
      _ => initialWindowSize,
    };

    final Size dockedMinSize = switch (view) {
      AppView.leftDocked || AppView.rightDocked => Size(
          dockedLRMinWidth,
          displayHeight,
        ),
      AppView.topDocked ||
      AppView.bottomDocked =>
        Size(displayWidth, dockedTBMinHeight),
      _ => initialWindowSize,
    };

    if (Platform.isMacOS) await windowManager.setMovable(false);
    if (Platform.isWindows) {
      final DockSide side = switch (view) {
        AppView.leftDocked || AppView.rightDocked => DockSide.left,
        AppView.topDocked || AppView.bottomDocked || _ => DockSide.right,
      };
      await windowManager.dock(side: side, width: 0);
    }
    await windowManager.setAsFrameless();
    await windowManager.setMinimumSize(dockedMinSize);
    await windowManager.setMaximumSize(dockedMaxSize);
    await windowManager.setAlwaysOnTop(true);
    final position = await calcWindowPosition(dockedMaxSize, alignment);
    await windowManager.setSize(dockedMaxSize);
    await windowManager.setPosition(position, animate: true);
    emit(state.copyWith(view: view));
  }

  Future<void> setWindowdView([Size? size]) async {
    await windowManager.setMinimumSize(minimumWindowSize);
    if (primaryDisplay != null) {
      await windowManager.setMaximumSize(primaryDisplay!.size);
    }
    if (Platform.isMacOS) await windowManager.setMovable(true);
    if (Platform.isWindows) await windowManager.undock();
    await windowManager.setAlwaysOnTop(false);
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setSize(size ?? initialWindowSize);
    await windowManager.center(animate: true);
    emit(state.copyWith(view: AppView.windowed));
  }

  Future<void> hide({bool animated = false}) async {
    isFocused = false;
    if (state.view == AppView.windowed) {
      if (animated && primaryDisplay != null) {
        final currentPosition = await windowManager.getPosition();
        windowManager.setPosition(
          Offset(
            currentPosition.dx,
            primaryDisplay?.size.height ?? 600,
          ),
          animate: true,
        );

        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
    await windowManager.hide();
  }

  Future<void> show({bool animated = false}) async {
    if (isMobilePlatform) return;
    if (state.view == AppView.windowed) {}
    await windowManager.show();
    await windowManager.focus();
    isFocused = true;
    requestFocus();
  }

  Future<void> requestFocus() async {
    final pf = FocusManager.instance.primaryFocus;
    if (pf == null) return;
    pf.requestFocus();
  }
}
