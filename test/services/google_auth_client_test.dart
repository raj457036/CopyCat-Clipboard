import 'dart:async';
import 'dart:convert';

import 'package:clipboard/base/data/services/file_cloud_services/google_drive/google_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _Transport extends http.BaseClient {
  final Future<http.StreamedResponse> Function(http.BaseRequest) onSend;
  int closeCount = 0;

  _Transport(this.onSend);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      onSend(request);

  @override
  void close() => closeCount++;
}

void main() {
  final uri = Uri.parse('https://example.com/upload');
  const timeout = Duration(minutes: 2);

  test('uses the owned transport and preserves response metadata', () async {
    final transport = _Transport((request) async {
      expect(await request.finalize().bytesToString(), 'file content');
      expect(request.headers['Authorization'], 'Bearer test-token');
      return http.StreamedResponse(
        Stream.value(utf8.encode('uploaded')),
        201,
        contentLength: 8,
        headers: {'range': 'bytes=0-7', 'x-test': 'preserved'},
        reasonPhrase: 'Created',
        request: request,
      );
    });
    final client = GoogleAuthClient('test-token', client: transport);
    addTearDown(client.close);
    final response = await client.send(
      http.Request('POST', uri)..body = 'file content',
    );

    expect(await response.stream.bytesToString(), 'uploaded');
    expect(response.statusCode, 201);
    expect(response.contentLength, 8);
    expect(response.headers['x-test'], 'preserved');
    expect(response.reasonPhrase, 'Created');
    expect(response.request!.url, uri);
    expect(client.currentBytes, 7);
    expect(transport.closeCount, 0);
    client.close();
    client.close();
    expect(transport.closeCount, 1);
  });

  testWidgets('a stalled request times out and closes its transport', (
    tester,
  ) async {
    final transport = _Transport(
      (_) => Completer<http.StreamedResponse>().future,
    );
    final client = GoogleAuthClient('test-token', client: transport);
    addTearDown(client.close);
    final failed = expectLater(
      client.send(http.Request('POST', uri)),
      throwsA(isA<TimeoutException>()),
    );

    await tester.pump(timeout - const Duration(seconds: 1));
    expect(transport.closeCount, 0);
    await tester.pump(const Duration(seconds: 1));
    await failed;
    expect(transport.closeCount, 1);
    await expectLater(client.send(http.Request('POST', uri)), throwsStateError);
  });

  test('a stalled response body closes the transport', () async {
    final body = StreamController<List<int>>();
    addTearDown(() {
      unawaited(body.close());
    });
    final transport = _Transport(
      (_) async => http.StreamedResponse(body.stream, 200),
    );
    final client = GoogleAuthClient(
      'test-token',
      client: transport,
      requestTimeout: const Duration(milliseconds: 20),
    );
    addTearDown(client.close);
    final response = await client.send(http.Request('GET', uri));
    final failed = expectLater(
      response.stream.toBytes(),
      throwsA(isA<TimeoutException>()),
    );

    await failed;
    expect(transport.closeCount, 1);
  });

  test('response progress resets the inactivity timeout', () async {
    final body = StreamController<List<int>>();
    final transport = _Transport(
      (_) async => http.StreamedResponse(body.stream, 200),
    );
    final client = GoogleAuthClient(
      'test-token',
      client: transport,
      requestTimeout: const Duration(seconds: 2),
    );
    addTearDown(client.close);
    final response = await client.send(http.Request('GET', uri));
    final content = response.stream.toBytes();

    for (var index = 0; index < 3; index++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      body.add([index]);
      expect(transport.closeCount, 0);
    }
    unawaited(body.close());
    expect(await content, [0, 1, 2]);
  });
}
