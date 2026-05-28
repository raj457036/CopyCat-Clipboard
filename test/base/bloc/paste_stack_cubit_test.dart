import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAppConfigCubit implements AppConfigCubit {
  _StubAppConfigCubit(this.config);

  AppConfig config;

  @override
  AppConfigState get state => AppConfigState.loaded(config: config);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _StubMonetizationCubit implements MonetizationCubit {
  _StubMonetizationCubit(this._state);

  MonetizationState _state;

  @override
  MonetizationState get state => _state;

  set stateValue(MonetizationState value) {
    _state = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _StubOfflinePersistenceCubit implements OfflinePersistenceCubit {
  final StreamController<ClipboardItem> _controller =
      StreamController<ClipboardItem>.broadcast();

  @override
  Stream<ClipboardItem> get newClipboardItemStream => _controller.stream;

  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class _SpyWindowActionCubit implements WindowActionCubit {
  int showPasteStackViewCalls = 0;
  int showCalls = 0;
  int focusCalls = 0;
  int clearBackgroundToggleCalls = 0;
  int changeViewCalls = 0;
  int alwaysOnTopCalls = 0;
  bool? alwaysOnTopValue;
  AppView? changedView;
  Size? changedSize;
  Duration showDelay = Duration.zero;
  Duration focusDelay = Duration.zero;
  bool showCompleted = false;
  bool focusCompleted = false;

  @override
  Future<void> showPasteStackView() async {
    showPasteStackViewCalls++;
  }

  @override
  Future<void> show() async {
    showCalls++;
    if (showDelay > Duration.zero) {
      await Future.delayed(showDelay);
    }
    showCompleted = true;
  }

  @override
  Future<void> focus() async {
    focusCalls++;
    if (focusDelay > Duration.zero) {
      await Future.delayed(focusDelay);
    }
    focusCompleted = true;
  }

  @override
  void clearPasteStackBackgroundToggleMode() {
    clearBackgroundToggleCalls++;
  }

  @override
  Future<void> changeView(AppView view, [Size? size]) async {
    changeViewCalls++;
    changedView = view;
    changedSize = size;
  }

  @override
  Future<void> alwaysOnTop(bool isAlwaysOnTop) async {
    alwaysOnTopCalls++;
    alwaysOnTopValue = isAlwaysOnTop;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

Subscription _subscription({int pasteStackLimit = 20}) {
  final now = DateTime(2026, 1, 1);
  return Subscription(
    created: now,
    modified: now,
    userId: 'u1',
    planName: 'Pro',
    subId: 'pro',
    source: 'test',
    activeTill: now.add(const Duration(days: 30)),
    pasteStackLimit: pasteStackLimit,
  );
}

ClipboardItem _textItem(String text) {
  return ClipboardItem.fromText(text, userId: 'u1');
}

void main() {
  group('PasteStackCubit', () {
    late _SpyWindowActionCubit windowAction;
    late _StubOfflinePersistenceCubit offline;

    setUp(() {
      windowAction = _SpyWindowActionCubit();
      offline = _StubOfflinePersistenceCubit();
    });

    tearDown(() async {
      await offline.dispose();
    });

    test(
      'activate uses paste stack window animation when previous view is windowed',
      () async {
        final appConfig = _StubAppConfigCubit(
          AppConfig(view: AppView.windowed, pinned: false),
        );
        final monetization = _StubMonetizationCubit(
          const MonetizationState.unknown(),
        );

        final cubit = PasteStackCubit(
          appConfig,
          windowAction,
          monetization,
          offline,
        );
        await cubit.activate();

        expect(windowAction.showPasteStackViewCalls, 1);
        expect(windowAction.showCalls, 0);
        expect(windowAction.focusCalls, 0);

        await cubit.close();
      },
    );

    test(
      'activate shows and focuses window when previous view is docked',
      () async {
        final appConfig = _StubAppConfigCubit(
          AppConfig(view: AppView.leftDocked, pinned: false),
        );
        final monetization = _StubMonetizationCubit(
          const MonetizationState.unknown(),
        );

        final cubit = PasteStackCubit(
          appConfig,
          windowAction,
          monetization,
          offline,
        );
        await cubit.activate();

        expect(windowAction.showPasteStackViewCalls, 0);
        expect(windowAction.showCalls, 1);
        expect(windowAction.focusCalls, 1);

        await cubit.close();
      },
    );

    test(
      'activate waits for show and focus completion when previous view is not windowed',
      () async {
        final appConfig = _StubAppConfigCubit(
          AppConfig(view: AppView.leftDocked, pinned: false),
        );
        final monetization = _StubMonetizationCubit(
          const MonetizationState.unknown(),
        );
        windowAction.showDelay = const Duration(milliseconds: 20);
        windowAction.focusDelay = const Duration(milliseconds: 20);

        final cubit = PasteStackCubit(
          appConfig,
          windowAction,
          monetization,
          offline,
        );
        await cubit.activate();

        expect(windowAction.showCompleted, isTrue);
        expect(windowAction.focusCompleted, isTrue);

        await cubit.close();
      },
    );

    test(
      'deactivate clears background mode and restores always-on-top with pinned value',
      () async {
        final appConfig = _StubAppConfigCubit(
          AppConfig(view: AppView.windowed, pinned: true),
        );
        final monetization = _StubMonetizationCubit(
          const MonetizationState.unknown(),
        );

        final cubit = PasteStackCubit(
          appConfig,
          windowAction,
          monetization,
          offline,
        );
        await cubit.activate();
        await cubit.deactivate();

        expect(windowAction.clearBackgroundToggleCalls, 1);
        expect(windowAction.changeViewCalls, 1);
        expect(windowAction.changedView, AppView.windowed);
        expect(windowAction.alwaysOnTopCalls, 1);
        expect(windowAction.alwaysOnTopValue, isTrue);

        await cubit.close();
      },
    );

    test('pushItems keeps only cacheable and unencrypted items', () async {
      final appConfig = _StubAppConfigCubit(AppConfig(view: AppView.windowed));
      final monetization = _StubMonetizationCubit(
        MonetizationState.active(subscription: _subscription()),
      );

      final cubit = PasteStackCubit(
        appConfig,
        windowAction,
        monetization,
        offline,
      );

      final valid = _textItem('A');
      final encrypted = _textItem('B').copyWith(encrypted: true);
      final outOfCache = ClipboardItem.fromFile(
        '/tmp/file.txt',
        userId: 'u1',
      ).copyWith(localPath: null);

      cubit.pushItems([valid, encrypted, outOfCache]);

      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.text, 'A');

      await cubit.close();
    });
  });
}
