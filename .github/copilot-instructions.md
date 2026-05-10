## Start Here

- Read [README.md](../README.md) for product context and [ChangeLog.md](../ChangeLog.md) for recent feature history. Keep this file focused on agent-only guidance.
- Start architecture tracing in [lib/main.dart](../lib/main.dart), [lib/routes/routes.dart](../lib/routes/routes.dart), and [lib/widgets/state_initializer.dart](../lib/widgets/state_initializer.dart). Those files control startup, navigation, and cross-platform lifecycle side effects.
- The workspace contains app code in `lib/`, local plugins in `packages/`, release automation in [scripts/](../scripts), and Supabase assets in [supabase/](../supabase). Stay inside the owning layer instead of adding cross-cutting logic from UI code.

## Build And Validation

- Use the narrowest useful validation first: `flutter analyze`, targeted `flutter test`, then broader app runs only when the change needs runtime verification.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after editing anything annotated with `@freezed`, `@JsonSerializable`, `@Injectable`/`@LazySingleton`, or Isar collections. [\_build.yaml](../_build.yaml) forces `freezed` to run before the Isar generator.
- Run `flutter gen-l10n` after changing `.arb` files or localization-facing code. The authoritative config lives in [l10n.yaml](../l10n.yaml).
- App runs and release builds expect `--dart-define-from-file=local/dev.json` or `local/prod.json`. Those files are environment-specific; do not assume they exist or contain usable secrets.
- Release preparation is scripted through [scripts/prepare_for_build.sh](../scripts/prepare_for_build.sh) and the platform wrappers in [scripts/](../scripts). Use those instead of inventing new build flags.
- Supabase local function work should follow [supabase/scripts.txt](../supabase/scripts.txt).

## Architecture

- [lib/main.dart](../lib/main.dart) bootstraps services, calls `configureDependencies()`, and wires the `MultiBlocProvider` around `AppContent`. Theme, locale, and window changes should flow through `AppConfigCubit` rather than direct platform calls.
- Navigation lives in [lib/routes/routes.dart](../lib/routes/routes.dart) using `go_router`, a `ShellRoute` for the main layout, and modal `DynamicPage` wrappers. New pages should be added there with the surrounding `BlocProvider` dependencies.
- `lib/base` is layered: `domain/model/` for persisted Freezed and Isar-backed models, `domain/repositories` and `domain/sources` for interfaces, `data/` for implementations and services, and `bloc/` for cubits. Mirror that structure for new features.
- Platform-specific behavior is intentionally wrapped in `lib/widgets` and `packages/`. Extend `EventBridge`, `WindowFocusManager`, `TrayManager`, `SystemShortcutListeners`, or the local packages before reaching for new platform channels.

## Data, Sync, And State

- Clipboard items in [lib/base/domain/model/clipboard_item/clipboard_item.dart](../lib/base/domain/model/clipboard_item/clipboard_item.dart) manage encryption, file clean-up, and sync metadata. Preserve persisted Isar IDs with `copyWith(..)..applyId(original)` when mutating stored items.
- App preferences live in [lib/base/domain/model/app_config/appconfig.dart](../lib/base/domain/model/app_config/appconfig.dart) and should be changed through `AppConfigCubit` helpers instead of direct Isar writes.
- Most async flows return `FailureOr<T>` from [lib/common/failure.dart](../lib/common/failure.dart). Handle them with `result.fold(...)` and normalize new failures with `Failure.fromException(...)`.
- Local clipboard queries belong in `lib/base/data/sources/clipboard/local_source.dart`; reuse the existing Isar query builders for filters, encryption state, and pagination instead of re-querying elsewhere.
- Supabase remote CRUD and realtime listeners live under `lib/base/data/sources/**/remote_source.dart`. Preserve the existing `deviceId` exclusion when changing cross-device sync so local updates do not echo back.
- Google Drive attachment sync lives in [lib/base/data/services/file_cloud_services/google_drive/google_drive_service.dart](../lib/base/data/services/file_cloud_services/google_drive/google_drive_service.dart). Updates must set `driveFileId`, leave cleanup to `ClipboardItem.cleanUp`, and release background workers with `syncDone` or `cancelOperation`.

## Conventions And Pitfalls

- Register services with `@LazySingleton` or `@Injectable` and resolve them through `sl()`. Avoid manual `GetIt` lookups from widgets.
- BLoC and cubit state uses Freezed partials. Keep business logic in cubits, update with `emit(state.copyWith(...))`, and do not move domain logic into views.
- Reuse helpers from `lib/utils/common_extension.dart` and `lib/utils/utility.dart` such as `context.colors` and `keyboardShortcut` to keep desktop and mobile behavior aligned.
- Never hand-edit generated files under `**/*.g.dart`, `**/*.freezed.dart`, or `**/generated/*.dart`. [analysis_options.yaml](../analysis_options.yaml) excludes them from analysis for a reason.
- [watch_locale.dart](../watch_locale.dart) still points at an old `packages/copycat_base` path. Treat it as stale until that script is fixed; run `flutter gen-l10n` directly when you need reliable localization generation.
- Linux desktop work may require the packages listed in [notes.txt](../notes.txt) for hotkeys and tray support.
- `pubspec.yaml` pins `isar_community` and `isar_community_flutter_libs` to the same `isar_version` anchor and overrides `connectivity_plus`. Keep those compatibility constraints intact unless the user asks for dependency upgrades.
