/// Typed failures surfaced to the presentation layer.
///
/// Repositories throw these — never raw `DioException`s. Widgets map them to
/// localized text with `AppExceptionL10n.localizedMessage`.
sealed class AppException implements Exception {
  const AppException([this.serverMessage]);

  /// Localized, data-free message from the API envelope (if any).
  final String? serverMessage;

  @override
  String toString() => 'AppException(${serverMessage ?? ''})';
}

/// No connection / DNS / TLS / connection refused.
final class NetworkException extends AppException {
  const NetworkException([super.serverMessage]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.serverMessage]);
}

/// 401 — session missing or expired.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.serverMessage]);
}

/// 403.
final class ForbiddenException extends AppException {
  const ForbiddenException([super.serverMessage]);
}

/// 404 — also returned for other users' private records.
final class NotFoundException extends AppException {
  const NotFoundException([super.serverMessage]);
}

/// 422 — field → messages, ready to show under form fields.
final class ValidationException extends AppException {
  const ValidationException(this.fieldErrors, [super.serverMessage]);

  final Map<String, List<String>> fieldErrors;

  String? firstErrorFor(String field) => fieldErrors[field]?.firstOrNull;
}

/// 429.
final class RateLimitedException extends AppException {
  const RateLimitedException({this.retryAfter, String? serverMessage}) : super(serverMessage);

  final Duration? retryAfter;
}

/// 4xx domain errors with a server-provided message (e.g. 423 account suspended).
final class ClientException extends AppException {
  const ClientException(this.statusCode, [super.serverMessage]);

  final int statusCode;
}

/// 5xx.
final class ServerException extends AppException {
  const ServerException([super.serverMessage]);
}

/// Malformed response or anything unexpected.
final class UnknownException extends AppException {
  const UnknownException([super.serverMessage]);
}
