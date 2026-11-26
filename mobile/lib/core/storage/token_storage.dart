import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  ),
);

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => TokenStorage(ref.watch(secureStorageProvider)),
);

/// Auth token persistence — Keychain / Android Keystore only. Never logged,
/// never in SharedPreferences.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _expiresAtKey = 'auth_token_expires_at';

  String? _cachedToken;
  DateTime? _cachedExpiresAt;
  bool _loaded = false;

  Future<void> _load() async {
    if (_loaded) return;
    _cachedToken = await _storage.read(key: _tokenKey);
    final expires = await _storage.read(key: _expiresAtKey);
    _cachedExpiresAt = expires == null ? null : DateTime.tryParse(expires);
    _loaded = true;
  }

  Future<String?> readToken() async {
    await _load();
    return _cachedToken;
  }

  /// When the stored token expires (UTC), if known.
  Future<DateTime?> readExpiresAt() async {
    await _load();
    return _cachedExpiresAt;
  }

  Future<void> writeToken(String token, {DateTime? expiresAt}) async {
    await _storage.write(key: _tokenKey, value: token);
    if (expiresAt != null) {
      await _storage.write(key: _expiresAtKey, value: expiresAt.toUtc().toIso8601String());
    } else {
      await _storage.delete(key: _expiresAtKey);
    }
    _cachedToken = token;
    _cachedExpiresAt = expiresAt?.toUtc();
    _loaded = true;
  }

  /// Wipes everything in secure storage (logout / account deletion).
  Future<void> clear() async {
    await _storage.deleteAll();
    _cachedToken = null;
    _cachedExpiresAt = null;
    _loaded = true;
  }
}
