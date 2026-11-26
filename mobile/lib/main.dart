import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/app.dart';
import 'package:mindful/app/provider_overrides.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      // Screens show errors with an explicit "Try again"; no silent automatic retries.
      retry: (_, _) => null,
      overrides: appProviderOverrides(prefs),
      child: const YApp(),
    ),
  );
}
