import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/circle_icon_button.dart';
import 'package:mindful/core/widgets/context_badge.dart';

/// Shared layout for form screens (auth, onboarding setup): back button + optional
/// badge, display title, subtitle, scrollable content and pinned bottom actions.
class FormPage extends StatelessWidget {
  const FormPage({
    required this.title,
    required this.child,
    this.subtitle,
    this.badge,
    this.onBack,
    this.bottom,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? badge;

  /// Defaults to popping the route when possible.
  final VoidCallback? onBack;
  final Widget child;

  /// Pinned under the scrollable content (primary action, links).
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final back = onBack ?? (navigator.canPop() ? navigator.pop : null);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screen - AppSpacing.xxs,
                  AppSpacing.xs,
                  AppSpacing.screen,
                  0,
                ),
                child: Row(
                  children: [
                    if (back != null)
                      CircleIconButton.back(onPressed: back, semanticLabel: l10n.actionBack)
                    else
                      const SizedBox(height: AppSizes.minTapTarget),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: badge == null
                          ? const SizedBox.shrink()
                          : Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: ContextBadge(label: badge!),
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.screen,
                    AppSpacing.lg,
                    AppSpacing.screen,
                    AppSpacing.xl,
                  ),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(title, style: context.textStyles.headlineMedium),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle!,
                          style: context.textStyles.bodyLarge?.copyWith(
                            color: context.palette.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      child,
                    ],
                  ),
                ),
              ),
              if (bottom != null)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.screen,
                    AppSpacing.xs,
                    AppSpacing.screen,
                    AppSpacing.md,
                  ),
                  child: bottom,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Prompt? Link" row used under auth forms.
class InlineLinkRow extends StatelessWidget {
  const InlineLinkRow({required this.prompt, required this.link, required this.onTap, super.key});

  final String prompt;
  final String link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prompt,
          style: context.textStyles.bodyMedium?.copyWith(color: context.palette.textSecondary),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            link,
            style: context.textStyles.labelLarge?.copyWith(color: context.palette.primary),
          ),
        ),
      ],
    );
  }
}
