import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/tracking/presentation/providers/tracking_providers.dart';

/// Personal insights (FR-TRACK-005): server-written, non-diagnostic observations, always
/// with the disclaimer.
class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final insights = ref.watch(insightsProvider);

    return ListPageScaffold(
      title: l10n.insightsTitle,
      onRefresh: () async => ref.invalidate(insightsProvider),
      slivers: [
        insights.when(
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
          error: (e, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(error: e, onRetry: () => ref.invalidate(insightsProvider)),
          ),
          data: (data) => SliverPadding(
            padding: AppSpacing.screenPadding,
            sliver: SliverList.list(
              children: [
                if (data.items.isEmpty)
                  EmptyView(
                    icon: Icons.auto_awesome_outlined,
                    subtitle: data.refreshing ? l10n.insightsRefreshing : l10n.insightsEmpty,
                  ),
                for (final item in data.items)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            item.isMilestone
                                ? Icons.emoji_events_outlined
                                : Icons.insights_outlined,
                            color: p.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: Text(item.text, style: context.textStyles.bodyLarge)),
                        ],
                      ),
                    ),
                  ),
                if (data.disclaimer.isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: p.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(data.disclaimer, style: context.textStyles.bodySmall),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
