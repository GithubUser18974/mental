import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';

part 'own_profile_dto.freezed.dart';
part 'own_profile_dto.g.dart';

@freezed
abstract class ProfileInfoDto with _$ProfileInfoDto {
  const factory ProfileInfoDto({
    required String id,
    required String username,
    required String avatar,
    required bool setupCompleted,
    String? bio,
    DateTime? usernameChangeAvailableAt,
  }) = _ProfileInfoDto;

  factory ProfileInfoDto.fromJson(Map<String, dynamic> json) => _$ProfileInfoDtoFromJson(json);
}

@freezed
abstract class PreferencesDto with _$PreferencesDto {
  const factory PreferencesDto({required String language, required String timezone}) =
      _PreferencesDto;

  factory PreferencesDto.fromJson(Map<String, dynamic> json) => _$PreferencesDtoFromJson(json);
}

@freezed
abstract class PrivacyDto with _$PrivacyDto {
  const factory PrivacyDto({
    required String profileVisibility,
    required String followPolicy,
    required bool analyticsConsent,
  }) = _PrivacyDto;

  factory PrivacyDto.fromJson(Map<String, dynamic> json) => _$PrivacyDtoFromJson(json);
}

@freezed
abstract class OwnProfileDto with _$OwnProfileDto {
  const factory OwnProfileDto({
    required ProfileInfoDto profile,
    required PreferencesDto preferences,
    required PrivacyDto privacy,
  }) = _OwnProfileDto;

  const OwnProfileDto._();

  factory OwnProfileDto.fromJson(Map<String, dynamic> json) => _$OwnProfileDtoFromJson(json);

  OwnProfile toEntity() => OwnProfile(
    profile: ProfileInfo(
      id: profile.id,
      username: profile.username,
      avatar: profile.avatar,
      bio: profile.bio,
      setupCompleted: profile.setupCompleted,
      usernameChangeAvailableAt: profile.usernameChangeAvailableAt?.toUtc(),
    ),
    preferences: Preferences(language: preferences.language, timezone: preferences.timezone),
    privacy: PrivacySettings(
      profileVisibility: ProfileVisibility.fromWire(privacy.profileVisibility),
      followPolicy: FollowPolicy.fromWire(privacy.followPolicy),
      analyticsConsent: privacy.analyticsConsent,
    ),
  );
}
