import 'dart:async';
import 'dart:convert';
import 'dart:ui' show Size;

import 'package:clipboard/widgets/link_preview/type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show decodeImageFromList;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http show Request, Client, Response;
import 'package:punycode/punycode.dart' as puny;

// Calculates the URL to be used for fetching link preview data,
// taking into account any provided proxy and handling punycode
// encoding for non-ASCII domain names.
String _calculateUrl(String baseUrl, String? proxy) {
  var urlToReturn = baseUrl;

  final domainRegex = RegExp(r'^(?:(http|https|ftp):\/\/)?([^\/?#]+)');
  final match = domainRegex.firstMatch(baseUrl);

  if (match != null) {
    final originalDomain = match.group(2)!;

    final labels = originalDomain.split('.');
    if (labels.length <= 10) {
      final encodedLabels = labels.map((label) {
        final isAscii = label.runes.every((r) => r < 128);
        return isAscii ? label : 'xn--${puny.punycodeEncode(label)}';
      }).toList();

      final punycodedDomain = encodedLabels.join('.');
      urlToReturn = baseUrl.replaceFirst(originalDomain, punycodedDomain);
    }
  }

  if (proxy != null) {
    return '$proxy$urlToReturn';
  }

  return urlToReturn;
}

String? _getMetaContent(Document document, String propertyValue) {
  final meta = document.getElementsByTagName('meta');
  final element = meta.firstWhere(
    (e) => e.attributes['property'] == propertyValue,
    orElse: () => meta.firstWhere(
      (e) => e.attributes['name'] == propertyValue,
      orElse: () => Element.tag(null),
    ),
  );

  return element.attributes['content']?.trim();
}

String? _getTitle(Document document) {
  final metaTitle =
      _getMetaContent(document, 'og:title') ??
      _getMetaContent(document, 'twitter:title') ??
      _getMetaContent(document, 'og:site_name');

  if (metaTitle != null) return metaTitle;

  final titleElements = document.getElementsByTagName('title');
  if (titleElements.isNotEmpty) return titleElements.last.text;
  return null;
}

String? _getDescription(Document document) =>
    _getMetaContent(document, 'og:description') ??
    _getMetaContent(document, 'description') ??
    _getMetaContent(document, 'twitter:description');

List<String> _getImageUrls(Document document, String baseUrl) {
  final meta = document.getElementsByTagName('meta');
  var attribute = 'content';
  var elements = meta
      .where(
        (e) =>
            e.attributes['property'] == 'og:image' ||
            e.attributes['property'] == 'twitter:image',
      )
      .toList();

  if (elements.isEmpty) {
    elements = document.getElementsByTagName('img');
    attribute = 'src';
  }

  return elements.fold<List<String>>([], (previousValue, element) {
    final actualImageUrl = _getActualImageUrl(
      baseUrl,
      element.attributes[attribute]?.trim(),
    );

    return actualImageUrl != null
        ? [...previousValue, actualImageUrl]
        : previousValue;
  });
}

String? _getActualImageUrl(String baseUrl, String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty || imageUrl.startsWith('data')) {
    return null;
  }

  if (imageUrl.contains('.svg') || imageUrl.contains('.gif')) return null;

  if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';

  if (!imageUrl.startsWith('http')) {
    if (baseUrl.endsWith('/') && imageUrl.startsWith('/')) {
      imageUrl = '${baseUrl.substring(0, baseUrl.length - 1)}$imageUrl';
    } else if (!baseUrl.endsWith('/') && !imageUrl.startsWith('/')) {
      imageUrl = '$baseUrl/$imageUrl';
    } else {
      imageUrl = '$baseUrl$imageUrl';
    }
  }

  return imageUrl;
}

Future<Size> _getImageSizeFromBytes(Uint8List bytes) async {
  final image = await decodeImageFromList(bytes);
  return Size(image.width.toDouble(), image.height.toDouble());
}

