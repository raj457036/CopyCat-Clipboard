/// Handles in-app review prompts across platforms.
abstract class InAppReviewService {
  /// Returns `true` when the platform supports the native review flow.
  Future<bool> isAvailable();

  /// Triggers the native in-app review dialog when available.
  Future<void> requestReview();

  /// Opens the store listing page so the user can leave a review manually.
  Future<void> openStoreListing();
}
