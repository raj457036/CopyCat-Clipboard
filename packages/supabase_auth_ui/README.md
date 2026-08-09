# flutter-auth-ui :iphone:

<p float="left">
<img src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--dark.png"  width="60%" height="50%" />
</p>
A simple library of predefined widgets to easily and quickly create auth components using Flutter and Supabase.

![Supabase Auth UI](https://raw.githubusercontent.com/supabase-community/flutter-auth-ui/main/screenshots/supabase_auth_ui.png 'Supabase Auth UI Sample')

## Email Auth

Use a `SupaEmailAuth` widget to create an email and password signin/ signup form.
It also contains a button to toggle to display a forgot password form.

You can pass `metadataFields` to add additional fields to the signup form to pass as metadata to Supabase.

You need to setup deep links in your app to if you have enabled email confirmation. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
// Create a Email sign-in/sign-up form
SupaEmailAuth(
  redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
  onSignInComplete: (response) {
    // do something, for example: navigate('home');
  },
  onSignUpComplete: (response) {
    // do something, for example: navigate("wait_for_email");
  },
  metadataFields: [
    // Creates an additional TextField for string metadata, for example:
    // {'username': 'exampleUsername'}
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

    // Creates a CheckboxListTile for boolean metadata, for example:
    // {'marketing_consent': true}
    BooleanMetaDataField(
      label: 'I wish to receive marketing emails',
      key: 'marketing_consent',
      checkboxPosition: ListTileControlAffinity.leading,
    ),
    // Supports interactive text. Fields can be marked as required, blocking form
    // submission unless the checkbox is checked.
    BooleanMetaDataField(
      key: 'terms_agreement',
      isRequired: true,
      checkboxPosition: ListTileControlAffinity.leading,
      richLabelSpans: [
        const TextSpan(
            text: 'I have read and agree to the '),
        TextSpan(
          text: 'Terms and Conditions',
          style: const TextStyle(
            color: Colors.blue,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              // do something, for example: navigate("terms_and_conditions");
            },
        ),
        // Or use some other custom widget.
        WidgetSpan()
      ],
    ),
  ]),
```

## Magic Link Auth

Use `SupaMagicAuth` widget to create a magic link signIn form. You need to setup deep links in your app to use magic link. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
SupaMagicAuth(
  redirectUrl: kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
  onSuccess: (Session response) {
    // do something, for example: navigate('home');
  },
  onError: (error) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

## Reset password

Use `SupaResetPassword` to create a password reset form.

```dart
SupaResetPassword(
  accessToken: supabase.auth.currentSession?.accessToken,
  onSuccess: (UserResponse response) {
    // do something, for example: navigate('home');
  },
  onError: (error) {
    // do something, for example: navigate("wait_for_email");
  },
),
```

## Social Auth

Use `SupaSocialsAuth` to create list of social login buttons. You need to setup deep links in your app to use social auth. Learn more about deep links on the [supabase_flutter README](https://pub.dev/packages/supabase_flutter#deep-links).

```dart
SupaSocialsAuth(
    socialProviders: [
        OAuthProvider.apple,
        OAuthProvider.google,
    ],
    colored: true,
    redirectUrl: kIsWeb
          ? null
          : 'io.supabase.flutter://reset-callback/',
    onSuccess: (Session response) {
        // do something, for example: navigate('home');
    },
    onError: (error) {
        // do something, for example: navigate("wait_for_email");
    },
),
```

## Theming

This library uses bare Flutter components so that you can control the appearance of the components using your own theme.
See theme example in example/lib/sign_in.dart
