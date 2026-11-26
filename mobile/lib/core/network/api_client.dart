import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/errors/error_mapper.dart';
import 'package:mindful/core/network/api_config.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/core/network/interceptors.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/core/storage/token_storage.dart';

/// Test seam: replaces the network transport (e.g. with a fake backend). Null in the app.
final httpClientAdapterProvider = Provider<HttpClientAdapter?>((ref) => null);

/// Configured [Dio] instance shared by all data sources.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      contentType: Headers.jsonContentType,
      headers: {'Accept': 'application/json'},
    ),
  );

  final adapter = ref.watch(httpClientAdapterProvider);
  if (adapter != null) dio.httpClientAdapter = adapter;

  dio.interceptors.addAll([
    LocaleInterceptor(() => effectiveLanguageCode(ref.read(localeControllerProvider))),
    AuthInterceptor(
      readToken: () => ref.read(tokenStorageProvider).readToken(),
      onUnauthorized: () => ref.read(authSessionProvider.notifier).onSessionExpired(),
    ),
    RetryInterceptor(dio),
    // Debug only: method/URL/status/errors. Never options, headers or bodies — they may hold tokens or health data.
    if (kDebugMode) LogInterceptor(request: false, requestHeader: false, responseHeader: false),
  ]);

  ref.onDispose(dio.close);
  return dio;
});

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(dioProvider)));

/// Thin wrapper over [Dio]: parses the API envelope and converts every failure
/// into a typed [AppException].
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<ApiEnvelope<T>> get<T>(
    String path, {
    required T Function(Object? data) parse,
    Map<String, dynamic>? query,
    bool authenticated = true,
  }) => _send(
    () => _dio.get<Object?>(path, queryParameters: query, options: _options(authenticated)),
    parse,
  );

  Future<ApiEnvelope<T>> post<T>(
    String path, {
    required T Function(Object? data) parse,
    Object? body,
    bool authenticated = true,
  }) => _send(() => _dio.post<Object?>(path, data: body, options: _options(authenticated)), parse);

  Future<ApiEnvelope<T>> put<T>(
    String path, {
    required T Function(Object? data) parse,
    Object? body,
  }) => _send(() => _dio.put<Object?>(path, data: body), parse);

  Future<ApiEnvelope<T>> patch<T>(
    String path, {
    required T Function(Object? data) parse,
    Object? body,
  }) => _send(() => _dio.patch<Object?>(path, data: body), parse);

  /// POST endpoints that answer `204 No Content` (bookmarks, follows, blocks).
  Future<void> postNoContent(String path, {Object? body}) async {
    try {
      await _dio.post<Object?>(path, data: body);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  /// DELETE endpoints return `204 No Content`.
  Future<void> delete(String path) async {
    try {
      await _dio.delete<Object?>(path);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Options _options(bool authenticated) =>
      Options(extra: {AuthInterceptor.skipAuth: !authenticated});

  Future<ApiEnvelope<T>> _send<T>(
    Future<Response<Object?>> Function() request,
    T Function(Object? data) parse,
  ) async {
    try {
      final response = await request();
      final body = response.data;
      if (body is! Map<String, dynamic>) throw const UnknownException();
      return ApiEnvelope.fromJson(body, parse);
    } on DioException catch (e) {
      throw mapDioException(e);
    } on AppException {
      rethrow;
    } on Object {
      // Parsing failure: never surface raw payloads.
      throw const UnknownException();
    }
  }
}
