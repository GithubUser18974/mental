import 'package:mindful/features/profile/domain/entities/own_profile.dart';

/// Own anonymous identity & settings. Implementations throw `AppException`s.
abstract interface class ProfileRepository {
  Future<OwnProfile> getOwnProfile();

  /// Partial update; the first call completes profile setup.
  Future<OwnProfile> updateProfile({String? username, String? avatar, String? bio});

  Future<OwnProfile> updatePrivacy(PrivacySettings privacy);

  /// Language and/or IANA timezone (dates, streaks and reminders follow it).
  Future<OwnProfile> updatePreferences({String? language, String? timezone});

  Future<UsernameAvailability> checkUsername(String username);

  Future<List<String>> suggestUsernames();
}
