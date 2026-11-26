import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Finishes onboarding: saves privacy choices, then the profile (which marks setup
/// complete on the server — the router then moves on to home).
final NotifierProvider<ProfileSetupController, AsyncValue<void>> profileSetupControllerProvider =
    NotifierProvider.autoDispose<ProfileSetupController, AsyncValue<void>>(
      ProfileSetupController.new,
    );

class ProfileSetupController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> complete({
    required String username,
    required String avatar,
    required String bio,
    required PrivacySettings privacy,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updatePrivacy(privacy);
      final profile = await repo.updateProfile(username: username, avatar: avatar, bio: bio);
      ref.read(currentProfileProvider.notifier).set(profile);
    });
    if (ref.mounted) state = result;
  }
}

/// Live username availability while typing (debounced).
sealed class UsernameCheck {
  const UsernameCheck();
}

final class UsernameCheckIdle extends UsernameCheck {
  const UsernameCheckIdle();
}

final class UsernameCheckPending extends UsernameCheck {
  const UsernameCheckPending();
}

final class UsernameCheckResult extends UsernameCheck {
  const UsernameCheckResult(this.availability);

  final UsernameAvailability availability;
}

final NotifierProvider<UsernameChecker, UsernameCheck> usernameCheckProvider =
    NotifierProvider.autoDispose<UsernameChecker, UsernameCheck>(
      UsernameChecker.new,
    );

class UsernameChecker extends Notifier<UsernameCheck> {
  static const debounce = Duration(milliseconds: 450);

  Timer? _timer;

  @override
  UsernameCheck build() {
    ref.onDispose(() => _timer?.cancel());
    return const UsernameCheckIdle();
  }

  /// The user's current username needs no check.
  void check(String username, {String? current}) {
    _timer?.cancel();
    final value = username.trim();

    if (value.isEmpty || value == current) {
      state = const UsernameCheckIdle();
      return;
    }

    state = const UsernameCheckPending();
    _timer = Timer(debounce, () async {
      try {
        final result = await ref.read(profileRepositoryProvider).checkUsername(value);
        // Ignore stale answers for text the user has since changed.
        if (ref.mounted && result.username == value) state = UsernameCheckResult(result);
      } on Object {
        // Network trouble: don't block typing; the server validates on save.
        if (ref.mounted) state = const UsernameCheckIdle();
      }
    });
  }
}

/// "Shuffle" suggestions; cached per screen so each tap is instant.
final FutureProvider<List<String>> usernameSuggestionsProvider =
    FutureProvider.autoDispose<List<String>>(
      (ref) => ref.read(profileRepositoryProvider).suggestUsernames(),
    );
