import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mindful/core/notifications/local_reminders.dart';
import 'package:mindful/core/storage/token_storage.dart';

/// Records what would be scheduled instead of touching the OS.
class FakeLocalReminders implements LocalReminders {
  List<ReminderSlot> scheduled = [];
  String? title;
  String? body;
  int cancelAllCalls = 0;
  int permissionRequests = 0;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return true;
  }

  @override
  Future<void> replaceAll(
    List<ReminderSlot> slots, {
    required String title,
    required String body,
  }) async {
    scheduled = [...slots];
    this.title = title;
    this.body = body;
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCalls++;
    scheduled = [];
  }
}

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
