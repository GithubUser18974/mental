import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/security/sign_out.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Shown while the session and (for signed-in users) the profile load.
/// If the profile can't be loaded (e.g. offline), offers retry or sign-out.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: profile.hasError && !profile.isLoading
              ? Column(
                  children: [
                    Expanded(
                      child: ErrorView(
                        error: profile.error!,
                        onRetry: () => ref.invalidate(currentProfileProvider),
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref.read(signOutControllerProvider.notifier).signOut(),
                      child: Text(l10n.actionSignOut),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                )
              : Center(
                  child: Text(
                    l10n.appName,
                    style: context.textStyles.headlineMedium?.copyWith(
                      fontSize: 56,
                      color: context.palette.primary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
