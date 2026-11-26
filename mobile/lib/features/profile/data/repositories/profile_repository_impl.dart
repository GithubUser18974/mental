import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/network/api_client.dart';
import 'package:mindful/core/network/api_envelope.dart';
import 'package:mindful/features/profile/data/models/own_profile_dto.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';
import 'package:mindful/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(apiClientProvider)),
);

/// Remote implementation over `/api/v1/profile/*`.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._api);

  final ApiClient _api;

  static OwnProfile _own(Object? data) => OwnProfileDto.fromJson(ApiData.object(data)).toEntity();

  @override
  Future<OwnProfile> getOwnProfile() async => (await _api.get('/profile', parse: _own)).data;

  @override
  Future<OwnProfile> updateProfile({String? username, String? avatar, String? bio}) async {
    final body = <String, dynamic>{
      'username': ?username,
      'avatar': ?avatar,
      // Empty string clears the bio on the server.
      'bio': ?bio,
    };
    return (await _api.put('/profile', parse: _own, body: body)).data;
  }

  @override
  Future<OwnProfile> updatePrivacy(PrivacySettings privacy) async {
    final envelope = await _api.put(
      '/profile/privacy',
      parse: _own,
      body: {
        'profile_visibility': privacy.profileVisibility.wire,
        'follow_policy': privacy.followPolicy.wire,
        'analytics_consent': privacy.analyticsConsent,
      },
    );
    return envelope.data;
  }

  @override
  Future<UsernameAvailability> checkUsername(String username) async {
    final envelope = await _api.get(
      '/profile/username-availability',
      query: {'username': username},
      parse: (data) {
        final json = ApiData.object(data);
        final reason = json['reason'];
        return UsernameAvailability(
          username: json['username'] as String? ?? username,
          available: json['available'] == true,
          reason: UsernameUnavailableReason.values.where((r) => r.name == reason).firstOrNull,
        );
      },
    );
    return envelope.data;
  }

  @override
  Future<List<String>> suggestUsernames() async {
    final envelope = await _api.get(
      '/profile/username-suggestions',
      parse: (data) => (ApiData.object(data)['usernames'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
    );
    return envelope.data;
  }
}
