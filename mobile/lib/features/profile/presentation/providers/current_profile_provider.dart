import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';

/// The signed-in user's own profile. `null` when signed out. Rebuilds (and is
/// therefore wiped) whenever the auth state changes — no data survives a sign-out.
final currentProfileProvider = AsyncNotifierProvider<CurrentProfile, OwnProfile?>(
  CurrentProfile.new,
);

class CurrentProfile extends AsyncNotifier<OwnProfile?> {
  @override
  Future<OwnProfile?> build() async {
    final status = ref.watch(authSessionProvider);
    if (status != AuthStatus.authenticated) return null;
    return ref.read(profileRepositoryProvider).getOwnProfile();
  }

  /// Replace the cached profile after a successful update.
  void set(OwnProfile profile) => state = AsyncData(profile);
}

/// Whether the signed-in user still has to finish profile setup (drives routing).
enum SetupStatus { unknown, required, completed }

final setupStatusProvider = Provider<SetupStatus>((ref) {
  final profile = ref.watch(currentProfileProvider).value;
  if (profile == null) return SetupStatus.unknown;
  return profile.profile.setupCompleted ? SetupStatus.completed : SetupStatus.required;
});
