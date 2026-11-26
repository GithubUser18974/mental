import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/core/security/auth_session.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// One reminder at an absolute instant. The text is always generic (never a medication
/// name, dose or anything health-related — FR-MED-003, CLAUDE.md rule 6).
class ReminderSlot {
  const ReminderSlot({required this.id, required this.at});

  /// Stable id (same dose → same id).
  final int id;
  final DateTime at;
}

/// Device-local notifications for reminders. Behind an interface so tests use a fake.
abstract interface class LocalReminders {
  /// Asks the OS for permission to notify (Android 13+, iOS). Returns whether granted.
  Future<bool> requestPermission();

  /// Replaces every scheduled reminder with [slots], all showing [title] / [body].
  Future<void> replaceAll(List<ReminderSlot> slots, {required String title, required String body});

  Future<void> cancelAll();
}

final localRemindersProvider = Provider<LocalReminders>((ref) => PluginLocalReminders());

/// Cancels every reminder as soon as the session ends (sign-out or expiry) so nothing
/// from a previous account keeps firing on a shared device. Watched by the app root.
final remindersSessionGuardProvider = Provider<void>((ref) {
  ref.listen(authSessionProvider, (previous, next) {
    if (next == AuthStatus.unauthenticated && previous != AuthStatus.unauthenticated) {
      unawaited(ref.read(localRemindersProvider).cancelAll());
    }
  });
});

/// flutter_local_notifications implementation. Inexact scheduling (no exact-alarm
/// permission): a reminder may arrive a few minutes late, which is acceptable here.
class PluginLocalReminders implements LocalReminders {
  PluginLocalReminders([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  static const _channel = AndroidNotificationDetails(
    'reminders',
    'Reminders',
    channelDescription: 'Gentle reminders you set up in Y',
    importance: Importance.high,
    priority: Priority.high,
    // Nothing sensitive is shown, but keep it private on the lock screen anyway.
    visibility: NotificationVisibility.private,
  );

  Future<void> _init() => _ready ??= () async {
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();

  @override
  Future<bool> requestPermission() async {
    await _init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final granted =
        await android?.requestNotificationsPermission() ??
        await ios?.requestPermissions(alert: true, sound: true) ??
        false;
    return granted;
  }

  @override
  Future<void> replaceAll(
    List<ReminderSlot> slots, {
    required String title,
    required String body,
  }) async {
    await _init();
    await _plugin.cancelAll();
    const details = NotificationDetails(android: _channel, iOS: DarwinNotificationDetails());
    for (final slot in slots) {
      await _plugin.zonedSchedule(
        id: slot.id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(slot.at.toUtc(), tz.UTC),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  @override
  Future<void> cancelAll() async {
    await _init();
    await _plugin.cancelAll();
  }
}
