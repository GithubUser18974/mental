import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/providers/social_providers.dart';

/// Report a post, comment or profile (FR-COM-010). Confirms with the server's message;
/// for possible-crisis reasons also shows a supportive safety note (FR-SAFETY-002).
Future<void> showReportSheet(
  BuildContext context, {
  required ReportTargetType type,
  required String targetId,
}) async {
  final receipt = await showModalBottomSheet<ReportReceipt>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReportSheet(type: type, targetId: targetId),
  );
  if (receipt == null || !context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(receipt.message)));
  if (receipt.crisisSupport) {
    final l10n = AppLocalizations.of(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(Icons.favorite_outline_rounded, color: context.palette.primary),
        title: Text(l10n.crisisTitle),
        content: Text(l10n.crisisBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );
  }
}

extension ReportReasonUi on ReportReason {
  String label(AppLocalizations l10n) => switch (this) {
    ReportReason.harassment => l10n.reportHarassment,
    ReportReason.dangerousMedicalAdvice => l10n.reportDangerousMedical,
    ReportReason.spam => l10n.reportSpam,
    ReportReason.selfHarmEncouragement => l10n.reportSelfHarm,
    ReportReason.suicidalContent => l10n.reportSuicidal,
    ReportReason.other => l10n.reportOther,
  };
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.type, required this.targetId});

  final ReportTargetType type;
  final String targetId;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  final _details = TextEditingController();
  ReportReason? _reason;
  bool _sending = false;
  bool _detailsMissing = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    final details = _details.text.trim();
    if (reason == ReportReason.other && details.isEmpty) {
      setState(() => _detailsMissing = true);
      return;
    }
    setState(() => _sending = true);
    try {
      final receipt = await ref
          .read(socialActionsProvider)
          .report(
            widget.type,
            widget.targetId,
            reason,
            details: details.isEmpty ? null : details,
          );
      if (mounted) Navigator.of(context).pop(receipt);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _sending = false);
      showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.reportTitle, style: context.textStyles.titleMedium),
              const SizedBox(height: AppSpacing.xxs),
              Text(l10n.reportSubtitle, style: context.textStyles.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              for (final reason in ReportReason.values)
                ListTile(
                  contentPadding: EdgeInsetsDirectional.zero,
                  selected: _reason == reason,
                  leading: Icon(
                    _reason == reason
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: _reason == reason ? p.primary : p.textTertiary,
                  ),
                  title: Text(reason.label(l10n), style: context.textStyles.labelLarge),
                  onTap: () => setState(() {
                    _reason = reason;
                    _detailsMissing = false;
                  }),
                ),
              if (_reason == ReportReason.other) ...[
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: _details,
                  maxLength: 500,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.reportDetails,
                    errorText: _detailsMissing ? l10n.reportDetailsRequired : null,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: l10n.reportSubmit,
                isLoading: _sending,
                onPressed: _reason == null ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
