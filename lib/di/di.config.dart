// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:android_background_clipboard/android_background_clipboard.dart'
    as _i565;
import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart'
    as _i643;
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart'
    as _i542;
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart' as _i29;
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart'
    as _i620;
import 'package:clipboard/base/bloc/clip_sync_manager_cubit/clip_sync_manager_cubit.dart'
    as _i624;
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart'
    as _i489;
import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart'
    as _i283;
import 'package:clipboard/base/bloc/collection_clips_cubit/collection_clips_cubit.dart'
    as _i46;
import 'package:clipboard/base/bloc/collection_sync_manager_cubit/collection_sync_manager_cubit.dart'
    as _i362;
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart'
    as _i521;
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart'
    as _i588;
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart'
    as _i246;
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart'
    as _i706;
import 'package:clipboard/base/bloc/realtime_clip_sync_cubit/realtime_clip_sync_cubit.dart'
    as _i654;
import 'package:clipboard/base/bloc/realtime_collection_sync_cubit/realtime_collection_sync_cubit.dart'
    as _i557;
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart'
    as _i653;
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart'
    as _i657;
import 'package:clipboard/base/data/repositories/analytics.dart' as _i202;
import 'package:clipboard/base/data/repositories/app_config.dart' as _i655;
import 'package:clipboard/base/data/repositories/auth.dart' as _i346;
import 'package:clipboard/base/data/repositories/clip_collection.dart' as _i432;
import 'package:clipboard/base/data/repositories/clipboard.dart' as _i378;
import 'package:clipboard/base/data/repositories/drive_credential.dart'
    as _i477;
import 'package:clipboard/base/data/repositories/restoration_status.dart'
    as _i970;
import 'package:clipboard/base/data/repositories/subscription.dart' as _i623;
import 'package:clipboard/base/data/repositories/sync_clipboard.dart' as _i223;
import 'package:clipboard/base/data/services/clipboard_service.dart' as _i63;
import 'package:clipboard/base/data/services/cross_sync_listener.dart' as _i95;
import 'package:clipboard/base/data/services/google_drive_service.dart'
    as _i1025;
import 'package:clipboard/base/data/services/google_services.dart' as _i679;
import 'package:clipboard/base/data/sources/clip_collection/local_source.dart'
    as _i173;
import 'package:clipboard/base/data/sources/clip_collection/remote_source.dart'
    as _i899;
import 'package:clipboard/base/data/sources/clipboard/local_source.dart'
    as _i730;
import 'package:clipboard/base/data/sources/clipboard/remote_source.dart'
    as _i411;
import 'package:clipboard/base/data/sources/restoration_status/local_source.dart'
    as _i364;
import 'package:clipboard/base/data/sources/subscription/remote_source.dart'
    as _i35;
import 'package:clipboard/base/data/sources/sync_clipboard/remote_source.dart'
    as _i425;
import 'package:clipboard/base/db/clip_collection/clipcollection.dart' as _i789;
import 'package:clipboard/base/domain/repositories/analytics.dart' as _i707;
import 'package:clipboard/base/domain/repositories/app_config.dart' as _i891;
import 'package:clipboard/base/domain/repositories/auth.dart' as _i579;
import 'package:clipboard/base/domain/repositories/clip_collection.dart'
    as _i276;
import 'package:clipboard/base/domain/repositories/clipboard.dart' as _i230;
import 'package:clipboard/base/domain/repositories/drive_credential.dart'
    as _i460;
import 'package:clipboard/base/domain/repositories/restoration_status.dart'
    as _i1069;
import 'package:clipboard/base/domain/repositories/subscription.dart' as _i956;
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart' as _i61;
import 'package:clipboard/base/domain/services/cross_sync_listener.dart'
    as _i543;
