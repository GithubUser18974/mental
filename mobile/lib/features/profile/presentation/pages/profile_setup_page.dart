import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/security/sign_out.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/features/profile/domain/entities/own_profile.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';
import 'package:mindful/features/profile/presentation/providers/profile_setup_controllers.dart';
import 'package:mindful/features/profile/presentation/widgets/avatar_picker.dart';
import 'package:mindful/features/profile/presentation/widgets/privacy_options.dart';
import 'package:mindful/features/profile/presentation/widgets/username_field.dart';

/// Post-registration setup (FR-ONB-002 profile, FR-ONB-003 privacy) in two steps.
/// Nothing is saved until "Finish"; saving the profile completes setup and the
/// router moves on to home.
class ProfileSetupPage extends ConsumerStatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage> {
  static const _steps = 2;

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _bio = TextEditingController();
  int _step = 0;
  String _avatar = '';
  String _originalUsername = '';
  PrivacySettings _privacy = PrivacySettings.defaults;
  int _suggestionIndex = 0;
  bool _initialized = false;

  @override
  void dispose() {
    _username.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _initFrom(OwnProfile profile) {
    if (_initialized) return;
    _initialized = true;
    _originalUsername = profile.profile.username;
    _username.text = profile.profile.username;
    _bio.text = profile.profile.bio ?? '';
    _avatar = profile.profile.avatar;
    _privacy = profile.privacy;
  }

  Future<void> _shuffle() async {
    try {
      final names = await ref.read(usernameSuggestionsProvider.future);
      if (names.isEmpty || !mounted) return;
      final name = names[_suggestionIndex % names.length];
      _suggestionIndex++;
      _username.text = name;
      ref.read(usernameCheckProvider.notifier).check(name, current: _originalUsername);
      if (_suggestionIndex >= names.length) {
        _suggestionIndex = 0;
        ref.invalidate(usernameSuggestionsProvider);
      }
    } on Object catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  bool get _usernameBlocked => switch (ref.read(usernameCheckProvider)) {
    UsernameCheckResult(:final availability) => !availability.available,
    _ => false,
  };

  void _continue() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false) || _usernameBlocked) return;
    setState(() => _step = 1);
  }

  Future<void> _finish() async {
    await ref
        .read(profileSetupControllerProvider.notifier)
        .complete(
          username: _username.text.trim(),
          avatar: _avatar,
          bio: _bio.text.trim(),
          privacy: _privacy,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider).value;
    if (profile != null) _initFrom(profile);

    final state = ref.watch(profileSetupControllerProvider);
    final serverErrors = switch (state.error) {
      final ValidationException e => e,
      _ => null,
    };

    ref.listen(profileSetupControllerProvider, (_, next) {
      final error = next.error;
      if (error is ValidationException) {
        // Username taken meanwhile etc. — back to the profile step to fix it.
        setState(() => _step = 0);
      } else if (error != null) {
        showErrorSnackBar(context, error);
      }
    });

    final badge = '${l10n.setupBadge} · ${l10n.setupStep(_step + 1, _steps)}';

    if (_step == 1) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) setState(() => _step = 0);
        },
        child: FormPage(
          title: l10n.setupPrivacyTitle,
          subtitle: l10n.setupPrivacySubtitle,
          badge: badge,
          onBack: () => setState(() => _step = 0),
          bottom: PrimaryButton(
            label: l10n.setupFinish,
            isLoading: state.isLoading,
            onPressed: _finish,
          ),
          child: PrivacyOptions(value: _privacy, onChanged: (v) => setState(() => _privacy = v)),
        ),
      );
    }

    return FormPage(
      title: l10n.setupProfileTitle,
      subtitle: l10n.setupProfileSubtitle,
      badge: badge,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: l10n.setupNext,
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: profile == null ? null : _continue,
          ),
          TextButton(
            onPressed: () => ref.read(signOutControllerProvider.notifier).signOut(),
            child: Text(l10n.actionSignOut),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AvatarPicker(value: _avatar, onChanged: (v) => setState(() => _avatar = v)),
            const SizedBox(height: AppSpacing.lg),
            UsernameField(
              controller: _username,
              currentUsername: _originalUsername,
              onShuffle: _shuffle,
              serverError: serverErrors?.firstErrorFor('username'),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.fieldBio,
              hint: l10n.bioHint,
              controller: _bio,
              maxLength: 300,
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              errorText: serverErrors?.firstErrorFor('bio'),
            ),
          ],
        ),
      ),
    );
  }
}
