import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/pill_option.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';

/// FR-ONB-003 privacy choices. Reused by settings later (T10.2).
class PrivacyOptions extends StatelessWidget {
  const PrivacyOptions({required this.value, required this.onChanged, super.key});

  final PrivacySettings value;
  final ValueChanged<PrivacySettings> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Label(l10n.privacyVisibilityLabel),
        _VisibilityCard(
          title: l10n.privacyVisibilityPublic,
          description: l10n.privacyVisibilityPublicDesc,
          icon: Icons.public_rounded,
          selected: value.profileVisibility == ProfileVisibility.public,
          onTap: () => onChanged(value.copyWith(profileVisibility: ProfileVisibility.public)),
        ),
        const SizedBox(height: AppSpacing.sm),
        _VisibilityCard(
          title: l10n.privacyVisibilityPrivate,
          description: l10n.privacyVisibilityPrivateDesc,
          icon: Icons.lock_outline_rounded,
          selected: value.profileVisibility == ProfileVisibility.private,
          onTap: () => onChanged(value.copyWith(profileVisibility: ProfileVisibility.private)),
        ),
        const SizedBox(height: AppSpacing.xl),
        _Label(l10n.privacyFollowLabel),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            PillOption(
              label: l10n.privacyFollowEveryone,
              selected: value.followPolicy == FollowPolicy.everyone,
              onTap: () => onChanged(value.copyWith(followPolicy: FollowPolicy.everyone)),
            ),
            PillOption(
              label: l10n.privacyFollowNobody,
              selected: value.followPolicy == FollowPolicy.nobody,
              onTap: () => onChanged(value.copyWith(followPolicy: FollowPolicy.nobody)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          child: SwitchListTile.adaptive(
            contentPadding: EdgeInsetsDirectional.zero,
            value: value.analyticsConsent,
            onChanged: (v) => onChanged(value.copyWith(analyticsConsent: v)),
            title: Text(l10n.privacyAnalyticsLabel, style: context.textStyles.titleSmall),
            subtitle: Text(l10n.privacyAnalyticsDesc, style: context.textStyles.bodySmall),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_outlined, size: 20, color: p.primary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                l10n.privacyHealthNote,
                style: context.textStyles.bodyMedium?.copyWith(color: p.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
    child: Text(text, style: context.textStyles.titleMedium),
  );
}

class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: selected,
      button: true,
      child: AnimatedContainer(
        duration: AppMotion.normal,
        decoration: BoxDecoration(
          color: selected ? p.primarySoft : p.surface,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: selected ? p.primaryLight : p.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: AppRadius.lgAll,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(icon, color: p.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: context.textStyles.titleSmall),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(description, style: context.textStyles.bodySmall),
                      ],
                    ),
                  ),
                  Icon(
                    selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: selected ? p.primary : p.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
