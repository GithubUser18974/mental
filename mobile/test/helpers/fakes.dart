import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mindful/core/storage/token_storage.dart';

/// In-memory [TokenStorage] (no platform channel).
class FakeTokenStorage implements TokenStorage {
  FakeTokenStorage([this.token, this.expiresAt]);

  String? token;
  DateTime? expiresAt;
  int clearCalls = 0;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<DateTime?> readExpiresAt() async => expiresAt;

  @override
  Future<void> writeToken(String value, {DateTime? expiresAt}) async {
    token = value;
    this.expiresAt = expiresAt;
  }

  @override
  Future<void> clear() async {
    token = null;
    expiresAt = null;
    clearCalls++;
  }
}

/// Dio adapter that answers requests with [handler] and records them.
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(int status, Object body, {Map<String, List<String>> headers = const {}}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        ...headers,
      },
    );
