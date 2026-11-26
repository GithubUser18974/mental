import 'package:dio/dio.dart';
import 'package:mindful/core/errors/app_exception.dart';

/// Converts a [DioException] (+ the API error envelope) into an [AppException].
AppException mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const RequestTimeoutException();
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return const NetworkException();
    case DioExceptionType.cancel:
      return const UnknownException();
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      break;
  }

  final response = e.response;
  if (response == null) return const NetworkException();

  final body = response.data;
  final json = body is Map<String, dynamic> ? body : const <String, dynamic>{};
  final message = json['message'] is String ? json['message'] as String : null;

  return switch (response.statusCode ?? 0) {
    401 => UnauthorizedException(message),
    403 => ForbiddenException(message),
    404 => NotFoundException(message),
    422 => ValidationException(_fieldErrors(json['errors']), message),
    429 => RateLimitedException(
      retryAfter: _retryAfter(response.headers.value('retry-after')),
      serverMessage: message,
    ),
    final int code when code >= 500 => ServerException(message),
    final int code when code >= 400 => ClientException(code, message),
    _ => UnknownException(message),
  };
}

Map<String, List<String>> _fieldErrors(Object? raw) {
  if (raw is! Map) return const {};
  return {
    for (final entry in raw.entries)
      if (entry.key is String && entry.value is List)
        entry.key as String: (entry.value as List).whereType<String>().toList(),
  };
}

Duration? _retryAfter(String? header) {
  final seconds = int.tryParse(header ?? '');
  return seconds == null ? null : Duration(seconds: seconds);
}
