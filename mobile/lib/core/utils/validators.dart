import 'package:mindful/app/localization/generated/app_localizations.dart';

/// Client-side checks mirroring the API rules (the server re-validates everything).
abstract final class Validators {
  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _letter = RegExp(r'\p{L}', unicode: true);
  static final RegExp _digit = RegExp(r'\d');

  /// Mirrors the backend `UsernamePolicy::PATTERN`.
  static final RegExp username = RegExp(r'^[A-Za-z][A-Za-z0-9_]{2,19}$');

  static const int passwordMinLength = 10;

  static String? email(String? value, AppLocalizations l10n) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return l10n.validationEmailRequired;
    if (!_email.hasMatch(v)) return l10n.validationEmailInvalid;
    return null;
  }

  /// Only "present" — used on sign-in, where the policy must not be hinted.
  static String? passwordPresent(String? value, AppLocalizations l10n) =>
      (value == null || value.isEmpty) ? l10n.validationPasswordRequired : null;

  /// Full policy — registration and reset.
  static String? newPassword(String? value, AppLocalizations l10n) {
    final v = value ?? '';
    if (v.isEmpty) return l10n.validationPasswordRequired;
    if (v.length < passwordMinLength || !_letter.hasMatch(v) || !_digit.hasMatch(v)) {
      return l10n.validationPasswordRules;
    }
    return null;
  }

  static String? confirmation(String? value, String original, AppLocalizations l10n) =>
      value == original ? null : l10n.validationPasswordMismatch;

  static String? usernameFormat(String? value, AppLocalizations l10n) =>
      username.hasMatch(value?.trim() ?? '') ? null : l10n.usernameInvalid;
}
