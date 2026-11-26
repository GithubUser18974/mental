import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/circle_icon_button.dart';

/// Back button + title over a scrollable list of slivers (saved, members, hashtag…).
class ListPageScaffold extends StatelessWidget {
  const ListPageScaffold({
    required this.title,
    required this.slivers,
    this.onScroll,
    this.onRefresh,
    this.trailing,
    super.key,
  });

  final String title;
  final List<Widget> slivers;
  final void Function(ScrollNotification)? onScroll;
  final Future<void> Function()? onRefresh;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget list = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: slivers,
    );
    if (onRefresh != null) list = RefreshIndicator(onRefresh: onRefresh!, child: list);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screen - AppSpacing.xxs,
                  AppSpacing.xs,
                  AppSpacing.screen - AppSpacing.xxs,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    CircleIconButton.back(
                      onPressed: () =>
                          context.canPop() ? context.pop() : context.go(AppRoutes.home),
                      semanticLabel: l10n.actionBack,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        title,
                        style: context.textStyles.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    onScroll?.call(n);
                    return false;
                  },
                  child: list,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
