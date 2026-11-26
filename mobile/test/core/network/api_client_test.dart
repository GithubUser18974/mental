import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/fakes.dart';

Future<void> settle() async {
  for (var i = 0; i < 3; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  late FakeTokenStorage tokens;
  late ProviderContainer container;
  late FakeHttpAdapter adapter;

  Future<ProviderContainer> build(ResponseBody Function(RequestOptions) handler) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        tokenStorageProvider.overrideWithValue(tokens),
      ],
    );
    addTearDown(container.dispose);
    adapter = FakeHttpAdapter(handler);
    container.read(dioProvider).httpClientAdapter = adapter;
    container.read(authSessionProvider); // start session restore
    await settle();
    return container;
  }

  setUp(() => tokens = FakeTokenStorage('secret-token'));

  test('sends bearer token, JSON accept header and UI language', () async {
    await build(
      (_) => jsonBody(200, {'success': true, 'message': 'ok', 'data': <String, dynamic>{}}),
    );
    await container.read(localeControllerProvider.notifier).setLocale(AppLocales.ar);

    await container.read(apiClientProvider).get('/profile', parse: ApiData.object);

    final headers = adapter.requests.single.headers;
    expect(headers['Authorization'], 'Bearer secret-token');
    expect(headers['Accept'], 'application/json');
    expect(headers['Accept-Language'], 'ar');
  });

  test('omits the token for public endpoints', () async {
    await build((_) => jsonBody(200, {'success': true, 'message': 'ok', 'data': null}));

    await container
        .read(apiClientProvider)
        .post<Object?>(
          '/auth/login',
          parse: (d) => d,
          authenticated: false,
        );

    expect(adapter.requests.single.headers.containsKey('Authorization'), isFalse);
  });

  test('a 401 on an authenticated request clears the session', () async {
    await build((_) => jsonBody(401, {'success': false, 'message': 'Please sign in.'}));
    expect(container.read(authSessionProvider), AuthStatus.authenticated);

    await expectLater(
      container.read(apiClientProvider).get('/profile', parse: ApiData.object),
      throwsA(isA<UnauthorizedException>()),
    );
    await settle();

    expect(container.read(authSessionProvider), AuthStatus.unauthenticated);
    expect(tokens.token, isNull);
  });

  test('throws typed ValidationException for 422', () async {
    await build(
      (_) => jsonBody(422, {
        'success': false,
        'message': 'Validation failed.',
        'errors': {
          'score': ['Too high.'],
        },
      }),
    );

    await expectLater(
      container.read(apiClientProvider).post('/tracking/moods', parse: ApiData.object, body: {}),
      throwsA(
        isA<ValidationException>().having((e) => e.firstErrorFor('score'), 'score', 'Too high.'),
      ),
    );
  });

  test('retries idempotent GETs on connection errors, but never POSTs', () async {
    var calls = 0;
    await build((options) {
      calls++;
      throw DioException.connectionError(requestOptions: options, reason: 'offline');
    });

    await expectLater(
      container.read(apiClientProvider).get('/posts', parse: ApiData.list),
      throwsA(isA<NetworkException>()),
    );
    expect(calls, 3, reason: '1 attempt + 2 retries');

    calls = 0;
    await expectLater(
      container.read(apiClientProvider).post('/posts', parse: ApiData.object, body: {}),
      throwsA(isA<NetworkException>()),
    );
    expect(calls, 1);
  });

  test('turns malformed success bodies into UnknownException', () async {
    await build((_) => ResponseBody.fromString('not json', 200));

    await expectLater(
      container.read(apiClientProvider).get('/profile', parse: ApiData.object),
      throwsA(isA<UnknownException>()),
    );
  });
}
