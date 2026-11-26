// Debug-only gallery of the design system. Sample copy here is developer-facing
// placeholder text, so it is intentionally not in the ARB files.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/localization/locale_controller.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/app/theme/theme_mode_controller.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_card.dart';
import 'package:mindful/core/widgets/circle_icon_button.dart';
import 'package:mindful/core/widgets/context_badge.dart';
import 'package:mindful/core/widgets/pill_option.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/round_selector.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/core/widgets/selectable_tile.dart';
import 'package:mindful/core/widgets/state_views.dart';

class DesignShowcasePage extends ConsumerStatefulWidget {
  const DesignShowcasePage({super.key});

  @override
  ConsumerState<DesignShowcasePage> createState() => _DesignShowcasePageState();
}

class _DesignShowcasePageState extends ConsumerState<DesignShowcasePage> {
  int _tile = 4;
  int _pill = 1;
  int _round = 1;
  bool _toggle = true;
  bool _loading = false;

  static const _categories = <(IconData, String)>[
    (Icons.auto_stories_outlined, 'My Story'),
    (Icons.volunteer_activism_outlined, 'Need Support'),
    (Icons.wb_sunny_outlined, 'Daily Thoughts'),
    (Icons.medication_outlined, 'Medication Experience'),
    (Icons.trending_up_rounded, 'Recovery Journey'),
    (Icons.help_outline_rounded, 'Questions'),
    (Icons.self_improvement_outlined, 'Mental Wellness'),
  ];

  static const _rounds = <(IconData, IconData, String)>[
    (Icons.monitor_heart_outlined, Icons.monitor_heart, 'Energy'),
    (Icons.favorite_border_rounded, Icons.favorite_rounded, 'Feeling'),
    (Icons.water_drop_outlined, Icons.water_drop, 'Hydration'),
    (Icons.bed_outlined, Icons.bed, 'Sleep'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.screen,
              AppSpacing.md,
              AppSpacing.screen,
              AppSpacing.xxxl,
            ),
            children: [
              Row(
                children: [
                  CircleIconButton.back(
                    onPressed: () => Navigator.of(context).maybePop(),
                    semanticLabel: l10n.actionBack,
                  ),
                  const Spacer(),
                  const ContextBadge(label: 'Design system'),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Add New Post', style: context.textStyles.headlineMedium),
              Text(
                'Select post category',
                style: context.textStyles.bodyMedium?.copyWith(color: p.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _Section('Appearance'),
              const _AppearanceControls(),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Category tiles'),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                children: [
                  for (final (i, c) in _categories.indexed)
                    SelectableTile(
                      icon: c.$1,
                      label: c.$2,
                      selected: _tile == i,
                      onTap: () => setState(() => _tile = i),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Post content'),
              AppCard(
                child: TextField(
                  maxLines: 4,
                  maxLength: 300,
                  decoration: InputDecoration(
                    hintText: 'What would you like to share today?',
                    filled: true,
                    fillColor: p.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                      borderSide: BorderSide(color: p.primaryLight),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Post type'),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final (i, label) in ['Text', 'Regular', 'With image'].indexed)
                    PillOption(
                      label: label,
                      selected: _pill == i,
                      onTap: () => setState(() => _pill = i),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Round selectors'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final (i, r) in _rounds.indexed)
                    RoundSelector(
                      icon: r.$1,
                      selectedIcon: r.$2,
                      semanticLabel: r.$3,
                      selected: _round == i,
                      onTap: () => setState(() => _round = i),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                child: SwitchListTile.adaptive(
                  contentPadding: EdgeInsetsDirectional.zero,
                  value: _toggle,
                  onChanged: (v) => setState(() => _toggle = v),
                  title: Text('Hide from community?', style: context.textStyles.titleSmall),
                  subtitle: Text('This post will be private', style: context.textStyles.bodySmall),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Buttons'),
              PrimaryButton(
                label: 'Save as draft',
                isLoading: _loading,
                onPressed: () async {
                  setState(() => _loading = true);
                  await Future<void>.delayed(const Duration(seconds: 1));
                  if (mounted) setState(() => _loading = false);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SecondaryButton(
                label: l10n.actionContinue,
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              const PrimaryButton(label: 'Disabled', onPressed: null),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Typography'),
              Text('Display 28 / 700', style: context.textStyles.headlineMedium),
              Text('Title 20 / 600', style: context.textStyles.titleLarge),
              Text('Subtitle 16 / 600', style: context.textStyles.titleMedium),
              Text(
                'Body 15 / 400 — مرحبًا بك في مساحتك الآمنة',
                style: context.textStyles.bodyLarge,
              ),
              Text('Label 14 / 500', style: context.textStyles.labelLarge),
              Text('Caption 12 / 400 · 1m ago', style: context.textStyles.bodySmall),
              Text(
                '#mentalhealth #recovery',
                style: context.textStyles.bodyMedium?.copyWith(color: p.primary),
              ),
              const SizedBox(height: AppSpacing.xl),
              const _Section('Palette'),
              const _PaletteSwatches(),
              const SizedBox(height: AppSpacing.xl),
              const _Section('States'),
              const AppCard(child: EmptyView()),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: ErrorView(error: const NetworkException(), onRetry: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
    child: Text(title, style: context.textStyles.titleMedium),
  );
}

class _AppearanceControls extends ConsumerWidget {
  const _AppearanceControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeControllerProvider);
    final mode = ref.watch(themeModeControllerProvider);
    final localeCtl = ref.read(localeControllerProvider.notifier);
    final modeCtl = ref.read(themeModeControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (value, label) in <(Locale?, String)>[
              (null, l10n.languageSystem),
              (AppLocales.en, l10n.languageEnglish),
              (AppLocales.ar, l10n.languageArabic),
            ])
              PillOption(
                label: label,
                selected: locale == value,
                onTap: () => localeCtl.setLocale(value),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (value, label) in [
              (ThemeMode.system, l10n.themeSystem),
              (ThemeMode.light, l10n.themeLight),
              (ThemeMode.dark, l10n.themeDark),
            ])
              PillOption(
                label: label,
                selected: mode == value,
                onTap: () => modeCtl.setThemeMode(value),
              ),
          ],
        ),
      ],
    );
  }
}

class _PaletteSwatches extends StatelessWidget {
  const _PaletteSwatches();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final swatches = <(String, Color)>[
      ('primary', p.primary),
      ('primarySoft', p.primarySoft),
      ('primaryLight', p.primaryLight),
      ('background', p.background),
      ('surface', p.surface),
      ('surfaceMuted', p.surfaceMuted),
      ('textPrimary', p.textPrimary),
      ('textSecondary', p.textSecondary),
      ('textTertiary', p.textTertiary),
      ('success', p.success),
      ('warning', p.warning),
      ('danger', p.danger),
    ];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (name, color) in swatches)
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppRadius.smAll,
                  border: Border.all(color: p.border),
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(name, style: context.textStyles.labelSmall),
            ],
          ),
      ],
    );
  }
}