Map<String, Object?> _extractPreviewMetadata(Map<String, Object?> payload) {
  final html = payload['html'] as String;
  final baseUrl = payload['baseUrl'] as String;

  final document = parser.parse(html);
  final title = _getTitle(document)?.trim();
  final description = _getDescription(document)?.trim();
  final imageUrls = _getImageUrls(document, baseUrl);

  return {'title': title, 'description': description, 'imageUrls': imageUrls};
}

Future<http.Response?> _getRedirectedResponse(
  Uri uri, {
  Map<String, String>? headers,
  int maxRedirects = 5,
  Duration timeout = const Duration(seconds: 5),
  http.Client? client,
}) async {
  final httpClient = client ?? http.Client();
  var redirectCount = 0;

  while (redirectCount < maxRedirects) {
    final request = http.Request('GET', uri)..followRedirects = false;

    if (headers != null) {
      request.headers.addAll(headers);
    }

    final streamedResponse = await httpClient.send(request).timeout(timeout);

    if (streamedResponse.isRedirect &&
        streamedResponse.headers.containsKey('location')) {
      uri = uri.resolve(streamedResponse.headers['location']!);
      redirectCount++;
      continue;
    }

    return http.Response.fromStream(streamedResponse);
  }

  return null;
}

/// Fetches link preview data for a given URL, including title, description,
/// and image.
Future<LinkPreviewData?> getLinkPreviewData(
  String url, {
  Map<String, String>? headers,
  String? proxy,
  Duration? requestTimeout,
  String userAgent = 'WhatsApp/2',
}) async {
  String? previewDataUrl;
  LinkImagePreviewData? previewDataImage;
  String? previewDataDescription;
  String? previewDataTitle;

  try {
    if (!url.toLowerCase().startsWith('http')) {
      url = 'https://$url';
    }
    previewDataUrl = _calculateUrl(url, proxy);
    final uri = Uri.parse(previewDataUrl);

    final effectiveHeaders = <String, String>{
      'User-Agent': userAgent,
      ...?headers,
    };

    final response = await _getRedirectedResponse(
      uri,
      headers: effectiveHeaders,
      timeout: requestTimeout ?? const Duration(seconds: 5),
    );

    if (response == null || response.statusCode != 200) {
      return null;
    }
    url = response.request?.url.toString() ?? url;

    final imageRegexp = RegExp(r'image\/*');

    if (imageRegexp.hasMatch(response.headers['content-type'] ?? '')) {
      final imageSize = await _getImageSizeFromBytes(response.bodyBytes);
      return LinkPreviewData(
        link: previewDataUrl,
        image: LinkImagePreviewData(
          imageUrl: previewDataUrl,
          imageSize: imageSize,
        ),
      );
    }

    try {
      Encoding encoding;
      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      if (contentType.contains('charset=')) {
        final charset = contentType.split('charset=')[1].split(';')[0].trim();
        encoding = Encoding.getByName(charset) ?? utf8;
        debugPrint('getLinkPreviewData fetched document encoding: $encoding');
      } else {
        encoding = utf8;
      }

      final parsedMetadata = await compute(_extractPreviewMetadata, {
        'html': encoding.decode(response.bodyBytes),
        'baseUrl': url,
      });

      previewDataTitle = parsedMetadata['title'] as String?;
      previewDataDescription = parsedMetadata['description'] as String?;

      final imageUrls = (parsedMetadata['imageUrls'] as List<dynamic>)
          .cast<String>();

      if (imageUrls.isNotEmpty) {
        final previewDataImageUrl = _calculateUrl(imageUrls.first, proxy);
        previewDataImage = LinkImagePreviewData(imageUrl: previewDataImageUrl);
      }
    } catch (e) {
      return LinkPreviewData(link: url);
    }

    return LinkPreviewData(
      link: previewDataUrl,
      title: previewDataTitle,
      description: previewDataDescription,
      image: previewDataImage,
    );
  } catch (e) {
    return null;
  }
}
