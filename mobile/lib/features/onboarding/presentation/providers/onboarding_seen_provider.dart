import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/storage/preferences.dart';

/// Whether the intro carousel has been shown on this device (non-sensitive preference).
final onboardingSeenProvider = NotifierProvider<OnboardingSeen, bool>(OnboardingSeen.new);

class OnboardingSeen extends Notifier<bool> {
  @override
  bool build() => ref.read(sharedPreferencesProvider).getBool(PrefKeys.onboardingSeen) ?? false;

  Future<void> markSeen() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(PrefKeys.onboardingSeen, true);
  }
}
