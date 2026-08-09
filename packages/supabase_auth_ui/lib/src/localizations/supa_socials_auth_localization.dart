import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SupaSocialsAuthLocalization {
  final String successSignInMessage;
  final String unexpectedError;

  /// Overrides the name of the OAuth provider shown on the sign-in button.
  ///
  /// Defaults to `Continue with [ProviderName]`
  ///
  /// ```dart
  /// SupaSocialsAuth(
  ///   socialProviders: const [OAuthProvider.azure],
  ///   localization: const SupaSocialsAuthLocalization(
  ///     oAuthButtonLabels: {
  ///       OAuthProvider.azure: 'Microsoft (Azure)'
  ///     },
  ///   ),
  ///   onSuccess: (session) {
  ///     // sHandle success
  ///   },
  /// ),
  /// ```
  final Map<OAuthProvider, String> oAuthButtonLabels;

  const SupaSocialsAuthLocalization({
    this.successSignInMessage = 'Successfully signed in!',
    this.unexpectedError = 'An unexpected error occurred',
    this.oAuthButtonLabels = const {},
  });
}
