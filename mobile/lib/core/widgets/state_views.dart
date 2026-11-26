import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/errors/app_exception_l10n.dart';
import 'package:mindful/core/widgets/secondary_button.dart';

/// Centered loading indicator for async screens.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: AppLocalizations.of(context).loading,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

/// Gentle empty state.
class EmptyView extends StatelessWidget {
  const EmptyView({this.title, this.subtitle, this.icon = Icons.spa_outlined, super.key});

  final String? title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _MessageLayout(
      icon: icon,
      title: title ?? l10n.emptyTitle,
      subtitle: subtitle ?? l10n.emptySubtitle,
    );
  }
}

/// Error state with localized message and optional retry.
class ErrorView extends StatelessWidget {
  const ErrorView({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _MessageLayout(
      icon: Icons.cloud_off_outlined,
      title: errorMessageFor(error, l10n),
      action: onRetry == null ? null : SecondaryButton(label: l10n.actionRetry, onPressed: onRetry),
    );
  }
}

class _MessageLayout extends StatelessWidget {
  const _MessageLayout({required this.icon, required this.title, this.subtitle, this.action});

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: p.primaryLight),
            const SizedBox(height: AppSpacing.md),
            Text(title, textAlign: TextAlign.center, style: context.textStyles.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: context.textStyles.bodyMedium?.copyWith(color: p.textSecondary),
              ),
            ],
            if (action != null) ...[const SizedBox(height: AppSpacing.xl), action!],
          ],
        ),
      ),
    );
  }
}
