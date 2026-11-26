import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/core/errors/app_exception_l10n.dart';

/// Shows a localized, data-free error message for any error object.
void showErrorSnackBar(BuildContext context, Object error) {
  final message = errorMessageFor(error, AppLocalizations.of(context));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
