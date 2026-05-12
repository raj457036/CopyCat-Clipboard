import "dart:async";

import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import "package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart";
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import "package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart";
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import "package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart";
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart'
    show SelectedClipsCubit;
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import "package:clipboard/base/constants/strings/route_constants.dart";
import "package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart";
import "package:clipboard/base/domain/model/route_payload.dart";
import "package:clipboard/di/di.dart";
import "package:clipboard/pages/account/page.dart";
import "package:clipboard/pages/collection_selection/page.dart";
import "package:clipboard/pages/collections/page.dart";
import "package:clipboard/pages/collections/pages/create_edit/page.dart";
import "package:clipboard/pages/collections/pages/details/clip_collection_provider.dart";
import "package:clipboard/pages/collections/pages/details/page.dart";
import "package:clipboard/pages/create_clip_note/page.dart";
import "package:clipboard/pages/drive_setup/page.dart";
import "package:clipboard/pages/home/page.dart";
import "package:clipboard/pages/layout/shell_layout_page.dart";
import "package:clipboard/pages/login/page.dart";
import "package:clipboard/pages/not_found_page.dart";
import "package:clipboard/pages/onboard/page.dart";
import "package:clipboard/pages/paste_stack/page.dart";
import "package:clipboard/pages/paste_stack/paste_stack_coordinator.dart";
import "package:clipboard/pages/preview/page.dart";
import "package:clipboard/pages/reset_password/page.dart";
import "package:clipboard/pages/settings/page.dart";
import "package:clipboard/pages/settings/pages/android_bg_clipboard/android_bg_clipboard_settings.dart";
import "package:clipboard/pages/settings/pages/backup_restore/page.dart";
import "package:clipboard/pages/settings/pages/custom_exclusion_rule/custom_exclusion_rule.dart";
import "package:clipboard/pages/settings/pages/decrypt_clips.dart";
import "package:clipboard/pages/settings/pages/exclusion_rules.dart";
import "package:clipboard/pages/splash_page.dart";
import "package:clipboard/widgets/event_bridge.dart";
import "package:clipboard/widgets/listeners/monetization_listener.dart";
import "package:clipboard/widgets/page_route/dynamic_page_route.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import 'package:universal_io/io.dart';

