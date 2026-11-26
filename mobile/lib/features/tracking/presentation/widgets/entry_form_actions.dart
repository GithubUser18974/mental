import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/primary_button.dart';

/// Pinned Save (+ Delete when editing) for tracking entry forms. Saving / deleting shows
/// a short confirmation and closes the form; failures show a calm error and keep input.
class EntryFormActions extends StatelessWidget {
  const EntryFormActions({
    required this.busy,
    required this.onSave,
    this.onDelete,
    super.key,
  });

  final bool busy;
  final VoidCallback onSave;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryButton(label: l10n.saveEntry, isLoading: busy, onPressed: onSave),
        if (onDelete != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          TextButton(
            onPressed: busy ? null : onDelete,
            child: Text(
              l10n.deleteEntry,
              style: context.textStyles.labelLarge?.copyWith(color: context.palette.danger),
            ),
          ),
        ],
      ],
    );
  }
}

/// Runs [action]; on success confirms with [message] and closes the page.
/// Returns false (after showing the error) when it failed.
Future<bool> runEntryAction(
  BuildContext context,
  Future<void> Function() action, {
  required String message,
}) async {
  try {
    await action();
    if (!context.mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    context.pop();
    return true;
  } on Object catch (error) {
    if (context.mounted) showErrorSnackBar(context, error);
    return false;
  }
}

/// "Delete this entry?" confirmation.
Future<bool> confirmEntryDelete(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteEntryConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.actionCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.actionDelete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
