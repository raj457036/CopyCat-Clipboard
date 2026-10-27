import 'dart:async';
import 'dart:io';

import 'package:clipboard/base/background/encryption_worker.dart';
import 'package:clipboard/base/data/services/supabase_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _RealHttpOverrides extends HttpOverrides {}

void main() {
  test('metadata timeout aborts a stalled Supabase write', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final received = Completer<void>();
    final subscription = server.listen((request) {
      received.complete();
      // Intentionally do not send response headers.
    });
    final transport = SupabaseHttpClient(
      IOClient(_RealHttpOverrides().createHttpClient(null)),
    );
    final client = SupabaseClient(
      'http://${server.address.address}:${server.port}',
      'test-key',
      httpClient: transport,
      postgrestOptions: const PostgrestClientOptions(
        requestTimeout: Duration(milliseconds: 100),
      ),
    );
    addTearDown(() async {
      await client.dispose();
      transport.close();
      await server.close(force: true);
      await subscription.cancel();
    });
    await expectLater(
      client.rest.from('clips').insert({'text': 'test'}).select(),
      throwsA(isA<TimeoutException>()),
    );
    expect(received.isCompleted, isTrue);
  });

  testWidgets('encryption key readiness cannot hold sync indefinitely', (
    tester,
  ) async {
    final worker = EncryptionWorker.instance;
    worker.setEncryption(true);
    final key = Completer<String?>();
    final started = worker.start(key.future);
    final unavailable = worker.isEncryptionUnavailable();
    await tester.pump(const Duration(minutes: 2));
    expect(await unavailable, isTrue);
    key.complete(null);
    await started;
    worker.dispose();
    worker.setEncryption(false);
  });
}
