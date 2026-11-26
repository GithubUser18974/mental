import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/pill_option.dart';
import 'package:mindful/core/widgets/selectable_tile.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/widgets/community_labels.dart';

/// 3-column category tile grid (design system "Selectable grid tiles").
class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({required this.selected, required this.onSelected, super.key});

  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(categoriesProvider)
        .when(
          loading: () => const SizedBox(height: 120, child: LoadingView()),
          error: (error, _) =>
              ErrorView(error: error, onRetry: () => ref.invalidate(categoriesProvider)),
          data: (categories) => GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.95,
            children: [
              for (final category in categories)
                SelectableTile(
                  icon: categoryIcon(category.icon),
                  label: category.name,
                  selected: selected == category.slug,
                  onTap: () => onSelected(category.slug),
                ),
            ],
          ),
        );
  }
}

/// "None" + the fixed content warnings as pill options.
class ContentWarningPicker extends StatelessWidget {
  const ContentWarningPicker({required this.selected, required this.onSelected, super.key});

  final ContentWarning? selected;
  final ValueChanged<ContentWarning?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        PillOption(label: l10n.cwNone, selected: selected == null, onTap: () => onSelected(null)),
        for (final warning in ContentWarning.values)
          PillOption(
            label: warning.label(l10n),
            selected: selected == warning,
            onTap: () => onSelected(warning),
          ),
      ],
    );
  }
}

/// A labelled switch in a card.
class ComposerSwitch extends StatelessWidget {
  const ComposerSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: AppCard(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xs),
        child: SwitchListTile(
          contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xs),
          title: Text(title, style: context.textStyles.titleSmall),
          subtitle: subtitle == null ? null : Text(subtitle!, style: context.textStyles.bodySmall),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
