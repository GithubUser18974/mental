import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/utils/validators.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/consent_checkbox.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/features/authentication/presentation/providers/auth_controllers.dart';

/// FR-AUTH-001 registration with explicit 18+ (BR-001) and terms/privacy consent.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _ageConfirmed = false;
  bool _termsAccepted = false;
  bool _showConsentErrors = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final formValid = _formKey.currentState?.validate() ?? false;
    setState(() => _showConsentErrors = true);
    if (!formValid || !_ageConfirmed || !_termsAccepted) return;

    await ref
        .read(registerControllerProvider.notifier)
        .submit(
          email: _email.text,
          password: _password.text,
          ageConfirmed: _ageConfirmed,
          termsAccepted: _termsAccepted,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(registerControllerProvider);
    final serverErrors = switch (state.error) {
      final ValidationException e => e,
      _ => null,
    };

    ref.listen(registerControllerProvider, (_, next) {
      final error = next.error;
      if (error != null && error is! ValidationException) showErrorSnackBar(context, error);
    });

    return FormPage(
      title: l10n.registerTitle,
      subtitle: l10n.registerSubtitle,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: l10n.registerSubmit,
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
          InlineLinkRow(
            prompt: l10n.haveAccountPrompt,
            link: l10n.signInLink,
            onTap: () => context.pushReplacement(AppRoutes.login),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: l10n.fieldEmail,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                textDirection: TextDirection.ltr,
                validator: (v) => Validators.email(v, l10n),
                errorText: serverErrors?.firstErrorFor('email'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.fieldPassword,
                controller: _password,
                obscure: true,
                helper: l10n.passwordHint,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) => Validators.newPassword(v, l10n),
                errorText: serverErrors?.firstErrorFor('password'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.fieldConfirmPassword,
                controller: _confirm,
                obscure: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) => Validators.confirmation(v, _password.text, l10n),
              ),
              const SizedBox(height: AppSpacing.lg),
              ConsentCheckbox(
                label: l10n.ageConfirmLabel,
                value: _ageConfirmed,
                onChanged: (v) => setState(() => _ageConfirmed = v),
                errorText: _showConsentErrors && !_ageConfirmed
                    ? l10n.validationAgeRequired
                    : serverErrors?.firstErrorFor('age_confirmed'),
              ),
              ConsentCheckbox(
                label: l10n.termsLabel,
                value: _termsAccepted,
                onChanged: (v) => setState(() => _termsAccepted = v),
                errorText: _showConsentErrors && !_termsAccepted
                    ? l10n.validationTermsRequired
                    : serverErrors?.firstErrorFor('terms_accepted'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
