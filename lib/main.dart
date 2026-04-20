import 'dart:async';

import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart'
    show SelectedClipsCubit;
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:clipboard/base/theme/app_theme.dart';
import 'package:clipboard/common/bloc_config.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/routes/routes.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/utils/windows/update_registry.dart';
import 'package:clipboard/widgets/debug/gizmo_overlay.dart';
import 'package:clipboard/widgets/event_bridge.dart';
import 'package:clipboard/widgets/keyboard_shortcuts/actions/select_all.dart';
import 'package:clipboard/widgets/state_initializer.dart';
import 'package:clipboard/widgets/system_shortcut_listeners.dart';
import 'package:clipboard/widgets/tray_manager.dart';
import 'package:clipboard/widgets/upgrader.dart';
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
// ignore: implementation_imports
import 'package:form_validator/src/i18n/all.dart' as fv_locale;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:universal_io/io.dart';
import 'package:upgrader/upgrader.dart';
import 'package:window_manager/window_manager.dart';

import 'widgets/keyboard_shortcuts/actions/actions.dart';

Future<void> appRunner() async {
  MediaKit.ensureInitialized();
  await initializeServices();
  runApp(const MainApp());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (sentryDSN != "" && !kDebugMode) {
    await SentryFlutter.init((options) {
      options.dsn = sentryDSN;
      options.environment = kDebugMode
          ? "Dev"
          : kProfileMode
          ? "Profile"
          : "Prod";
      options.tracesSampleRate = kDebugMode ? 0 : 0.05;
    }, appRunner: appRunner);
  } else {
    appRunner();
  }
}

Future<void> initializeServices() async {
  if (kDebugMode) {
    Bloc.observer = CustomBlocObserver();
    await Upgrader.clearSavedSettings();
  }
  if (isDesktopPlatform) {
    await initializeDesktopServices();
  } else {
    unawaited(MobileAds.instance.initialize());
  }

  await configureDependencies();
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('de', timeago.DeMessages());
  timeago.setLocaleMessages('zh', timeago.ZhCnMessages());
}

Future<void> initializeDesktopServices() async {
  await windowManager.ensureInitialized();
  await updateWindowsRegistry();

  if (kDebugMode) await hotKeyManager.unregisterAll();

  final packageInfo = await PackageInfo.fromPlatform();
  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
  );

  WindowOptions windowOptions = const WindowOptions(
    // size:  minimumWindowSize,
    // minimumSize: minimumWindowSize,
    // make sure to change it in main.cpp ( windows ) &
    // ? my_application.cc ( linux ) and other places too if changing the title.
    title: "CopyCat Clipboard",
    skipTaskbar: true,
    windowButtonVisibility: true,
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );
  unawaited(
    windowManager
        .waitUntilReadyToShow(windowOptions)
        .then((_) async => windowManager.hide()),
  );
}