final GlobalKey<NavigatorState> rootNavigationKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  // observers: observers,
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigationKey,
  // initialLocation: "/",
  errorBuilder: (context, state) {
    return const NotFoundPage();
  },
  routes: [
    GoRoute(
      name: RouteConstants.splash,
      path: "/",
      builder: (context, state) => SplashPage(key: state.pageKey),
    ),
    GoRoute(
      name: RouteConstants.login,
      path: '/login',
      builder: (context, state) => LoginPage(key: state.pageKey),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MonetizationCubit>(create: (context) => sl()),
            BlocProvider<PasteStackCubit>(
              create: (context) => PasteStackCubit(
                context.read<AppConfigCubit>(),
                context.read<WindowActionCubit>(),
                context.read<MonetizationCubit>(),
              ),
            ),
            BlocProvider<SyncStatusCubit>(
              create: (context) => sl()..syncAll(const SyncAllParams()),
            ),
            BlocProvider<OfflinePersistenceCubit>(
              create: (context) => sl()..startListeners(),
              lazy: false,
            ),
            BlocProvider<CloudPersistanceCubit>(create: (context) => sl()),
            BlocProvider<ClipCollectionCubit>(
              create: (context) => sl()..fetch(),
            ),
            BlocProvider<DriveSetupCubit>(create: (context) => sl()..fetch()),
            BlocProvider<EventBusCubit>(create: (context) => sl()),
            BlocProvider<SelectedClipsCubit>(create: (context) => sl()),
            BlocProvider<ClipboardCubit>(
              lazy: false,
              create: (context) => sl()..fetch(),
            ),
            if (Platform.isAndroid)
              BlocProvider<AndroidBgClipboardCubit>(
                lazy: false,
                create: (context) => sl()..syncStates(),
              ),
          ],
          child: EventBridge(
            eventBus: sl(),
            child: MonetizationListener(appConfigCubit: sl(), child: child),
          ),
        );
      },
      routes: [
        GoRoute(
          name: RouteConstants.onboard,
          path: '/onboard',
          builder: (context, state) =>
              OnBoardPage(key: state.pageKey, startingStep: 0),
        ),
        GoRoute(
          name: RouteConstants.preview,
          path: "/preview/:id",
          redirect: idPresentOrRedirect,
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters["id"]!);
            final item = context.read<OfflinePersistenceCubit>().getItem(
              id: id,
            );
            return DynamicPage(
              key: state.pageKey,
              fullScreenDialog: false,
              nonMobilePresentation: NonMobilePresentation.endSheet,
              closeOnSpace: true,
              child: FutureBuilder(
                future: item,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ClipboardItemPreviewPage(item: snapshot.data);
                },
              ),
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) {
            return ShellPage(child: child);
          },
          routes: [
            GoRoute(
              name: RouteConstants.home,
              path: "/home",
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const HomePage(),
                );
              },
            ),
            GoRoute(
              name: RouteConstants.pasteStack,
              path: "/paste-stack",
              pageBuilder: (context, state) {
                final payload = state.extra as RoutePayload?;
                final items = payload?.get<List<ClipboardItem>>();

                return NoTransitionPage(
                  key: state.pageKey,
                  child: PasteStackCoordinator(
                    initialItems: items,
                    builder: (context, state) {
                      final count = state.items.length;
                      return PasteStackPage(count: count);
                    },
                  ),
                );
              },
            ),
            GoRoute(
              name: RouteConstants.collections,
              path: '/collections',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const CollectionsPage(),
              ),
              routes: [
                GoRoute(
                  name: RouteConstants.collectionDetail,
                  path: ":id",
                  redirect: idPresentOrRedirect,
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters["id"]!);

                    return ClipCollectionProvider(
                      collectionId: id,
                      builder: (context, collection) => CollectionDetailPage(
                        key: state.pageKey,
                        collection: collection,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteConstants.settings,
              path: '/settings',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const SettingsPage(),
              ),
              routes: [
                GoRoute(
                  name: RouteConstants.androidBgClipboardSettings,
                  path: "android-bg-clipboard",
                  builder: (context, state) => AndroidBgClipboardSettings(
                    key: state.pageKey,
                    bgService: sl(),
                    deviceId: sl(instanceName: "device_id"),
                  ),
                ),
                GoRoute(
                  name: RouteConstants.exclusionRules,
                  path: "exclusion-rules",
                  builder: (context, state) =>
                      ExclusionRulesPage(key: state.pageKey),
                  routes: [
                    GoRoute(
                      name: RouteConstants.customExclusionRules,
                      path: "custom",
                      builder: (context, state) =>
                          CustomExclusionRulePage(key: state.pageKey),
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteConstants.driveConnect,
                  path: 'drive-connect/:code',
                  builder: (context, state) {
                    final code = state.pathParameters["code"]!;
                    final scopes = state.uri.queryParameters["scopes"]!.split(
                      " ",
                    );
                    context.read<DriveSetupCubit>().verifyAuthCodeAndSetup(
                      code,
                      scopes,
                    );
                    return DriveSetupPage(key: state.pageKey);
                  },
                ),
                GoRoute(
                  name: RouteConstants.resetPassword,
                  path: 'reset-password',
                  builder: (context, state) {
                    return ResetPasswordPage(key: state.pageKey);
                  },
                ),
                GoRoute(
                  name: RouteConstants.accountDetails,
                  path: 'account-details',
                  builder: (context, state) {
                    return AccountPage(key: state.pageKey);
                  },
                ),
                GoRoute(
                  name: RouteConstants.rebuildDatabase,
                  path: 'rebuild-database',
                  builder: (context, state) {
                    return DecryptClipsPage(
                      key: state.pageKey,
                      clipboardRepository: sl(instanceName: "local"),
                    );
                  },
                ),
                GoRoute(
                  name: RouteConstants.backupRestore,
                  path: 'backup-restore',
                  builder: (context, state) {
                    return BackupRestorePage(key: state.pageKey);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: RouteConstants.createClipNote,
          path: "/create-clip-note",
          pageBuilder: (context, state) {
            final id = int.tryParse(state.uri.queryParameters["id"] ?? "");
            final item = id == null
                ? null
                : context.read<OfflinePersistenceCubit>().getItem(id: id);
            return DynamicPage(
              key: state.pageKey,
              fullScreenDialog: false,
              nonMobilePresentation: NonMobilePresentation.endSheet,
              closeOnSpace: true,
              child: item != null
                  ? FutureBuilder(
                      future: item,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CreateClipNotePage(item: snapshot.data);
                      },
                    )
                  : const CreateClipNotePage(),
            );
          },
        ),
        GoRoute(
          name: RouteConstants.clipCollectionSelection,
          path: "/select-collection",
          pageBuilder: (context, state) {
            final id = int.tryParse(state.uri.queryParameters["id"] ?? "");

            return DynamicPage(
              key: state.pageKey,
              fullScreenDialog: false,
              nonMobilePresentation: NonMobilePresentation.endSheet,
              closeOnSpace: true,
              child: ClipCollectionSelectionPage(selectedCollectionId: id),
            );
          },
        ),
        GoRoute(
          name: RouteConstants.createEditCollection,
          path: '/write-collection/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters["id"] ?? "new";
            final collection = id == "new"
                ? null
                : context.read<ClipCollectionCubit>().get(int.parse(id));
            return DynamicPage(
              key: state.pageKey,
              fullScreenDialog: false,
              nonMobilePresentation: NonMobilePresentation.endSheet,
              closeOnSpace: true,
              child: collection == null
                  ? const ClipCollectionCreateEditPage()
                  : FutureBuilder(
                      future: collection,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ClipCollectionCreateEditPage(
                          collection: snapshot.data,
                        );
                      },
                    ),
            );
          },
        ),
      ],
    ),
  ],
);

FutureOr<String?> idPresentOrRedirect(
  BuildContext context,
  state, [
  String? validValue,
]) {
  final id = state.pathParameters["id"];

  if (validValue != null && id == validValue) return null;

  final id_ = int.tryParse(id ?? "");
  if (id_ == null) {
    return "/not-found";
  }
  return null;
}
