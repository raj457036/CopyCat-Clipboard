/// Data transfer object for clipboard items to display in the popup
class ClipboardItemDto {
  final String id;
  final String text;
  final String? appIconPath;
  final String? previewImagePath;
  final bool isImage;
  final String? imageBase64; // Base64 encoded image for preview
  final DateTime copiedAt;

  ClipboardItemDto({
    required this.id,
    required this.text,
    this.appIconPath,
    this.previewImagePath,
    required this.isImage,
    this.imageBase64,
    required this.copiedAt,
  });

  // Convert to JSON for platform channel
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'appIconPath': appIconPath,
      'previewImagePath': previewImagePath,
      'isImage': isImage,
      'imageBase64': imageBase64,
      'copiedAt': copiedAt.millisecondsSinceEpoch,
    };
  }

  // Create from JSON
  factory ClipboardItemDto.fromJson(Map<String, dynamic> json) {
    return ClipboardItemDto(
      id: json['id'] as String,
      text: json['text'] as String,
      appIconPath: json['appIconPath'] as String?,
      previewImagePath: json['previewImagePath'] as String?,
      isImage: json['isImage'] as bool? ?? false,
      imageBase64: json['imageBase64'] as String?,
      copiedAt: DateTime.fromMillisecondsSinceEpoch(
        json['copiedAt'] as int? ?? 0,
      ),
    );
  }
}
