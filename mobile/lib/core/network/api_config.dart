/// API connection settings, injected at build time:
///
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1`
///
/// Default targets the local Docker backend from the Android emulator
/// (`10.0.2.2` = host machine). iOS simulator: use `http://localhost:8000/api/v1`.
abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Retries for idempotent requests on transient network failures.
  static const int maxRetries = 2;
}
