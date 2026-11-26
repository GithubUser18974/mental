import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:mindful/core/security/auth_session.dart';
import 'package:mindful/core/security/sign_out.dart';
import 'package:mindful/core/storage/preferences.dart';
import 'package:mindful/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:mindful/features/authentication/presentation/providers/session_renewal.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-level wiring: plugs feature implementations into core extension points so core
/// code never imports features.
List<Override> appProviderOverrides(SharedPreferences prefs) => [
  sharedPreferencesProvider.overrideWithValue(prefs),
  sessionRenewerProvider.overrideWithValue(renewSessionIfNeeded),
  serverLogoutProvider.overrideWithValue((ref) => ref.read(authRepositoryProvider).logout()),
];
