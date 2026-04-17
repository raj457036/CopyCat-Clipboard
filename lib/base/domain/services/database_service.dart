/// Database-agnostic service interface for lifecycle operations.
///
/// Implementations handle database initialization, cleanup, and teardown
/// for specific database engines (Isar, SQLite, etc.).
abstract class DatabaseService {
  /// Initialize the database connection.
  Future<void> initialize();

  /// Clear all data from the database.
  Future<void> clearAll();

  /// Close the database connection.
  Future<void> close();
}
