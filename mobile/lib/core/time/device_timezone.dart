import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

/// The device's IANA timezone (e.g. "Africa/Cairo"). Overridden in tests.
typedef DeviceTimezoneReader = Future<String> Function();

final deviceTimezoneProvider = Provider<DeviceTimezoneReader>(
  (ref) =>
      () async => (await FlutterTimezone.getLocalTimezone()).identifier,
);
