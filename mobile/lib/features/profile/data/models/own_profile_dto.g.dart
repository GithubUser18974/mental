// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileInfoDto _$ProfileInfoDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ProfileInfoDto',
  json,
  ($checkedConvert) {
    final val = _ProfileInfoDto(
      id: $checkedConvert('id', (v) => v as String),
      username: $checkedConvert('username', (v) => v as String),
      avatar: $checkedConvert('avatar', (v) => v as String),
      setupCompleted: $checkedConvert('setup_completed', (v) => v as bool),
      bio: $checkedConvert('bio', (v) => v as String?),
      usernameChangeAvailableAt: $checkedConvert(
        'username_change_available_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'setupCompleted': 'setup_completed',
    'usernameChangeAvailableAt': 'username_change_available_at',
  },
);

Map<String, dynamic> _$ProfileInfoDtoToJson(_ProfileInfoDto instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatar': instance.avatar,
  'setup_completed': instance.setupCompleted,
  'bio': instance.bio,
  'username_change_available_at': instance.usernameChangeAvailableAt?.toIso8601String(),
};

_PreferencesDto _$PreferencesDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PreferencesDto', json, ($checkedConvert) {
      final val = _PreferencesDto(
        language: $checkedConvert('language', (v) => v as String),
        timezone: $checkedConvert('timezone', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PreferencesDtoToJson(_PreferencesDto instance) => <String, dynamic>{
  'language': instance.language,
  'timezone': instance.timezone,
};

_PrivacyDto _$PrivacyDtoFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_PrivacyDto',
  json,
  ($checkedConvert) {
    final val = _PrivacyDto(
      profileVisibility: $checkedConvert(
        'profile_visibility',
        (v) => v as String,
      ),
      followPolicy: $checkedConvert('follow_policy', (v) => v as String),
      analyticsConsent: $checkedConvert('analytics_consent', (v) => v as bool),
    );
    return val;
  },
  fieldKeyMap: const {
    'profileVisibility': 'profile_visibility',
    'followPolicy': 'follow_policy',
    'analyticsConsent': 'analytics_consent',
  },
);

Map<String, dynamic> _$PrivacyDtoToJson(_PrivacyDto instance) => <String, dynamic>{
  'profile_visibility': instance.profileVisibility,
  'follow_policy': instance.followPolicy,
  'analytics_consent': instance.analyticsConsent,
};

_OwnProfileDto _$OwnProfileDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_OwnProfileDto', json, ($checkedConvert) {
      final val = _OwnProfileDto(
        profile: $checkedConvert(
          'profile',
          (v) => ProfileInfoDto.fromJson(v as Map<String, dynamic>),
        ),
        preferences: $checkedConvert(
          'preferences',
          (v) => PreferencesDto.fromJson(v as Map<String, dynamic>),
        ),
        privacy: $checkedConvert(
          'privacy',
          (v) => PrivacyDto.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$OwnProfileDtoToJson(_OwnProfileDto instance) => <String, dynamic>{
  'profile': instance.profile.toJson(),
  'preferences': instance.preferences.toJson(),
  'privacy': instance.privacy.toJson(),
};
