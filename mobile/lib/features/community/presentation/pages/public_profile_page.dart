import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/list_page_scaffold.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/social.dart';
import 'package:mindful/features/community/presentation/providers/social_providers.dart';
import 'package:mindful/features/community/presentation/widgets/paged_post_sliver.dart';
import 'package:mindful/features/community/presentation/widgets/report_sheet.dart';

/// Another member's public profile (FR-PRO-001/003): pseudonym, avatar, bio (unless
/// private), joined date, follower counts, follow / block / report, and their posts.
class PublicProfilePage extends ConsumerWidget {
  const PublicProfilePage({required this.username, super.key});

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loaded = ref.watch(publicProfileProvider(username));
    final source = ProfilePostsSource(username);
    final profile = loaded.value;

    return ListPageScaffold(
      title: profile?.member.username ?? username,
      trailing: profile == null || profile.relationship.isSelf
          ? null
          : _ProfileMenu(profile: profile),
      onScroll: (n) => loadMoreOnScroll(ref, n, source),
      onRefresh: () async {
        ref
          ..invalidate(publicProfileProvider(username))
          ..invalidate(postListProvider(source));
      },
      slivers: loaded.when(
        loading: () => [
          const SliverFillRemaining(hasScrollBody: false, child: LoadingView()),
        ],
        error: (error, _) => [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(
              error: error,
              onRetry: () => ref.invalidate(publicProfileProvider(username)),
            ),
          ),
        ],
        data: (profile) => [
          SliverPadding(
            padding: AppSpacing.screenPadding,
            sliver: SliverToBoxAdapter(child: _Header(profile: profile)),
          ),
          if (!profile.relationship.isBlocked) ...[
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.screen,
                AppSpacing.lg,
                AppSpacing.screen,
                AppSpacing.sm,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(l10n.profilePostsTitle, style: context.textStyles.titleMedium),
              ),
            ),
            PagedPostSliver(source: source, emptyText: l10n.profileNoPosts),
          ],
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.profile});

  final PublicProfile profile;

  Future<void> _toggleFollow(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(socialActionsProvider)
          .setFollowing(profile, following: !profile.relationship.isFollowing);
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final r = profile.relationship;
    final joined = DateFormat.yMMMM(l10n.localeName).format(profile.joinedOn);

    return AppCard(
      child: Column(
        children: [
          AvatarView(avatarKey: profile.member.avatar, size: 80),
          const SizedBox(height: AppSpacing.sm),
          Text(profile.member.username, style: context.textStyles.titleLarge),
          Text(l10n.profileJoined(joined), style: context.textStyles.bodySmall),
          if (r.followsYou && !r.isSelf)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: AppSpacing.xxs),
              child: Text(
                l10n.profileFollowsYou,
                style: context.textStyles.labelMedium?.copyWith(color: p.primary),
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${l10n.profileFollowers(profile.followers)} · '
            '${l10n.profileFollowingCount(profile.following)}',
            style: context.textStyles.labelMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (r.isBlocked)
            Text(
              l10n.profileBlockedNotice,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(color: p.textSecondary),
            )
          else if (profile.isPrivate)
            Text(
              l10n.profilePrivate,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.copyWith(color: p.textSecondary),
            )
          else if (profile.bio case final bio? when bio.isNotEmpty)
            Text(bio, textAlign: TextAlign.center, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          if (r.isSelf)
            Text(l10n.profileThisIsYou, style: context.textStyles.bodySmall)
          else if (r.isBlocked)
            SecondaryButton(
              label: l10n.unblockMember,
              onPressed: () => ref
                  .read(socialActionsProvider)
                  .setBlocked(profile.member.id, profile.member.username, blocked: false)
                  .catchError((Object e) {
                    if (context.mounted) showErrorSnackBar(context, e);
                  }),
            )
          else if (r.isFollowing)
            SecondaryButton(
              label: l10n.unfollowAction,
              trailingIcon: Icons.check_rounded,
              onPressed: () => _toggleFollow(context, ref),
            )
          else if (r.canFollow)
            PrimaryButton(label: l10n.followAction, onPressed: () => _toggleFollow(context, ref)),
        ],
      ),
    );
  }
}

enum _ProfileAction { block, report }

class _ProfileMenu extends ConsumerWidget {
  const _ProfileMenu({required this.profile});

  final PublicProfile profile;

  Future<void> _block(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.blockConfirmTitle(profile.member.username)),
        content: Text(l10n.blockConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.blockMember),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(socialActionsProvider)
          .setBlocked(profile.member.id, profile.member.username, blocked: true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.memberBlocked)));
    } on Object catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<_ProfileAction>(
      tooltip: l10n.profileOptions,
      icon: Icon(Icons.more_horiz_rounded, color: context.palette.textPrimary),
      onSelected: (action) => switch (action) {
        _ProfileAction.block => _block(context, ref),
        _ProfileAction.report => showReportSheet(
          context,
          type: ReportTargetType.profile,
          targetId: profile.member.id,
        ),
      },
      itemBuilder: (_) => [
        if (!profile.relationship.isBlocked)
          PopupMenuItem(value: _ProfileAction.block, child: Text(l10n.blockMember)),
        PopupMenuItem(value: _ProfileAction.report, child: Text(l10n.reportMember)),
      ],
    );
  }
}
