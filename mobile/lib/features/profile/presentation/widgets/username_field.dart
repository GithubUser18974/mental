import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/utils/validators.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';
import 'package:mindful/features/profile/presentation/providers/profile_setup_controllers.dart';

/// Username input with live availability and a "suggest another" button.
class UsernameField extends ConsumerWidget {
  const UsernameField({
    required this.controller,
    required this.currentUsername,
    required this.onShuffle,
    this.serverError,
    super.key,
  });

  final TextEditingController controller;

  /// The user's existing username (always counts as available).
  final String currentUsername;
  final VoidCallback onShuffle;
  final String? serverError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final check = ref.watch(usernameCheckProvider);

    final (String? helper, String? error) = switch (check) {
      UsernameCheckPending() => (l10n.usernameChecking, null),
      UsernameCheckResult(:final availability) when availability.available => (
        l10n.usernameAvailable,
        null,
      ),
      UsernameCheckResult(:final availability) => (
        null,
        switch (availability.reason) {
          UsernameUnavailableReason.taken => l10n.usernameTaken,
          UsernameUnavailableReason.reserved => l10n.usernameReserved,
          _ => l10n.usernameInvalid,
        },
      ),
      UsernameCheckIdle() => (l10n.usernameHelper, null),
    };

    return AppTextField(
      label: l10n.fieldUsername,
      controller: controller,
      helper: helper,
      errorText: serverError ?? error,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_]')),
        LengthLimitingTextInputFormatter(20),
      ],
      validator: (v) => Validators.usernameFormat(v, l10n),
      onChanged: (v) => ref.read(usernameCheckProvider.notifier).check(v, current: currentUsername),
      suffix: IconButton(
        tooltip: l10n.shuffleUsername,
        icon: Icon(Icons.casino_outlined, color: p.primary),
        onPressed: onShuffle,
      ),
    );
  }
}
