import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';

/// Horizontal category chips ("All" + active categories) for topic filtering.
/// Hidden while categories load or if they fail (the feed still works unfiltered).
class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({required this.selected, required this.onChanged, super.key});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categories = ref.watch(categoriesProvider).value;
    if (categories == null || categories.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.screenPadding,
      child: Row(
        children: [
          _Chip(label: l10n.categoryAll, selected: selected == null, onTap: () => onChanged(null)),
          for (final category in categories)
            _Chip(
              label: category.name,
              icon: categoryIcon(category.icon),
              selected: selected == category.slug,
              onTap: () => onChanged(category.slug),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap, this.icon});

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: selected ? p.primarySoft : p.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.pillAll,
            side: BorderSide(color: selected ? p.primaryLight : p.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: p.primary),
                      const SizedBox(width: AppSpacing.xxs),
                    ],
                    Text(
                      label,
                      style: context.textStyles.labelLarge?.copyWith(
                        color: selected ? p.primary : p.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
