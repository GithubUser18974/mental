import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/providers/social_providers.dart';
import 'package:mindful/features/community/presentation/widgets/member_tile.dart';

/// My followers / following / blocked members (owner-only lists).
class MembersPage extends ConsumerWidget {
  const MembersPage({required this.kind, super.key});

  final MemberListKind kind;

  Future<void> _unblock(BuildContext context, WidgetRef ref, MemberCard card) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(socialActionsProvider)
          .setBlocked(card.member.id, card.member.username, blocked: false);
      messenger.showSnackBar(SnackBar(content: Text(l10n.memberUnblocked)));
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (title, empty) = switch (kind) {
      MemberListKind.followers => (l10n.meFollowers, l10n.followersEmpty),
      MemberListKind.following => (l10n.meFollowing, l10n.followingEmpty),
      MemberListKind.blocked => (l10n.meBlocked, l10n.blockedEmpty),
    };
    final list = ref.watch(memberListProvider(kind));

    return ListPageScaffold(
      title: title,
      onScroll: (n) {
        if (n.metrics.extentAfter < 400) {
          ref.read(memberListProvider(kind).notifier).loadMore().ignore();
        }
      },
      onRefresh: () async => ref.invalidate(memberListProvider(kind)),
      slivers: [
        list.when(
          skipLoadingOnRefresh: true,
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
          error: (error, _) => SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(
              error: error,
              onRetry: () => ref.invalidate(memberListProvider(kind)),
            ),
          ),
          data: (state) => state.items.isEmpty
              ? SliverFillRemaining(hasScrollBody: false, child: EmptyView(subtitle: empty))
              : SliverPadding(
                  padding: AppSpacing.screenPadding,
                  sliver: SliverList.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final card = state.items[index];
                      return MemberTile(
                        key: ValueKey(card.member.id),
                        card: card,
                        trailing: kind == MemberListKind.blocked
                            ? TextButton(
                                onPressed: () => _unblock(context, ref, card),
                                child: Text(l10n.unblockMember),
                              )
                            : null,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
