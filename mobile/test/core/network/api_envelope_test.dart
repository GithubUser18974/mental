import 'package:flutter_test/flutter_test.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/network/api_envelope.dart';

void main() {
  test('parses a success envelope with object data', () {
    final env = ApiEnvelope.fromJson({
      'success': true,
      'message': 'Mood entry created successfully',
      'data': {'id': 'uuid', 'score': 7},
    }, ApiData.object);

    expect(env.message, 'Mood entry created successfully');
    expect(env.data['score'], 7);
    expect(env.pagination, isNull);
  });

  test('parses cursor pagination meta', () {
    final env = ApiEnvelope.fromJson({
      'success': true,
      'message': 'OK',
      'data': [
        {'id': 'a'},
        {'id': 'b'},
      ],
      'meta': {
        'pagination': {'per_page': 2, 'next_cursor': 'abc', 'prev_cursor': null, 'has_more': true},
      },
    }, ApiData.list);

    expect(env.data, hasLength(2));
    expect(env.pagination?.perPage, 2);
    expect(env.pagination?.nextCursor, 'abc');
    expect(env.pagination?.hasMore, isTrue);
  });

  test('rejects envelopes that are not successful or have the wrong data shape', () {
    expect(
      () => ApiEnvelope.fromJson({'success': false, 'message': 'x'}, ApiData.object),
      throwsA(isA<UnknownException>()),
    );
    expect(
      () => ApiEnvelope.fromJson({'success': true, 'message': 'x', 'data': 'str'}, ApiData.object),
      throwsA(isA<UnknownException>()),
    );
  });
}
