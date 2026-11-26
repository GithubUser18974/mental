import 'dart:convert';

import 'package:dio/dio.dart';

import 'fakes.dart';

typedef FakeHandler = ResponseBody Function(RequestOptions request, Map<String, dynamic> body);

/// In-memory API: register handlers by `'METHOD /path'` and inspect what was sent.
class FakeBackend {
  FakeBackend() {
    adapter = FakeHttpAdapter(_handle);
  }

  late final FakeHttpAdapter adapter;
  final Map<String, FakeHandler> _routes = {};

  /// Decoded JSON bodies of every request, keyed like the routes.
  final List<(String route, Map<String, dynamic> body)> calls = [];

  void on(String route, FakeHandler handler) => _routes[route] = handler;

  /// Shortcut for a fixed success envelope.
  void ok(String route, Object? data, {int status = 200, String message = 'OK'}) =>
      on(route, (_, _) => jsonBody(status, {'success': true, 'message': message, 'data': data}));

  /// Query parameters (as strings) of every request, keyed like the routes.
  final List<(String route, Map<String, String> query)> queries = [];

  /// Query of the most recent call to [route].
  Map<String, String>? lastQuery(String route) => [
    for (final (r, q) in queries)
      if (r == route) q,
  ].lastOrNull;

  List<Map<String, dynamic>> bodiesFor(String route) => [
    for (final (r, b) in calls)
      if (r == route) b,
  ];

  ResponseBody _handle(RequestOptions request) {
    final path = request.path.startsWith('/') ? request.path : '/${request.path}';
    final route = '${request.method.toUpperCase()} $path';
    final raw = request.data;
    final body = switch (raw) {
      final Map<String, dynamic> m => m,
      final String s when s.isNotEmpty => jsonDecode(s) as Map<String, dynamic>,
      _ => <String, dynamic>{},
    };
    calls.add((route, body));
    queries.add((
      route,
      {for (final MapEntry(:key, :value) in request.queryParameters.entries) key: '$value'},
    ));

    final handler = _routes[route];
    if (handler == null) {
      return jsonBody(404, {'success': false, 'message': 'No fake for $route'});
    }
    return handler(request, body);
  }
}

Map<String, dynamic> profileJson({
  bool setupCompleted = false,
  String username = 'QuietRiver12',
  String avatar = 'lotus-lavender',
  String? bio,
  String visibility = 'public',
  String followPolicy = 'everyone',
  bool analytics = false,
}) => {
  'profile': {
    'id': 'profile-1',
    'username': username,
    'avatar': avatar,
    'bio': bio,
    'setup_completed': setupCompleted,
    'username_change_available_at': null,
    'joined_on': '2026-11-14',
  },
  'preferences': {'language': 'en', 'timezone': 'UTC'},
  'privacy': {
    'profile_visibility': visibility,
    'follow_policy': followPolicy,
    'analytics_consent': analytics,
  },
};

Map<String, dynamic> tokenJson({String token = 'new-token'}) => {
  'token': token,
  'token_type': 'Bearer',
  'expires_at': '2026-12-14T10:00:00Z',
  'account': {
    'id': 'account-1',
    'email': 'me@example.com',
    'email_verified': false,
    'status': 'active',
  },
};

ResponseBody validationError(Map<String, List<String>> errors) => jsonBody(422, {
  'success': false,
  'message': 'Validation failed.',
  'errors': errors,
});
