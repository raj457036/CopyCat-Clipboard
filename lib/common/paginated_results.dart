class PaginatedResult<T> {
  final List<T> results;
  final bool hasMore;
  final int? totalCount;

  PaginatedResult({
    required this.results,
    required this.hasMore,
    this.totalCount,
  });

  PaginatedResult.empty() : hasMore = false, results = [], totalCount = 0;
}
