import 'dart:ui' show Size;

class LinkImagePreviewData {
  final String imageUrl;
  final Size? imageSize;

  LinkImagePreviewData({required this.imageUrl, this.imageSize});
}

class LinkPreviewData {
  final String link;
  final String? title;
  final String? description;
  final LinkImagePreviewData? image;

  LinkPreviewData({
    required this.link,
    this.title,
    this.description,
    this.image,
  });

  @override
  String toString() {
    return 'LinkPreviewData(link: $link, title: $title, description: $description, image: $image)';
  }
}
