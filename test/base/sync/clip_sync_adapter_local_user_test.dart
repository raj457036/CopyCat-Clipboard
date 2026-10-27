import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/adapters/clip_sync_adapter.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/auth.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/file_cloud_service.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _Sync extends Fake implements SyncRepository {}

class _Batch extends Fake implements ClipBatchSyncService {}

class _Listener extends Fake implements ClipCrossSyncListener {}

class _Files extends Fake implements FileCloudService {}

class _Auth extends Fake implements AuthRepository {
  String? id;
  @override
  String? get userId => id;
}

class _LocalRepo extends Fake implements ClipboardRepository {
  final store = <int, ClipboardItem>{};
  @override
  FailureOr<ClipboardItem?> get({int? id, int? serverId}) async =>
      Right(store[id]);
}

class _LocalSource extends Fake implements ClipboardSource {
  final _LocalRepo repo;
  final updates = <ClipboardItem>[];
  _LocalSource(this.repo);
  @override
  Future<ClipboardItem> update(ClipboardItem item) async {
    updates.add(item);
    repo.store[item.id!] = item;
    return item;
  }
}

class _RemoteRepo extends Fake implements ClipboardRepository {
  final created = <ClipboardItem>[];
  @override
  FailureOr<ClipboardItem> create(ClipboardItem item) async {
    created.add(item);
    return Right(item.copyWith(serverId: 900));
  }
}

ClipboardItem _clip({required String userId}) => ClipboardItem(
  id: 1,
  created: systemTime(),
  modified: systemTime(),
  type: ClipItemType.text,
  text: 'hello',
  userId: userId,
  os: PlatformOS.macos,
);

void main() {
  late _Auth auth;
  late _LocalRepo localRepo;
  late _LocalSource localSource;
  late _RemoteRepo remote;
  late ClipSyncAdapter adapter;

  setUp(() {
    auth = _Auth();
    localRepo = _LocalRepo();
    localSource = _LocalSource(localRepo);
    remote = _RemoteRepo();
    adapter = ClipSyncAdapter(
      _Sync(),
      localRepo,
      remote,
      _Batch(),
      _Listener(),
      _Files(),
      localSource,
      'device-1',
      auth,
    );
  });

  test(
    'a clip created before sign-in is re-owned to the user, then pushed',
    () async {
      auth.id = 'user-1';
      localRepo.store[1] = _clip(userId: kLocalUserId);

      final result = await adapter.pushToRemote(localRepo.store[1]!);

      expect(result.isRight(), isTrue);
      expect(remote.created.single.userId, 'user-1');
      // Owner change is persisted locally before the push, via the source
      // (not the repository) so it does not re-enqueue itself.
      expect(localSource.updates.first.userId, 'user-1');
      expect(localRepo.store[1]!.userId, 'user-1');
    },
  );

  test('without a signed-in user a local clip is not pushed', () async {
    auth.id = null;
    localRepo.store[1] = _clip(userId: kLocalUserId);

    final result = await adapter.pushToRemote(localRepo.store[1]!);

    expect(result, const Left<Failure, ClipboardItem>(authFailure));
    expect(remote.created, isEmpty);
    expect(localRepo.store[1]!.userId, kLocalUserId);
  });

  test('clips that already have an owner are pushed unchanged', () async {
    auth.id = 'user-1';
    localRepo.store[1] = _clip(userId: 'user-2');

    await adapter.pushToRemote(localRepo.store[1]!);

    expect(remote.created.single.userId, 'user-2');
  });
}
