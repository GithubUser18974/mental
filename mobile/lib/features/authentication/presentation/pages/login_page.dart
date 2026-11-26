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
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/features/authentication/presentation/providers/auth_controllers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(loginControllerProvider.notifier)
        .submit(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(loginControllerProvider);
    final fieldErrors = switch (state.error) {
      final ValidationException e => e,
      _ => null,
    };

    ref.listen(loginControllerProvider, (_, next) {
      final error = next.error;
      if (error != null && error is! ValidationException) showErrorSnackBar(context, error);
    });

    return FormPage(
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: l10n.loginSubmit,
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
          InlineLinkRow(
            prompt: l10n.noAccountPrompt,
            link: l10n.createAccountLink,
            onTap: () => context.pushReplacement(AppRoutes.register),
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
                errorText: fieldErrors?.firstErrorFor('email'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: l10n.fieldPassword,
                controller: _password,
                obscure: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: (v) => Validators.passwordPresent(v, l10n),
                errorText: fieldErrors?.firstErrorFor('password'),
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: Text(l10n.forgotPasswordLink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
