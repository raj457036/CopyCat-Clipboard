import 'dart:ui' show Size;

enum LinkPreviewFetchStatus {
  success,
  noMetadata,
  transientError,
}

class LinkPreviewFetchRequest {
  final String url;
  final Map<String, String>? headers;
  final String? proxy;
  final Duration requestTimeout;
  final String userAgent;

  const LinkPreviewFetchRequest({
    required this.url,
    this.headers,
    this.proxy,
    this.requestTimeout = const Duration(seconds: 5),
    this.userAgent = 'WhatsApp/2',
  });
}

class LinkPreviewFetchResult {
  final String link;
  final String? title;
  final String? description;
  final String? imageUrl;
  final LinkPreviewFetchStatus status;

  const LinkPreviewFetchResult({
    required this.link,
    this.title,
    this.description,
    this.imageUrl,
    this.status = LinkPreviewFetchStatus.success,
  });

  bool get hasContent =>
      (title != null && title!.isNotEmpty) ||
      (description != null && description!.isNotEmpty) ||
      (imageUrl != null && imageUrl!.isNotEmpty);

  LinkPreviewData toLinkPreviewData() {
    return LinkPreviewData(
      link: link,
      title: title,
      description: description,
      image: imageUrl != null && imageUrl!.isNotEmpty
          ? LinkImagePreviewData(imageUrl: imageUrl!)
          : null,
    );
  }

  @override
  String toString() {
    return 'LinkPreviewFetchResult(link: $link, status: $status, title: $title, description: $description, imageUrl: $imageUrl)';
  }
}

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
