import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/core/widgets/circle_icon_button.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/presentation/providers/feed_controller.dart';
import 'package:mindful/features/community/presentation/widgets/category_filter.dart';
import 'package:mindful/features/community/presentation/widgets/feed_sliver.dart';
import 'package:mindful/features/community/presentation/widgets/feed_tabs.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Community home (FR-COM-001): greeting, feed tabs (recent / popular / following),
/// category filter and the feed.
class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  final _scroll = ScrollController();
  FeedKind _kind = FeedKind.recent;
  String? _category;

  FeedQuery get _query => (kind: _kind, categorySlug: _category);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (_scroll.position.extentAfter < 600) {
      ref.read(feedControllerProvider(_query).notifier).loadMore().ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider).value?.profile;

    return RefreshIndicator(
      onRefresh: () => ref.read(feedControllerProvider(_query).notifier).refresh(),
      child: CustomScrollView(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screen,
              AppSpacing.md,
              AppSpacing.screen - AppSpacing.xxs,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  if (profile != null) ...[
                    AvatarView(avatarKey: profile.avatar),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        profile == null
                            ? l10n.communityTitle
                            : l10n.communityGreeting(profile.username),
                        style: context.textStyles.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.search_rounded,
                    semanticLabel: l10n.searchTitle,
                    onPressed: () => context.push(AppRoutes.search),
                  ),
                  CircleIconButton(
                    icon: Icons.add_rounded,
                    semanticLabel: l10n.createPost,
                    onPressed: () => context.push(AppRoutes.newPost),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screen,
              AppSpacing.xs,
              AppSpacing.screen,
              AppSpacing.md,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(l10n.communityDisclaimer, style: context.textStyles.bodySmall),
            ),
          ),
          SliverPadding(
            padding: AppSpacing.screenPadding,
            sliver: SliverToBoxAdapter(
              child: FeedTabs(
                selected: _kind,
                onChanged: (kind) => setState(() => _kind = kind),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
              child: CategoryFilter(
                selected: _category,
                onChanged: (slug) => setState(() => _category = slug),
              ),
            ),
          ),
          FeedSliver(query: _query),
        ],
      ),
    );
  }
}
