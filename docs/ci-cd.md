# CI/CD Setup

- CI workflow: `.github/workflows/ci.yml`
- Release workflow: `.github/workflows/release.yml`

## What each workflow does

### CI (`ci.yml`)
- Runs on pull requests and pushes to main branches.
- Runs format check, static analysis, and tests.

### Release (`release.yml`)
- Runs on tags like `v1.2.3` and manual dispatch.
- Builds release artifacts for all platforms:
  - Android (`.aab` and `.apk`)
  - iOS (`.ipa`, no-code-sign)
  - macOS (`.app.zip`)
  - Linux (`.tar.gz` bundle)
  - Windows (`.zip`)
- Publishes all artifacts into a GitHub Release.
- Adds `SHA256SUMS.txt` for integrity checks.
- Optionally deploys Android to Google Play.
- Optionally deploys iOS to TestFlight.

## Required GitHub repository secrets

Set these in GitHub: Settings > Secrets and variables > Actions.

### Required for all release builds
- `PROD_DART_DEFINES_JSON`
  - Raw JSON content that should be written to `local/prod.json`.

### Required for Android signing
- `ANDROID_KEYSTORE_BASE64`
  - Base64-encoded keystore file content.
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`
- `ANDROID_STORE_PASSWORD`

### Required for Google Play deployment
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
  - Full JSON content for a Google Play service account with release permissions.

### Required for Apple/TestFlight deployment
- `APPLE_CERTIFICATE_P12_BASE64`
  - Base64-encoded iOS distribution certificate (`.p12`).
- `APPLE_CERTIFICATE_PASSWORD`
- `APPLE_PROVISIONING_PROFILE_BASE64`
  - Base64-encoded provisioning profile (`.mobileprovision`).
- `APPLE_KEYCHAIN_PASSWORD`
  - Temporary CI keychain password.
- `APPLE_EXPORT_OPTIONS_PLIST_BASE64`
  - Base64-encoded `ExportOptions.plist` for `flutter build ipa`.
- `APPSTORE_CONNECT_API_KEY_BASE64`
  - Base64-encoded App Store Connect API key (`.p8`).
- `APPSTORE_CONNECT_API_KEY_ID`
- `APPSTORE_CONNECT_ISSUER_ID`

## How to create `ANDROID_KEYSTORE_BASE64`

Run this locally and copy the output into the secret:

```bash
base64 -i path/to/your-upload-keystore.jks | tr -d '\n'
```

## Triggering releases

### Tag-based release (recommended)

```bash
git tag v1.2.3
git push origin v1.2.3
```

### Manual release
- Open Actions in GitHub.
- Run workflow `Release Build All Platforms`.
- Provide:
  - `release_tag` (example: `v1.2.3`)
  - `prerelease` (`true` or `false`)
  - `deploy_android` (`true` or `false`)
  - `deploy_apple` (`true` or `false`)
  - `google_play_track` (`internal`, `alpha`, `beta`, `production`)

## Notes

- Artifact build job still creates an unsigned iOS IPA for GitHub Release assets.
- TestFlight deployment uses a dedicated signed iOS build job.
- On tag pushes, store deploy jobs run automatically if secrets are configured.
- On manual runs, store deploy jobs only run when `deploy_android` or `deploy_apple` is set to `true`.
- The workflows rely on Flutter stable channel from `subosito/flutter-action`.
