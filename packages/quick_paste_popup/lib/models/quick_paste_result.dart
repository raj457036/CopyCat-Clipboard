/// Result returned after user interacts with the popup
class QuickPasteResult {
  /// The selected item ID
  final String? selectedItemId;

  /// Whether the popup was dismissed (true) or an item was selected (false)
  final bool dismissed;

  /// Error message if operation failed
  final String? error;

  QuickPasteResult({this.selectedItemId, this.dismissed = false, this.error});

  // Convert to JSON for platform channel
  Map<String, dynamic> toJson() {
    return {
      'selectedItemId': selectedItemId,
      'dismissed': dismissed,
      'error': error,
    };
  }

  // Create from JSON
  factory QuickPasteResult.fromJson(Map<String, dynamic> json) {
    return QuickPasteResult(
      selectedItemId: json['selectedItemId'] as String?,
      dismissed: json['dismissed'] as bool? ?? false,
      error: json['error'] as String?,
    );
  }
}
