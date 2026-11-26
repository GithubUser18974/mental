import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/medication/presentation/providers/medication_providers.dart';
import 'package:mindful/features/medication/presentation/widgets/medication_tile.dart';

/// Stopped or ended medications (FR-MED-006 "past medications").
class PastMedicationsPage extends ConsumerWidget {
  const PastMedicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final past = ref.watch(medicationsProvider('past'));

    return ListPageScaffold(
      title: l10n.pastMeds,
      onRefresh: () async => ref.invalidate(medicationsProvider('past')),
      slivers: [
        past.when(
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
          error: (e, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(error: e, onRetry: () => ref.invalidate(medicationsProvider('past'))),
          ),
          data: (meds) => meds.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyView(subtitle: l10n.noPastMeds),
                )
              : SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverList.separated(
                    itemCount: meds.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (_, i) => MedicationTile(medication: meds[i]),
                  ),
                ),
        ),
      ],
    );
  }
}
