import 'package:dio/dio.dart';
import 'package:mindful/core/network/api_config.dart';

/// Attaches the bearer token and reports 401s on authenticated requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken, required this.onUnauthorized});

  final Future<String?> Function() readToken;
  final Future<void> Function() onUnauthorized;

  /// Set `options.extra[AuthInterceptor.skipAuth] = true` for public endpoints (login, register).
  static const String skipAuth = 'skipAuth';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[skipAuth] != true) {
      final token = await readToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final sentToken = err.requestOptions.headers.containsKey('Authorization');
    if (err.response?.statusCode == 401 && sentToken) {
      await onUnauthorized();
    }
    handler.next(err);
  }
}

/// Sends the UI language so the API localizes messages (ar / en).
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor(this.languageCode);

  final String Function() languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = languageCode();
    handler.next(options);
  }
}

/// Retries idempotent requests (GET/PUT/DELETE/HEAD) on transient network errors.
/// Never retries POST/PATCH — they may create duplicate records.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this.dio, {this.maxRetries = ApiConfig.maxRetries});

  final Dio dio;
  final int maxRetries;

  static const _attemptKey = 'retryAttempt';
  static const _idempotent = {'GET', 'PUT', 'DELETE', 'HEAD'};

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;

    if (!_shouldRetry(err) || attempt >= maxRetries) {
      return handler.next(err);
    }

    options.extra[_attemptKey] = attempt + 1;
    await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));

    try {
      handler.resolve(await dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    if (!_idempotent.contains(err.requestOptions.method.toUpperCase())) return false;
    return switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.badResponse => (err.response?.statusCode ?? 0) == 503,
      _ => false,
    };
  }
}
