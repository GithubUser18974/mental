/// Who can see the profile's details (bio). Username + avatar are always visible.
enum ProfileVisibility {
  public('public'),
  private('private')
  ;

  const ProfileVisibility(this.wire);

  final String wire;

  static ProfileVisibility fromWire(String value) =>
      values.firstWhere((v) => v.wire == value, orElse: () => ProfileVisibility.public);
}

/// Who may follow the profile.
enum FollowPolicy {
  everyone('everyone'),
  nobody('nobody')
  ;

  const FollowPolicy(this.wire);

  final String wire;

  static FollowPolicy fromWire(String value) =>
      values.firstWhere((v) => v.wire == value, orElse: () => FollowPolicy.everyone);
}

class ProfileInfo {
  const ProfileInfo({
    required this.id,
    required this.username,
    required this.avatar,
    required this.setupCompleted,
    this.bio,
    this.usernameChangeAvailableAt,
  });

  /// Anonymous profile id (never the account id).
  final String id;
  final String username;

  /// Avatar key `icon-color`, see `AvatarCatalog`.
  final String avatar;
  final String? bio;
  final bool setupCompleted;

  /// Null when the username can be changed now.
  final DateTime? usernameChangeAvailableAt;
}

class Preferences {
  const Preferences({required this.language, required this.timezone});

  final String language;
  final String timezone;
}

class PrivacySettings {
  const PrivacySettings({
    required this.profileVisibility,
    required this.followPolicy,
    required this.analyticsConsent,
  });

  /// Defaults used before the server answers: most private for optional processing.
  static const defaults = PrivacySettings(
    profileVisibility: ProfileVisibility.public,
    followPolicy: FollowPolicy.everyone,
    analyticsConsent: false,
  );

  final ProfileVisibility profileVisibility;
  final FollowPolicy followPolicy;
  final bool analyticsConsent;

  PrivacySettings copyWith({
    ProfileVisibility? profileVisibility,
    FollowPolicy? followPolicy,
    bool? analyticsConsent,
  }) => PrivacySettings(
    profileVisibility: profileVisibility ?? this.profileVisibility,
    followPolicy: followPolicy ?? this.followPolicy,
    analyticsConsent: analyticsConsent ?? this.analyticsConsent,
  );
}

/// The signed-in user's own identity and settings (`GET /profile`).
class OwnProfile {
  const OwnProfile({required this.profile, required this.preferences, required this.privacy});

  final ProfileInfo profile;
  final Preferences preferences;
  final PrivacySettings privacy;
}

enum UsernameUnavailableReason { invalid, reserved, taken }

class UsernameAvailability {
  const UsernameAvailability({required this.username, required this.available, this.reason});

  final String username;
  final bool available;
  final UsernameUnavailableReason? reason;
}
