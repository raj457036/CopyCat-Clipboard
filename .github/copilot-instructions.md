## Architecture
- `lib/main.dart` bootstraps the app: initializes platform services, calls `configureDependencies()`, and wires the `MultiBlocProvider` that wraps the UI; start here to understand startup side-effects.
- `AppContent` (in `lib/main.dart`) drives theme/locale/window settings via `AppConfigCubit` and `StateInitializer`; changes to UI chrome should flow through this cubit rather than reaching into platform APIs directly.
- Navigation lives in `lib/routes/routes.dart` using `go_router` with a `ShellRoute` for the main layout and modal `DynamicPage` wrappers for dialogs; add new pages there and expose dependencies through the surrounding `BlocProvider`s.
- Desktop/mobile specific behavior is layered through widgets such as `EventBridge`, `WindowFocusManager`, and `TrayManager` in `lib/widgets`; hook platform-specific features by extending these wrappers instead of touching pages.

## Data & State
- `lib/base` is layered: `db/` holds Isar collections, `domain/` declares interfaces and Freezed models, `data/` supplies `@LazySingleton` repositories/sources; mirror this structure for new features.
- Clipboard items (`lib/base/db/clipboard_item/clipboard_item.dart`) manage encryption, file clean-up, and syncing; always call `copyWith(..)..applyId(original)` to preserve Isar IDs when mutating persisted items.
- App-level preferences live in `lib/base/db/app_config/appconfig.dart` and are surfaced through `AppConfigCubit`; rely on its helpers (`changePausedTill`, theme setters) instead of writing to Isar manually.
- Most async calls return `FailureOr<T>` (a `Future<Either<Failure, T>>` from `lib/common/failure.dart`); capture errors with `result.fold(...)` and construct new failures via `Failure.fromException` for consistency.

## Sync & Integrations
- Supabase drives remote CRUD in `lib/base/data/sources/**/remote_source.dart` and real-time updates via `SBClipCrossSyncListener` / `SBCollectionCrossSyncListener`; when adding filters, respect the existing `deviceId` exclusion to avoid echoing local changes.
- Local persistence (`lib/base/data/sources/clipboard/local_source.dart`) builds complex Isar queries for search, encryption filters, and pagination; reuse those builders rather than re-querying outside the source.
- File attachments sync through Google Drive (`lib/base/data/services/google_drive_service.dart`); updates must set `driveFileId`, defer cleanup to `ClipboardItem.cleanUp`, and invoke `syncDone`/`cancelOperation` to release background workers.
- Background services (hotkeys, Android clipboard listener, media kit) live under `lib/widgets/` and `packages/`; reuse these entry points instead of introducing new platform channels.

## Build & Tooling
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after editing anything annotated with `@freezed`, `@JsonSerializable`, `@injectable`, or Isar collections to regenerate `*.g.dart` files.
- Localization is configured via `l10n.yaml`; regenerate translations with `flutter gen-l10n` (the `watch_locale.dart` helper can auto-run it, but double-check the working directory before use).
- Use `flutter run --dart-define-from-file=local/prod.json` for feature testing so Supabase, RevenueCat, and Sentry keys resolve; release workflows are scripted under `scripts/build_*.sh` and expect the same defines plus obfuscation/split debug info.
- Supabase functions can be tested locally with `supabase functions serve --env-file supabase/.env.local --no-verify-jwt` as documented in `supabase/scripts.txt`.

## Conventions & Tips
- Register new services via `@LazySingleton`/`@Injectable` and access them through `sl()`; avoid manual `GetIt` lookups in widgets.
- BLoC states/events use Freezed partials (`part 'xyz.freezed.dart'`); update state with `emit(state.copyWith(...))` and keep logic inside cubits rather than views.
- UI code favors helpers from `lib/utils/common_extension.dart` and `lib/utils/utility.dart` (e.g., `context.colors`, `keyboardShortcut`); using them keeps desktop/mobile behavior aligned.
- Follow `analysis_options.yaml` and never edit generated outputs under `**/*.g.dart` or `**/*.freezed.dart`; rerun generation instead if changes are needed.
