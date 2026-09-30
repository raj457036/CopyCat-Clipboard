import 'package:clipboard/widgets/link_preview/type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LinkPreview Fetch Models', () {
    test('LinkPreviewFetchRequest initializes with default parameters', () {
      const LinkPreviewFetchRequest request = LinkPreviewFetchRequest(
        url: 'https://example.com',
      );

      expect(request.url, equals('https://example.com'));
      expect(request.headers, isNull);
      expect(request.proxy, isNull);
      expect(request.requestTimeout, equals(const Duration(seconds: 5)));
      expect(request.userAgent, equals('WhatsApp/2'));
    });

    test('LinkPreviewFetchResult converts cleanly to LinkPreviewData', () {
      const LinkPreviewFetchResult result = LinkPreviewFetchResult(
        link: 'https://example.com/item',
        title: 'Example Item',
        description: 'An example description',
        imageUrl: 'https://example.com/image.jpg',
        status: LinkPreviewFetchStatus.success,
      );

      final LinkPreviewData data = result.toLinkPreviewData();

      expect(data.link, equals('https://example.com/item'));
      expect(data.title, equals('Example Item'));
      expect(data.description, equals('An example description'));
      expect(data.image, isNotNull);
      expect(data.image!.imageUrl, equals('https://example.com/image.jpg'));
      expect(result.status, equals(LinkPreviewFetchStatus.success));
      expect(result.hasContent, isTrue);
    });

    test('LinkPreviewFetchResult handles null optional fields and error statuses', () {
      const LinkPreviewFetchResult result = LinkPreviewFetchResult(
        link: 'https://example.com/page',
        status: LinkPreviewFetchStatus.transientError,
      );

      final LinkPreviewData data = result.toLinkPreviewData();

      expect(data.link, equals('https://example.com/page'));
      expect(data.title, isNull);
      expect(data.description, isNull);
      expect(data.image, isNull);
      expect(result.status, equals(LinkPreviewFetchStatus.transientError));
      expect(result.hasContent, isFalse);
    });

    test('LinkPreviewFetchResult distinguishes noMetadata status', () {
      const LinkPreviewFetchResult result = LinkPreviewFetchResult(
        link: 'https://example.com/download.zip',
        status: LinkPreviewFetchStatus.noMetadata,
      );

      expect(result.status, equals(LinkPreviewFetchStatus.noMetadata));
      expect(result.hasContent, isFalse);
    });
  });
}
