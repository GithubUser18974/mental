import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/core/errors/app_exception.dart';

/// User-facing text for an [AppException].
extension AppExceptionL10n on AppException {
  String localizedMessage(AppLocalizations l10n) => switch (this) {
    NetworkException() => l10n.errorNetwork,
    RequestTimeoutException() => l10n.errorTimeout,
    UnauthorizedException() => l10n.errorUnauthorized,
    ForbiddenException() => l10n.errorForbidden,
    NotFoundException() => l10n.errorNotFound,
    ValidationException() => serverMessage ?? l10n.errorValidation,
    RateLimitedException() => l10n.errorRateLimited,
    // Domain errors carry a translated, data-free message from the API.
    ClientException() => serverMessage ?? l10n.errorUnknown,
    ServerException() => l10n.errorServer,
    UnknownException() => l10n.errorUnknown,
  };
}

/// For `AsyncValue.error` objects that may not be [AppException]s.
String errorMessageFor(Object error, AppLocalizations l10n) =>
    error is AppException ? error.localizedMessage(l10n) : l10n.errorUnknown;
