import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/features/medication/domain/entities/medication.dart';
import 'package:mindful/features/medication/presentation/widgets/medication_labels.dart';

/// A medication in a list: name, dose, schedule summary and status.
class MedicationTile extends StatelessWidget {
  const MedicationTile({required this.medication, super.key});

  final Medication medication;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final m = medication;
    final badges = [
      if (m.status == MedicationStatus.paused) l10n.medPaused,
      if (m.status == MedicationStatus.discontinued) l10n.medDiscontinued,
      if (!m.remindersEnabled && m.status == MedicationStatus.active) l10n.remindersOff,
    ];

    return AppCard(
      onTap: () => context.push(AppRoutes.medicationPath(m.id)),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(color: p.primarySoft, borderRadius: AppRadius.smAll),
            child: SizedBox.square(
              dimension: AppSizes.actionWell,
              child: Icon(Icons.medication_outlined, color: p.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${m.name} · ${doseLabel(l10n, m)}',
                  style: context.textStyles.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(scheduleSummary(context, m.schedule), style: context.textStyles.bodySmall),
                if (badges.isNotEmpty)
                  Text(
                    badges.join(' · '),
                    style: context.textStyles.labelMedium?.copyWith(color: p.primary),
                  ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: p.textTertiary),
        ],
      ),
    );
  }
}
