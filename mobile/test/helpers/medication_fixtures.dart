import 'community_fixtures.dart';
import 'fake_backend.dart';

/// JSON shaped exactly like the API's medication resources.
Map<String, dynamic> medicationJson({
  String id = 'med1',
  String name = 'Sertraline',
  String status = 'active',
  bool reminders = true,
  Map<String, dynamic>? schedule,
}) => {
  'id': id,
  'name': name,
  'dosage': '50',
  'unit': 'mg',
  'start_date': '2026-11-01',
  'end_date': null,
  'instructions': null,
  'clinician': null,
  'notes': null,
  'reminders_enabled': reminders,
  'status': status,
  'is_current': status != 'discontinued',
  'discontinued_at': null,
  'schedule':
      schedule ??
      {
        'type': 'daily',
        'times': ['08:00', '20:00'],
        'days_of_week': null,
        'interval_days': null,
      },
  'created_at': '2026-11-01T10:00:00Z',
  'updated_at': '2026-11-01T10:00:00Z',
};

Map<String, dynamic> doseJson({
  required DateTime at,
  String medicationId = 'med1',
  bool reminder = true,
  Map<String, dynamic>? log,
}) => {
  'medication_id': medicationId,
  'scheduled_at': at.toUtc().toIso8601String(),
  'reminder': reminder,
  'log': log,
};

Map<String, dynamic> intakeLogJson({String status = 'taken', DateTime? at}) => {
  'id': 'log1',
  'medication_id': 'med1',
  'status': status,
  'scheduled_at': (at ?? DateTime.now()).toUtc().toIso8601String(),
  'taken_at': status == 'taken' ? DateTime.now().toUtc().toIso8601String() : null,
  'notes': null,
  'created_at': DateTime.now().toUtc().toIso8601String(),
};

extension MedicationFakes on FakeBackend {
  void medsHome({List<Object?> current = const [], List<Object?> doses = const []}) {
    okPage('GET /medications', current);
    ok('GET /medications/doses', doses);
  }
}
