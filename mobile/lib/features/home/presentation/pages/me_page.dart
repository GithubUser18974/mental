import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/core/security/sign_out.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// "Me" tab: own identity, private lists (saved, followers, following, blocked) and
/// sign-out. Settings arrive with Phase 10.
class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider).value?.profile;
    final signingOut = ref.watch(signOutControllerProvider).isLoading;

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        AppSpacing.lg,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(l10n.meTitle, style: context.textStyles.headlineSmall),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (profile != null)
          AppCard(
            onTap: () => context.push(AppRoutes.profilePath(profile.username)),
            child: Row(
              children: [
                AvatarView(avatarKey: profile.avatar, size: 56),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.username,
                        style: context.textStyles.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(l10n.meViewProfile, style: context.textStyles.bodySmall),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.palette.textTertiary),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        _MeLink(
          icon: Icons.bookmark_outline_rounded,
          label: l10n.meSaved,
          route: AppRoutes.savedPosts,
        ),
        _MeLink(
          icon: Icons.people_outline_rounded,
          label: l10n.meFollowers,
          route: AppRoutes.membersPath('followers'),
        ),
        _MeLink(
          icon: Icons.person_add_alt_outlined,
          label: l10n.meFollowing,
          route: AppRoutes.membersPath('following'),
        ),
        _MeLink(
          icon: Icons.block_rounded,
          label: l10n.meBlocked,
          route: AppRoutes.membersPath('blocked'),
        ),
        const SizedBox(height: AppSpacing.xl),
        SecondaryButton(
          label: l10n.actionSignOut,
          trailingIcon: Icons.logout_rounded,
          onPressed: signingOut
              ? null
              : () => ref.read(signOutControllerProvider.notifier).signOut(),
        ),
      ],
    );
  }
}

class _MeLink extends StatelessWidget {
  const _MeLink({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
      child: AppCard(
        onTap: () => context.push(route),
        child: Row(
          children: [
            Icon(icon, color: p.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(label, style: context.textStyles.titleSmall)),
            Icon(Icons.chevron_right_rounded, color: p.textTertiary),
          ],
        ),
      ),
    );
  }
}
