import 'dart:async';

import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/sync/sync_config.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/sync/sync_engine.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Adapter<T extends Syncable> extends Fake implements SyncAdapter<T> {
  @override
  String get entityType => 'unused';
  @override
  CrossSyncListener<T>? get realtimeListener => null;
}

class _Cursor extends Fake implements SyncCursorRepository {}

class _Outbox extends Fake implements SyncOutboxRepository {
  final entries = <SyncOutboxEntry>[];
  @override
  Stream<void> get onNewEntry => const Stream.empty();
  @override
  Future<List<SyncOutboxEntry>> getPending({int limit = 50}) async =>
      entries.take(limit).toList();
}

class _Engine extends Fake implements SyncEngine<ClipboardItem> {
  final _Outbox outbox;
  final String entity;
  final List<String> order;
  Completer<void>? gate;
  bool noProgress = false;
  int simultaneous = 0;
  int maxSimultaneous = 0;
  int processed = 0;

  _Engine(this.outbox, this.entity, this.order);
  @override
  String get identity => entity;
  @override
  List<String> get dependsOn => const [];
  @override
  SyncConfig get config => const SyncConfig();
  @override
  void stopPolling() {}
  @override
  void stopRealtime() {}
  @override
  void startPolling({int? intervalSeconds}) {}

  @override
  Future<void> processOutbox() async {
    simultaneous++;
    if (simultaneous > maxSimultaneous) maxSimultaneous = simultaneous;
    try {
      await gate?.future;
      if (noProgress) return;
      final relevant = (await outbox.getPending())
          .where((entry) => entry.entityType == entity)
          .toList();
      processed += relevant.length;
      outbox.entries.removeWhere(relevant.contains);
      if (relevant.isNotEmpty) order.add('push:$entity');
    } finally {
      simultaneous--;
    }
  }

  @override
  Future<SyncResult> pull({
    bool force = false,
    bool freshPull = false,
    int? pullOffset,
  }) async {
    order.add('pull:$entity');
    return SyncResult.success;
  }
}

void main() {
  late _Outbox outbox;
  late SyncOrchestrator orchestrator;
  late SyncEventBus events;
  late SupabaseClient client;
  late List<String> order;
  late List<_Engine> engines;

  setUp(() {
    outbox = _Outbox();
    events = SyncEventBus();
    client = SupabaseClient('https://example.supabase.co', 'test-key');
    orchestrator = SyncOrchestrator(
      _Adapter<ClipboardItem>(),
      _Adapter<ClipboardItem>(),
      _Adapter<ClipCollection>(),
      _Cursor(),
      outbox,
      events,
      'device',
      client,
    );
    order = [];
    engines = [
      for (final entity in [
        'clip:clip',
        'unused:collection',
        'unused:collection-clip',
      ])
        _Engine(outbox, entity, order),
    ];
    // Replace the bootstrapped engines with controllable queue processors.
    orchestrator.register(_Engine(outbox, 'unused:clip', order));
    for (final engine in engines.skip(1)) {
      orchestrator.register(engine);
    }
    orchestrator.register(engines.first);
    orchestrator.start(syncSpeed: SyncSpeed.balanced, intervalSeconds: 3600);
  });

  tearDown(() async {
    orchestrator.stop();
    events.dispose();
    await client.dispose();
  });

  void enqueue(int count) {
    outbox.entries.addAll([
      for (var id = 1; id <= count; id++)
        SyncOutboxEntry(
          id: id,
          entityType: 'clip:clip',
          localId: id,
          action: SyncOutboxAction.create,
          createdAt: DateTime.now(),
        ),
    ]);
  }

  test('one invocation drains more than 50 persisted jobs', () async {
    enqueue(125);
    await orchestrator.processOutboxes();
    expect(outbox.entries, isEmpty);
    expect(engines.first.processed, 125);
  });

  test(
    'manual and automatic drains cannot process jobs concurrently',
    () async {
      enqueue(2);
      engines.first.gate = Completer<void>();
      final first = orchestrator.processOutboxes();
      final second = orchestrator.processOutboxes();
      await Future<void>.delayed(Duration.zero);
      expect(engines.first.simultaneous, 1);
      engines.first.gate!.complete();
      await Future.wait([first, second]);
      expect(engines.first.maxSimultaneous, 1);
      expect(engines.first.processed, 2);
    },
  );

  test('Sync now drains uploads before pulling remote clips', () async {
    enqueue(1);
    expect(await orchestrator.syncAll(force: true), isTrue);
    expect(outbox.entries, isEmpty);
    expect(order.first, 'push:clip:clip');
    expect(order.any((event) => event.startsWith('pull:')), isTrue);
  });

  test('no-progress failure exits instead of spinning indefinitely', () async {
    enqueue(1);
    engines.first.noProgress = true;
    await expectLater(orchestrator.processOutboxes(), throwsStateError);
  });

  test('a stopped processor does not bypass sync eligibility', () async {
    enqueue(1);
    orchestrator.stop();
    await orchestrator.processOutboxes();
    expect(outbox.entries, hasLength(1));
    expect(engines.first.processed, 0);
  });
}
