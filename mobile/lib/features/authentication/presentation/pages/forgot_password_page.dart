import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/router/app_routes.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/utils/validators.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/secondary_button.dart';
import 'package:mindful/features/authentication/presentation/providers/auth_controllers.dart';

/// Requests a reset link. The confirmation never reveals whether the email has an account.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  String? _sentTo;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _email.text.trim();
    await ref.read(forgotPasswordControllerProvider.notifier).submit(email);
    if (mounted && !ref.read(forgotPasswordControllerProvider).hasError) {
      setState(() => _sentTo = email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(forgotPasswordControllerProvider);

    ref.listen(forgotPasswordControllerProvider, (_, next) {
      final error = next.error;
      if (error != null && error is! ValidationException) showErrorSnackBar(context, error);
    });

    if (_sentTo != null) {
      return FormPage(
        title: l10n.forgotSentTitle,
        subtitle: l10n.forgotSentBody(_sentTo!),
        bottom: SecondaryButton(
          label: l10n.backToSignIn,
          onPressed: () => context.go(AppRoutes.login),
        ),
        child: Icon(Icons.mark_email_read_outlined, size: 72, color: context.palette.primary),
      );
    }

    final serverErrors = switch (state.error) {
      final ValidationException e => e,
      _ => null,
    };

    return FormPage(
      title: l10n.forgotTitle,
      subtitle: l10n.forgotSubtitle,
      bottom: PrimaryButton(
        label: l10n.forgotSubmit,
        isLoading: state.isLoading,
        onPressed: _submit,
      ),
      child: Form(
        key: _formKey,
        child: AppTextField(
          label: l10n.fieldEmail,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          textDirection: TextDirection.ltr,
          validator: (v) => Validators.email(v, l10n),
          errorText: serverErrors?.firstErrorFor('email'),
          onSubmitted: (_) => _submit(),
        ),
      ),
    );
  }
}
