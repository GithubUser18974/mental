import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/time/device_timezone.dart';
import 'package:mindful/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Keeps the account's timezone in step with the device, so day boundaries, streaks and
/// medication dose times follow the member when they travel (FR-MED-003).
///
/// Best effort, and at most one attempt per device timezone per session — storing the
/// updated profile triggers this listener again, so without the guard a server that
/// answered with a different value would loop forever. Watched by the app shell.
final timezoneSyncProvider = Provider<void>((ref) {
  String? attempted;

  ref.listen(currentProfileProvider, (_, next) {
    final profile = next.value;
    if (profile == null) return;
    unawaited(() async {
      try {
        final device = await ref.read(deviceTimezoneProvider)();
        if (device.isEmpty || device == profile.preferences.timezone || device == attempted) {
          return;
        }
        attempted = device;
        final updated = await ref
            .read(profileRepositoryProvider)
            .updatePreferences(timezone: device);
        if (ref.mounted) ref.read(currentProfileProvider.notifier).set(updated);
      } on Object {
        // Offline / plugin unavailable: tried again after the next sign-in.
      }
    }());
  }, fireImmediately: true);
});