void updateValidatorLanguage(String langCode) {
  final locale =
      fv_locale.supportedLocales.findFirst((l) => l.startsWith(langCode)) ??
      "en";
  ValidationBuilder.setLocale(locale);
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  SystemUiOverlayStyle getUiOverlay(ThemeMode mode) {
    var lightTheme =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light;
    return mode == ThemeMode.light || (mode == ThemeMode.system && lightTheme)
        ? const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarContrastEnforced: false,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonetizationCubit, MonetizationState>(
      listenWhen: (prev, current) {
        if (current is MonetizationActive && prev is MonetizationActive) {
          return !current.subscription.isSameAs(prev.subscription);
        }
        return true;
      },
      listener: (context, state) async {
        switch (state) {
          case MonetizationActive(:final subscription):
            {
              final appConfigCubit = context.read<AppConfigCubit>();
              appConfigCubit.load(subscription);
            }
        }
      },
      child: StateInitializer(
        child:
            BlocSelector<
              AppConfigCubit,
              AppConfigState,
              (ThemeMode, String, ColorScheme, ColorScheme, AppView)
            >(
              selector: (state) {
                return (
                  state.config.themeMode,
                  state.config.locale,
                  state.config.lightThemeColorScheme,
                  state.config.darkThemeColorScheme,
                  state.config.view,
                );
              },
              builder: (context, state) {
                final (
                  theme,
                  langCode,
                  lightColorScheme,
                  darkColorScheme,
                  view,
                ) = state;
                final surfaceColor = theme == ThemeMode.light
                    ? lightColorScheme.surface
                    : darkColorScheme.surface;
                final lightTheme = buildAppTheme(
                  colorScheme: lightColorScheme,
                  brightness: Brightness.light,
                );

                final darkTheme = buildAppTheme(
                  colorScheme: darkColorScheme,
                  brightness: Brightness.dark,
                );

                updateValidatorLanguage(langCode);
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: getUiOverlay(theme),
                  child: MaterialApp.router(
                    routerConfig: routeConfig,
                    scaffoldMessengerKey: scaffoldMessengerKey,
                    color: surfaceColor,
                    themeMode: theme,
                    shortcuts: {
                      ...WidgetsApp.defaultShortcuts,
                      NavigateToHomePageIntent.activator:
                          const NavigateToHomePageIntent(),
                      NavigateToCollectionPageIntent.activator:
                          const NavigateToCollectionPageIntent(),
                      FocusOnSearchFieldIntent.activator:
                          const FocusOnSearchFieldIntent(),
                      CreateNewClipNoteIntent.activator:
                          const CreateNewClipNoteIntent(),
                      SyncIntent.activator: const SyncIntent(),
                      PasteIntent.activator: const PasteIntent(),
                      DeleteItemIntent.activator: const DeleteItemIntent(),
                      if (isDesktopPlatform)
                        TogglePasteStackIntent.activator:
                            const TogglePasteStackIntent(),
                      if (view == AppView.windowed)
                        NavigateToSettingPageIntent.activator:
                            const NavigateToSettingPageIntent(),
                      if (isDesktopPlatform)
                        PopRouteIntent.activator: const PopRouteIntent(),
                      PasteByClipIndexIntent.i.activator:
                          PasteByClipIndexIntent.i,
                      SelectAllIntent.activator: const SelectAllIntent(),
                    },
                    actions: {
                      ...WidgetsApp.defaultActions,
                      NavigateToHomePageIntent: NavigateToHomePageAction(),
                      NavigateToCollectionPageIntent:
                          NavigateToCollectionPageAction(),
                      FocusOnSearchFieldIntent: FocusOnSearchFieldAction(),
                      SyncIntent: SyncAction(),
                      CreateNewClipNoteIntent: CreateNewClipNoteAction(),
                      PasteIntent: PasteAction(),
                      DeleteItemIntent: DeleteSelectedItemsAction(),
                      if (isDesktopPlatform)
                        TogglePasteStackIntent: TogglePasteStackAction(),
                      if (isDesktopPlatform) PopRouteIntent: HideWindowAction(),
                      if (view == AppView.windowed)
                        NavigateToSettingPageIntent:
                            NavigateToSettingPageAction(),
                      PasteByClipIndexIntent: PasteByClipIndexAction(),
                      SelectAllIntent: SelectAllAction(),
                    },
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    debugShowCheckedModeBanner: false,
                    locale: Locale(
                      langCode.isEmpty ? Platform.localeName : langCode,
                    ),
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    builder: (context, child) {
                      return UpgraderBuilder(child: child);
                    },
                  ),
                );
              },
            ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = EventBridge(
      eventBus: sl(),
      child: WindowFocusManager.forPlatform(
        child: TrayManager.forPlatform(
          child: const SystemShortcutListener(child: AppContent()),
        ),
      ),
    );
    final child = MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => sl()),
        BlocProvider<AppConfigCubit>(create: (context) => sl()..load()),
        BlocProvider<MonetizationCubit>(create: (context) => sl()),
        BlocProvider<SyncStatusCubit>(create: (context) => sl()),
        BlocProvider<OfflinePersistenceCubit>(create: (context) => sl()),
        BlocProvider<CloudPersistanceCubit>(create: (context) => sl()),
        BlocProvider<ClipCollectionCubit>(create: (context) => sl()),
        BlocProvider<DriveSetupCubit>(create: (context) => sl()),
        BlocProvider<WindowActionCubit>(create: (context) => sl()),
        BlocProvider<PasteStackCubit>(
          create: (context) => PasteStackCubit(
            context.read<AppConfigCubit>(),
            context.read<WindowActionCubit>(),
          ),
        ),
        BlocProvider<EventBusCubit>(create: (context) => sl()),
        BlocProvider<SelectedClipsCubit>(create: (context) => sl()),
        if (Platform.isAndroid)
          BlocProvider<AndroidBgClipboardCubit>(
            lazy: false,
            create: (context) {
              return sl()..syncStates();
            },
          ),
      ],
      child: isMobilePlatform
          ? GestureDetector(
              onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              child: content,
            )
          : content,
    );

    if (kDebugMode) {
      return GizmoOverlay(
        enabled: false,
        child: DevicePreview(
          enabled: false,
          tools: const [
            ...DevicePreview.defaultTools,
            DevicePreviewScreenshot(onScreenshot: screenshotAsFile),
          ],
          builder: (context) => child,
        ),
      );
    }
    return child;
  }
}
