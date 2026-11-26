import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/errors/error_mapper.dart';

DioException responseError(int status, Object? body, {Map<String, List<String>>? headers}) {
  final options = RequestOptions(path: '/x');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: options,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: body,
      headers: Headers.fromMap(headers ?? {}),
    ),
  );
}

void main() {
  group('mapDioException', () {
    test('maps 422 to ValidationException with field errors', () {
      final e = mapDioException(
        responseError(422, {
          'success': false,
          'message': 'Validation failed.',
          'errors': {
            'score': ['The score field must be between 1 and 10.'],
          },
        }),
      );

      expect(e, isA<ValidationException>());
      final v = e as ValidationException;
      expect(v.serverMessage, 'Validation failed.');
      expect(v.firstErrorFor('score'), 'The score field must be between 1 and 10.');
      expect(v.firstErrorFor('missing'), isNull);
    });

    test('maps auth, permission and not-found statuses', () {
      expect(mapDioException(responseError(401, null)), isA<UnauthorizedException>());
      expect(mapDioException(responseError(403, null)), isA<ForbiddenException>());
      expect(mapDioException(responseError(404, null)), isA<NotFoundException>());
    });

    test('maps 429 with Retry-After', () {
      final e = mapDioException(
        responseError(
          429,
          {'success': false, 'message': 'Too many requests.'},
          headers: {
            'retry-after': ['42'],
          },
        ),
      );
      expect((e as RateLimitedException).retryAfter, const Duration(seconds: 42));
    });

    test('keeps server message for other 4xx domain errors', () {
      final e = mapDioException(responseError(423, {'success': false, 'message': 'Suspended.'}));
      expect(e, isA<ClientException>());
      expect((e as ClientException).statusCode, 423);
      expect(e.serverMessage, 'Suspended.');
    });

    test('maps 5xx to ServerException', () {
      expect(mapDioException(responseError(500, null)), isA<ServerException>());
      expect(mapDioException(responseError(503, null)), isA<ServerException>());
    });

    test('maps transport failures', () {
      final options = RequestOptions(path: '/x');
      expect(
        mapDioException(
          DioException.connectionTimeout(
            timeout: Duration.zero,
            requestOptions: options,
          ),
        ),
        isA<RequestTimeoutException>(),
      );
      expect(
        mapDioException(DioException.connectionError(requestOptions: options, reason: 'x')),
        isA<NetworkException>(),
      );
    });

    test('tolerates non-JSON error bodies', () {
      final e = mapDioException(responseError(500, '<html>oops</html>'));
      expect(e, isA<ServerException>());
      expect(e.serverMessage, isNull);
    });
  });
}
