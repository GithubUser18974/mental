import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/segmented_pills.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/data/repositories/social_repository_impl.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/pages/list_page_scaffold.dart';
import 'package:mindful/features/community/presentation/providers/social_providers.dart';
import 'package:mindful/features/community/presentation/widgets/member_tile.dart';
import 'package:mindful/features/community/presentation/widgets/paged_post_sliver.dart';

enum _SearchTab { posts, people, hashtags }

/// Search & discovery (FR-COM-008): posts, people, hashtags; trending hashtags when idle.
/// Results respect blocks and visibility server-side.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _text = TextEditingController();
  Timer? _debounce;
  String _query = '';
  _SearchTab _tab = _SearchTab.posts;

  @override
  void dispose() {
    _debounce?.cancel();
    _text.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _query;
    final active = query.replaceAll('#', '').replaceAll('@', '').length >= 2;

    return ListPageScaffold(
      title: l10n.searchTitle,
      onScroll: active && _tab == _SearchTab.posts
          ? (n) => loadMoreOnScroll(ref, n, SearchPostsSource(query))
          : null,
      slivers: [
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _text,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: _onChanged,
                  onSubmitted: (v) => setState(() => _query = v.trim()),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _SearchTabs(selected: _tab, onChanged: (t) => setState(() => _tab = t)),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
        if (!active)
          _query.isEmpty
              ? const _Trending()
              : SliverToBoxAdapter(child: EmptyView(subtitle: l10n.searchTooShort))
        else
          switch (_tab) {
            _SearchTab.posts => PagedPostSliver(
              source: SearchPostsSource(query.replaceAll('#', '')),
              emptyText: l10n.searchNoResults,
            ),
            _SearchTab.people => _PeopleResults(query: query),
            _SearchTab.hashtags => _HashtagResults(query: query),
          },
      ],
    );
  }
}

class _SearchTabs extends StatelessWidget {
  const _SearchTabs({required this.selected, required this.onChanged});

  final _SearchTab selected;
  final ValueChanged<_SearchTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SegmentedPills(
      labels: [l10n.searchPosts, l10n.searchPeople, l10n.searchHashtags],
      selectedIndex: selected.index,
      onChanged: (i) => onChanged(_SearchTab.values[i]),
    );
  }
}

final FutureProviderFamily<List<MemberCard>, String> _peopleSearchProvider = FutureProvider
    .autoDispose
    .family<List<MemberCard>, String>(
      (ref, q) => ref.read(socialRepositoryProvider).searchMembers(q),
    );

final FutureProviderFamily<List<HashtagStat>, String> _hashtagSearchProvider = FutureProvider
    .autoDispose
    .family<List<HashtagStat>, String>(
      (ref, q) => ref.read(socialRepositoryProvider).searchHashtags(q),
    );

class _PeopleResults extends ConsumerWidget {
  const _PeopleResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(_peopleSearchProvider(query))
        .when(
          loading: () => const SliverToBoxAdapter(child: LoadingView()),
          error: (e, _) => SliverToBoxAdapter(
            child: ErrorView(error: e, onRetry: () => ref.invalidate(_peopleSearchProvider)),
          ),
          data: (people) => people.isEmpty
              ? SliverToBoxAdapter(child: EmptyView(subtitle: l10n.searchNoResults))
              : SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverList.separated(
                    itemCount: people.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (_, i) => MemberTile(card: people[i]),
                  ),
                ),
        );
  }
}

class _HashtagResults extends ConsumerWidget {
  const _HashtagResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(_hashtagSearchProvider(query))
        .when(
          loading: () => const SliverToBoxAdapter(child: LoadingView()),
          error: (e, _) => SliverToBoxAdapter(
            child: ErrorView(error: e, onRetry: () => ref.invalidate(_hashtagSearchProvider)),
          ),
          data: (tags) => tags.isEmpty
              ? SliverToBoxAdapter(child: EmptyView(subtitle: l10n.searchNoResults))
              : _HashtagList(tags: tags),
        );
  }
}

/// Discovery when nothing is typed: trending hashtags (never boosted by warned posts).
class _Trending extends ConsumerWidget {
  const _Trending();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(trendingHashtagsProvider)
        .when(
          loading: () => const SliverToBoxAdapter(child: LoadingView()),
          error: (e, _) => SliverToBoxAdapter(
            child: ErrorView(error: e, onRetry: () => ref.invalidate(trendingHashtagsProvider)),
          ),
          data: (tags) => SliverMainAxisGroup(
            slivers: [
              SliverPadding(
                padding: AppSpacing.screenPadding,
                sliver: SliverToBoxAdapter(
                  child: Text(l10n.trendingTitle, style: context.textStyles.titleMedium),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
              if (tags.isEmpty)
                SliverToBoxAdapter(child: EmptyView(subtitle: l10n.trendingEmpty))
              else
                _HashtagList(tags: tags),
            ],
          ),
        );
  }
}

class _HashtagList extends StatelessWidget {
  const _HashtagList({required this.tags});

  final List<HashtagStat> tags;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    return SliverPadding(
      padding: AppSpacing.screenPadding,
      sliver: SliverList.separated(
        itemCount: tags.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, i) => AppCard(
          onTap: () => context.push(AppRoutes.hashtagPath(tags[i].name)),
          child: Row(
            children: [
              Icon(Icons.tag_rounded, color: p.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  tags[i].name,
                  style: context.textStyles.titleSmall?.copyWith(color: p.primary),
                ),
              ),
              Text(l10n.hashtagPostsCount(tags[i].postsCount), style: context.textStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
