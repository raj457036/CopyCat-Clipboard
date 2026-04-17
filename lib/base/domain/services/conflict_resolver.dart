import 'package:clipboard/base/domain/model/syncable.dart';

/// Decides which version wins when local and remote conflict.
abstract class ConflictResolver<T extends Syncable> {
  /// Returns the winner: incoming (remote) or existing (local).
  T resolve(T incoming, T existing);
}

/// Default: last-modified-wins.
class LastModifiedWinsResolver<T extends Syncable>
    implements ConflictResolver<T> {
  @override
  T resolve(T incoming, T existing) {
    return incoming.modified.isAfter(existing.modified) ? incoming : existing;
  }
}
