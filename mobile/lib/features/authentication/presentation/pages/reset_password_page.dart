import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/utils/validators.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/features/authentication/presentation/providers/auth_controllers.dart';

/// Opened from the emailed link: `…/reset-password?token=…&email=…`
/// (`ymindful://app/reset-password` now; an https universal link once a domain exists).
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({required this.token, required this.email, super.key});

  final String? token;
  final String? email;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _done = false;

  bool get _linkValid => (widget.token?.isNotEmpty ?? false) && (widget.email?.isNotEmpty ?? false);

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(resetPasswordControllerProvider.notifier)
        .submit(email: widget.email!, token: widget.token!, password: _password.text);
    if (mounted && !ref.read(resetPasswordControllerProvider).hasError) {
      setState(() => _done = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!_linkValid) {
      return FormPage(
        title: l10n.resetTitle,
        subtitle: l10n.resetInvalidLink,
        bottom: SecondaryButton(
          label: l10n.forgotSubmit,
          onPressed: () => context.go(AppRoutes.forgotPassword),
        ),
        child: const SizedBox.shrink(),
      );
    }

    if (_done) {
      return FormPage(
        title: l10n.resetDoneTitle,
        subtitle: l10n.resetDoneBody,
        onBack: () => context.go(AppRoutes.login),
        bottom: PrimaryButton(
          label: l10n.backToSignIn,
          onPressed: () => context.go(AppRoutes.login),
        ),
        child: Icon(Icons.verified_user_outlined, size: 72, color: context.palette.primary),
      );
    }

    final state = ref.watch(resetPasswordControllerProvider);
    final serverErrors = switch (state.error) {
      final ValidationException e => e,
      _ => null,
    };

    ref.listen(resetPasswordControllerProvider, (_, next) {
      final error = next.error;
      if (error != null && error is! ValidationException) showErrorSnackBar(context, error);
    });

    return FormPage(
      title: l10n.resetTitle,
      subtitle: l10n.resetSubtitle,
      onBack: () => context.go(AppRoutes.login),
      bottom: PrimaryButton(
        label: l10n.resetSubmit,
        isLoading: state.isLoading,
        onPressed: _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // An invalid/expired token comes back as a `token` error; show it prominently.
            if (serverErrors?.firstErrorFor('token') case final tokenError?) ...[
              Text(
                tokenError,
                style: context.textStyles.bodyMedium?.copyWith(color: context.palette.danger),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            AppTextField(
              label: l10n.fieldNewPassword,
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
              validator: (v) => Validators.confirmation(v, _password.text, l10n),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}