import 'package:clipboard/base/domain/sources/clip_collection.dart' as _i670;
import 'package:clipboard/base/domain/sources/clipboard.dart' as _i23;
import 'package:clipboard/base/domain/sources/restoration_status.dart' as _i922;
import 'package:clipboard/base/domain/sources/subscription.dart' as _i422;
import 'package:clipboard/base/domain/sources/sync_clipboard.dart' as _i782;
import 'package:clipboard/di/modules.dart' as _i234;
import 'package:focus_window/focus_window.dart' as _i291;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:isar_community/isar.dart' as _i214;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;
import 'package:tiny_storage/tiny_storage.dart' as _i829;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i655.PackageInfo>(
      () => registerModule.packageInfo,
      preResolve: true,
    );
    gh.factory<_i653.SelectedClipsCubit>(() => _i653.SelectedClipsCubit());
    gh.factory<_i657.WindowActionCubit>(() => _i657.WindowActionCubit());
    gh.singleton<_i291.FocusWindow>(() => registerModule.focusWindow);
    await gh.singletonAsync<_i829.TinyStorage>(
      () => registerModule.localCache(),
      preResolve: true,
    );
    gh.singleton<_i63.ClipboardService>(() => _i63.ClipboardService());
    gh.singleton<_i588.EventBusCubit>(() => _i588.EventBusCubit());
    await gh.lazySingletonAsync<_i214.Isar>(
      () => registerModule.db,
      preResolve: true,
      dispose: _i234.closeIsarDb,
    );
    gh.lazySingleton<_i565.AndroidBackgroundClipboard>(
        () => registerModule.bgService);
    gh.lazySingleton<_i1025.GoogleOAuth2Service>(
        () => _i1025.GoogleOAuth2Service());
    gh.lazySingleton<_i707.AnalyticsRepository>(
        () => const _i202.AnalyticsRepositoryImpl());
    gh.factory<String>(
      () => registerModule.supabaseProjectKey,
      instanceName: 'supabase_project_key',
    );
    gh.lazySingleton<_i679.DriveService>(
      () => _i1025.GoogleDriveService(),
      instanceName: 'google_drive',
    );
    gh.factory<String>(
      () => registerModule.supabaseUrl,
      instanceName: 'supabase_url',
    );
    gh.lazySingleton<_i922.RestorationStatusSource>(
        () => _i364.RestorationStatusSourceImpl(db: gh<_i214.Isar>()));
    gh.factory<String>(
      () => registerModule.supabaseKey,
      instanceName: 'supabase_key',
    );
    gh.lazySingleton<_i891.AppConfigRepository>(
        () => _i655.AppConfigRepositoryImpl(gh<_i214.Isar>()));
    await gh.factoryAsync<String>(
      () => registerModule.deviceId(gh<_i829.TinyStorage>()),
      instanceName: 'device_id',
      preResolve: true,
    );
    await gh.singletonAsync<_i454.SupabaseClient>(
      () => registerModule.client(
        gh<String>(instanceName: 'supabase_url'),
        gh<String>(instanceName: 'supabase_key'),
      ),
      preResolve: true,
    );
    gh.lazySingleton<_i1069.RestorationStatusRepository>(() =>
        _i970.RestorationStatusRepositoryImpl(
            gh<_i922.RestorationStatusSource>()));
    gh.lazySingleton<_i543.ClipCrossSyncListener>(
        () => _i95.SBClipCrossSyncListener(
              gh<_i454.SupabaseClient>(),
              gh<String>(instanceName: 'device_id'),
            ));
    gh.lazySingleton<_i23.ClipboardSource>(
      () => _i730.LocalClipboardSource(
        gh<_i214.Isar>(),
        gh<String>(instanceName: 'device_id'),
      ),
      instanceName: 'local',
    );
    gh.lazySingleton<_i670.ClipCollectionSource>(
      () => _i899.RemoteClipCollectionSource(gh<_i454.SupabaseClient>()),
      instanceName: 'remote',
    );
    gh.lazySingleton<_i579.AuthRepository>(
        () => _i346.AuthRepositoryImpl(client: gh<_i454.SupabaseClient>()));
    gh.singleton<_i542.AppConfigCubit>(
        () => _i542.AppConfigCubit(gh<_i891.AppConfigRepository>()));
    gh.lazySingleton<_i543.CollectionCrossSyncListener>(
        () => _i95.SBCollectionCrossSyncListener(
              gh<_i454.SupabaseClient>(),
              gh<String>(instanceName: 'device_id'),
            ));
    gh.lazySingleton<_i670.ClipCollectionSource>(
      () => _i173.LocalClipCollectionSource(
        gh<_i214.Isar>(),
        gh<String>(instanceName: 'device_id'),
      ),
      instanceName: 'local',
    );
    gh.lazySingleton<_i460.DriveCredentialRepository>(
        () => _i477.DriveCredentialRepositoryImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i422.SubscriptionSource>(
      () => _i35.RemoteSubscriptionSource(client: gh<_i454.SupabaseClient>()),
      instanceName: 'remote',
    );
    gh.lazySingleton<_i276.ClipCollectionRepository>(
        () => _i432.ClipCollectionRepositoryImpl(
              gh<_i670.ClipCollectionSource>(instanceName: 'remote'),
              gh<_i670.ClipCollectionSource>(instanceName: 'local'),
            ));
    gh.lazySingleton<_i23.ClipboardSource>(
      () => _i411.RemoteClipboardSource(gh<_i454.SupabaseClient>()),
      instanceName: 'remote',
    );
    gh.lazySingleton<_i782.SyncClipboardSource>(
      () => _i425.SyncClipboardSourceImpl(gh<_i454.SupabaseClient>()),
      instanceName: 'remote',
    );
    gh.lazySingleton<_i230.ClipboardRepository>(
      () => _i378.ClipboardRepositoryOfflineImpl(
          gh<_i23.ClipboardSource>(instanceName: 'local')),
      instanceName: 'local',
    );
    gh.lazySingleton<_i521.DriveSetupCubit>(() => _i521.DriveSetupCubit(
          gh<_i460.DriveCredentialRepository>(),
          gh<_i679.DriveService>(instanceName: 'google_drive'),
        ));
    gh.lazySingleton<_i230.ClipboardRepository>(
      () => _i378.ClipboardRepositoryCloudImpl(
          gh<_i23.ClipboardSource>(instanceName: 'remote')),
      instanceName: 'remote',
    );
    gh.factory<_i489.ClipboardCubit>(() => _i489.ClipboardCubit(
          gh<_i588.EventBusCubit>(),
          gh<_i230.ClipboardRepository>(instanceName: 'local'),
        ));
    gh.singleton<_i29.AuthCubit>(() => _i29.AuthCubit(
          gh<_i579.AuthRepository>(),
          gh<_i829.TinyStorage>(),
          gh<_i707.AnalyticsRepository>(),
        ));
    gh.lazySingleton<_i283.CloudPersistanceCubit>(
        () => _i283.CloudPersistanceCubit(
              gh<_i29.AuthCubit>(),
              gh<_i521.DriveSetupCubit>(),
              gh<_i542.AppConfigCubit>(),
              gh<String>(instanceName: 'device_id'),
              gh<_i230.ClipboardRepository>(instanceName: 'remote'),
            ));
    gh.lazySingleton<_i61.SyncRepository>(() => _i223.SyncRepositoryImpl(
        gh<_i782.SyncClipboardSource>(instanceName: 'remote')));
    gh.lazySingleton<_i706.OfflinePersistenceCubit>(
        () => _i706.OfflinePersistenceCubit(
              gh<_i29.AuthCubit>(),
              gh<_i230.ClipboardRepository>(instanceName: 'local'),
              gh<_i63.ClipboardService>(),
              gh<_i542.AppConfigCubit>(),
              gh<_i707.AnalyticsRepository>(),
              gh<String>(instanceName: 'device_id'),
            ));
    gh.lazySingleton<_i956.SubscriptionRepository>(() =>
        _i623.SubscriptionRepositoryImpl(
            remote: gh<_i422.SubscriptionSource>(instanceName: 'remote')));
    gh.factory<_i557.RealtimeCollectionSyncCubit>(
        () => _i557.RealtimeCollectionSyncCubit(
              gh<_i588.EventBusCubit>(),
              gh<_i543.CollectionCrossSyncListener>(),
              gh<_i276.ClipCollectionRepository>(),
            ));
    gh.factory<_i654.RealtimeClipSyncCubit>(() => _i654.RealtimeClipSyncCubit(
          gh<_i543.ClipCrossSyncListener>(),
          gh<_i588.EventBusCubit>(),
          gh<_i230.ClipboardRepository>(instanceName: 'local'),
          gh<_i276.ClipCollectionRepository>(),
        ));
    gh.singleton<_i246.MonetizationCubit>(() =>
        _i246.MonetizationCubit(repo: gh<_i956.SubscriptionRepository>()));
    gh.factory<_i643.AndroidBgClipboardCubit>(
        () => _i643.AndroidBgClipboardCubit(
              gh<_i565.AndroidBackgroundClipboard>(),
              gh<_i588.EventBusCubit>(),
              gh<_i230.ClipboardRepository>(instanceName: 'local'),
              gh<String>(instanceName: 'device_id'),
            ));
    gh.factoryParam<_i46.CollectionClipsCubit, _i789.ClipCollection, dynamic>((
      collection,
      _,
    ) =>
        _i46.CollectionClipsCubit(
          gh<_i588.EventBusCubit>(),
          gh<_i230.ClipboardRepository>(instanceName: 'local'),
          collection: collection,
        ));
    gh.lazySingleton<_i620.ClipCollectionCubit>(() => _i620.ClipCollectionCubit(
          gh<_i588.EventBusCubit>(),
          gh<_i29.AuthCubit>(),
          gh<_i276.ClipCollectionRepository>(),
          gh<String>(instanceName: 'device_id'),
        ));
    gh.factory<_i624.ClipSyncManagerCubit>(() => _i624.ClipSyncManagerCubit(
          gh<_i588.EventBusCubit>(),
          gh<_i61.SyncRepository>(),
          gh<_i620.ClipCollectionCubit>(),
          gh<_i230.ClipboardRepository>(instanceName: 'local'),
          gh<_i276.ClipCollectionRepository>(),
          gh<String>(instanceName: 'device_id'),
        ));
    gh.factory<_i362.CollectionSyncManagerCubit>(
        () => _i362.CollectionSyncManagerCubit(
              gh<_i588.EventBusCubit>(),
              gh<_i61.SyncRepository>(),
              gh<_i620.ClipCollectionCubit>(),
              gh<_i276.ClipCollectionRepository>(),
              gh<String>(instanceName: 'device_id'),
            ));
    return this;
  }
}

class _$RegisterModule extends _i234.RegisterModule {}
