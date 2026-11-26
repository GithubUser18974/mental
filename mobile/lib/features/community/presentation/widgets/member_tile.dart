import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/features/community/domain/entities/social.dart';

/// A member row (avatar + pseudonym) opening their profile, with an optional trailing
/// action (e.g. "Unblock").
class MemberTile extends StatelessWidget {
  const MemberTile({required this.card, this.trailing, this.subtitle, super.key});

  final MemberCard card;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final member = card.member;
    return AppCard(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      onTap: () => context.push(AppRoutes.profilePath(member.username)),
      child: Row(
        children: [
          AvatarView(avatarKey: member.avatar, size: 40),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username,
                  style: context.textStyles.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) Text(subtitle!, style: context.textStyles.bodySmall),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
