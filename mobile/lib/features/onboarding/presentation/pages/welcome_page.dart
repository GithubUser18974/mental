import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/features/onboarding/presentation/providers/onboarding_seen_provider.dart';

/// First screen for signed-out users.
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final seenIntro = ref.watch(onboardingSeenProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (kDebugMode)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.designShowcase),
                      child: const Text('Design system'), // debug only, not user-facing
                    ),
                  ),
                const Spacer(),
                ExcludeSemantics(child: Icon(Icons.spa_outlined, size: 72, color: p.primary)),
                const SizedBox(height: AppSpacing.xl),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: context.textStyles.headlineMedium,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodyLarge?.copyWith(color: p.textSecondary),
                ),
                const Spacer(),
                PrimaryButton(
                  label: l10n.getStarted,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () =>
                      context.push(seenIntro ? AppRoutes.register : AppRoutes.onboarding),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: l10n.signIn,
                  onPressed: () => context.push(AppRoutes.login),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
