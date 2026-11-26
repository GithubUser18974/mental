import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/features/onboarding/presentation/providers/onboarding_seen_provider.dart';

/// FR-ONB-001: purpose, anonymity, tracking, privacy, community guidelines.
class OnboardingIntroPage extends ConsumerStatefulWidget {
  const OnboardingIntroPage({super.key});

  @override
  ConsumerState<OnboardingIntroPage> createState() => _OnboardingIntroPageState();
}

class _OnboardingIntroPageState extends ConsumerState<OnboardingIntroPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_IntroSlide> _slides(AppLocalizations l10n) => [
    _IntroSlide(Icons.spa_outlined, l10n.onboardingPurposeTitle, l10n.onboardingPurposeBody),
    _IntroSlide(
      Icons.masks_outlined,
      l10n.onboardingAnonymousTitle,
      l10n.onboardingAnonymousBody,
    ),
    _IntroSlide(Icons.insights_outlined, l10n.onboardingTrackingTitle, l10n.onboardingTrackingBody),
    _IntroSlide(
      Icons.lock_outline_rounded,
      l10n.onboardingPrivacyTitle,
      l10n.onboardingPrivacyBody,
    ),
    _IntroSlide(
      Icons.volunteer_activism_outlined,
      l10n.onboardingGuidelinesTitle,
      l10n.onboardingGuidelinesBody,
    ),
  ];

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (mounted) context.pushReplacement(AppRoutes.register);
  }

  Future<void> _next(int count) async {
    if (_index >= count - 1) {
      await _finish();
      return;
    }
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.jumpToPage(_index + 1);
    } else {
      await _controller.nextPage(duration: AppMotion.normal, curve: AppMotion.curve);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slides = _slides(l10n);
    final isLast = _index == slides.length - 1;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                  child: TextButton(onPressed: _finish, child: Text(l10n.onboardingSkip)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => _SlideView(slide: slides[i]),
                ),
              ),
              Semantics(
                label: l10n.onboardingPage(_index + 1, slides.length),
                child: _Dots(count: slides.length, index: _index),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.screen,
                  AppSpacing.xl,
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                child: PrimaryButton(
                  label: isLast ? l10n.onboardingFinish : l10n.onboardingNext,
                  trailingIcon: Icons.arrow_forward_rounded,
                  onPressed: () => _next(slides.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroSlide {
  const _IntroSlide(this.icon, this.title, this.body);

  final IconData icon;
  final String title;
  final String body;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _IntroSlide slide;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(color: p.primarySoft, shape: BoxShape.circle),
              child: Icon(slide.icon, size: 64, color: p.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Semantics(
            header: true,
            child: Text(
              slide.title,
              textAlign: TextAlign.center,
              style: context.textStyles.headlineSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLarge?.copyWith(color: p.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: AppMotion.normal,
              margin: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.xxs),
              width: i == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == index ? p.primary : p.primaryLight.withValues(alpha: 0.5),
                borderRadius: AppRadius.pillAll,
              ),
            ),
        ],
      ),
    );
  }
}
