import 'package:mindful/core/errors/app_exception.dart';

/// Parsed success envelope: `{ success, message, data, meta? }` (SRS §8.9).
class ApiEnvelope<T> {
  const ApiEnvelope({required this.message, required this.data, this.pagination});

  /// Parses [json]; `data` is converted with [parseData].
  factory ApiEnvelope.fromJson(Map<String, dynamic> json, T Function(Object? data) parseData) {
    if (json['success'] != true) {
      throw const UnknownException();
    }
    final meta = json['meta'];
    final pagination = meta is Map<String, dynamic> ? meta['pagination'] : null;

    return ApiEnvelope(
      message: json['message'] is String ? json['message'] as String : '',
      data: parseData(json['data']),
      pagination: pagination is Map<String, dynamic> ? CursorPagination.fromJson(pagination) : null,
    );
  }

  final String message;
  final T data;
  final CursorPagination? pagination;
}

/// `meta.pagination` for cursor-paginated lists.
class CursorPagination {
  const CursorPagination({
    required this.perPage,
    required this.hasMore,
    this.nextCursor,
    this.prevCursor,
  });

  factory CursorPagination.fromJson(Map<String, dynamic> json) => CursorPagination(
    perPage: (json['per_page'] as num?)?.toInt() ?? 0,
    hasMore: json['has_more'] == true,
    nextCursor: json['next_cursor'] as String?,
    prevCursor: json['prev_cursor'] as String?,
  );

  final int perPage;
  final bool hasMore;
  final String? nextCursor;
  final String? prevCursor;
}

/// One page of items plus the cursor to fetch the next one.
class CursorPage<T> {
  const CursorPage({required this.items, this.nextCursor, this.hasMore = false});

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
}

/// Helpers for typical `data` shapes.
abstract final class ApiData {
  static Map<String, dynamic> object(Object? data) {
    if (data is Map<String, dynamic>) return data;
    throw const UnknownException();
  }

  static List<Map<String, dynamic>> list(Object? data) {
    if (data is List) return data.whereType<Map<String, dynamic>>().toList();
    throw const UnknownException();
  }
}
