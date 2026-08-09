## 0.5.5

- feat: Add Confirm Password Field to SupaEmailAuth Component for Sign-Up Process [#129](https://github.com/supabase-community/flutter-auth-ui/pull/129)
- feat: Add autofocus option to SupaEmailAuth [#139](https://github.com/supabase-community/flutter-auth-ui/pull/139)

## 0.5.4

- feat: Add autovalidation [#125](https://github.com/supabase-community/flutter-auth-ui/pull/125)
- fix: Remove hardcoded styling from checkboxes [#125](https://github.com/supabase-community/flutter-auth-ui/pull/125)

## 0.5.3

- feat: Add value property to BooleanMetaDataField to set initial state of checkbox [#120](https://github.com/supabase-community/flutter-auth-ui/pull/120)
- feat: add custom password validation to SupaEmailAuth form [#121](https://github.com/supabase-community/flutter-auth-ui/pull/121)

## 0.5.2

- feat: enhancement: allow user to decide launch mode [#110](https://github.com/supabase-community/flutter-auth-ui/pull/110)
- fix: MetadataFields text field values being lost in SupaEmailAuth widget (Fixes #113) [#114](https://github.com/supabase-community/flutter-auth-ui/pull/114)
- feat: Add BooleanMetaDataField to support checkbox inputs on sign-up form [#115](https://github.com/supabase-community/flutter-auth-ui/pull/115)
- feat: Support for displaying sign-in or sign-up initially [#116](https://github.com/supabase-community/flutter-auth-ui/pull/116)

## 0.5.1

- feat: Improve form interaction and code organization in `SupaEmailAuth` [#106](https://github.com/supabase-community/flutter-auth-ui/pull/106)
- feat: Enable custom icons for `SupaEmailAuth` [#108](https://github.com/supabase-community/flutter-auth-ui/pull/108)

## 0.5.0

- feat: Allow password recovery email to be redirected to other URL [#98](https://github.com/supabase-community/flutter-auth-ui/pull/98)
- feat: Add callback for internal state of `SupaEmailAuth` [#99](https://github.com/supabase-community/flutter-auth-ui/pull/99)
- feat!: Upgrade anonymous users to regular users automatically [#100](https://github.com/supabase-community/flutter-auth-ui/pull/100)
- feat!: Allow the OAuth provider labels to be overridden on `SupaSocialsAuth` [#101](https://github.com/supabase-community/flutter-auth-ui/pull/101)

## 0.4.4

- feat: Update minimum supabase_flutter version to v2.3.4
- fix: Add redirectTo for email password reset [#83](https://github.com/supabase-community/flutter-auth-ui/pull/83)
- feat: Add TextInputAction to phone and email sign in [#82](https://github.com/supabase-community/flutter-auth-ui/pull/82)
- fix: Fix autofill not opening when tapping on email field in SupaEmailAuth [#80](https://github.com/supabase-community/flutter-auth-ui/pull/80)

## 0.4.3

- feat: Add localization / text customization support for all components.
  ```dart
  // Use the `localization` parameter to customize the text of the UI components.
  SupaEmailAuth(
    localization: const SupaEmailAuthLocalization(
      enterEmail: 'What\'s your email?',
      enterPassword: 'Enter your password',
    ),
    onSignInComplete: _onSignInComplete,
    onSignUpComplete: _onSignUpComplete,
  ),
  ```

## 0.4.2

- feat: Add `nativeGoogleAuthConfig` and `enableNativeAppleAuth` parameter to `SupaSocialsAuth` to support native Google and Apple auth.

## 0.4.1

- feat: Add `extraMetadata` parameter to `SupaEmailAuth` to add headless signup user metadata.

## 0.4.0+1

- chore: Minor updates to readme.md

## 0.4.0

- BREAKING: Rename `twitter` to `x` for social provider and update branding.
- BREAKING: Remove `SocialProviders` enum in favor of `OAuthProvider` to align the public API with supabase_flutter.
- feat: Add missing social providers.
- chore: Update screenshot on readme.md.
- chore: Add screenshot for pub.dev.

## 0.3.0

- BREAKING: Update `supabase_flutter` to v2.0.1

## 0.2.1

- feat: Make `SupaSocialsAuth` success SnackBar optional [#54](https://github.com/supabase-community/flutter-auth-ui/pull/54)

## 0.2.0

- BREAKING: `SupaEmailAuth` now contains sign-up, sign-in, and forget email in a single instance [#46](https://github.com/supabase-community/flutter-auth-ui/pull/46)
- feat: update Dart dependency to < 4.0.0 and flutter dependencies to >=3.0.0

## 0.1.1

- feat: social aith buttons icon only option [#43](https://github.com/supabase-community/flutter-auth-ui/pull/43)
- feat: email suggestion on email form fields [#44](https://github.com/supabase-community/flutter-auth-ui/pull/44)

## 0.1.0+2

- fix: set splash color on colored social button to provide better UX for google auth button
- fix: use white instead of `onBackground` color for colored social button's foreground color to provide persistent design

## 0.1.0+1

- fix: make image URL on readme.md absolute so that it will be displayed properly on pub.dev

## 0.1.0

- BREAKING: remove unnecessary button styles
- BREAKING: properly style google login button
- feat: update minimum supabase_flutter version to 1.4.0
- fix: updated some of the brand colors for social auth buttons

## 0.0.1

- BREAKING: update supabase_flutter to v1.0.0

## 0.0.1-dev.4

- fix: image URL of Supabase logo in readme.md

## 0.0.1-dev.3

- BREAKING: update supabase_flutter to v1.0.0-dev.9
- BREAKING: `AuthAction` and `PhoneAuthAction` are now `SupaAuthAction`
- BREAKING: `SupabaseAuthUi` class is now removed to let users use `Supabase.instance` directly
- BREAKING: removed the success and fail dialog in favor of `onSuccess` and `onError`
- feat: introduce `onSuccess` and `onError` methods on UI components to handle successful and failed auth actions
- feat: export supabase_flutter package
- chore: added some docs on public members
- feat: add phone auth support
- fix: only validate forms upon submission
- feat: `metadataFields` has been added to add additional fields to the signup form to pass data as metadata in Supabase
  ```dart
  SupaEmailAuth(
      authAction: AuthAction.signUp,
      metadataFields: [
          MetaDataField(
              prefixIcon: const Icon(Icons.person),
              label: 'Username',
              key: 'username',
              validator: (val) {
                  if (val == null || val.isEmpty) {
                  return 'Please enter something';
                  }
                  return null;
              },
          ),
      ],
      onSuccess: _handleSignupSuccess,
  )
  ```

## 0.0.1-dev.2

- fix: add github actions and fix errors in example
- fix: refactor SocialProviders by using Dart 2.17 enhanced enum
- chore: remove flutter-plugins auto generated files from version control
- fix: update social sign in button text
- fix: Replace `GotrueError` with `GoTrueException`
- fix: update supabase_flutter to v1.0.0-dev.3

## 0.0.1-dev.1

- Initial developer preview release.
