import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/features/community/presentation/providers/social_providers.dart';
import 'package:mindful/features/community/presentation/widgets/paged_post_sliver.dart';

/// A full-screen post list: saved posts (FR-COM-007) or a hashtag (FR-COM-008).
class PostListPage extends ConsumerWidget {
  const PostListPage.saved({super.key}) : source = const SavedPostsSource();

  PostListPage.hashtag(String tag, {super.key}) : source = HashtagPostsSource(tag);

  final PostListSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (title, empty) = switch (source) {
      HashtagPostsSource(:final hashtag) => ('#$hashtag', l10n.searchNoResults),
      _ => (l10n.meSaved, l10n.savedEmpty),
    };
    return ListPageScaffold(
      title: title,
      onScroll: (n) => loadMoreOnScroll(ref, n, source),
      onRefresh: () async => ref.invalidate(postListProvider(source)),
      slivers: [PagedPostSliver(source: source, emptyText: empty)],
    );
  }
}
