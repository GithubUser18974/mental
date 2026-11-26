import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';

/// Labeled text field in the design-system style. `obscure: true` adds a show/hide toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.controller,
    this.hint,
    this.helper,
    this.errorText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscure = false,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.suffix,
    this.enabled = true,
    this.inputFormatters,
    this.textDirection,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;

  /// Server-side error shown under the field (takes precedence over [validator]).
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscure;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;

  /// Force a direction (e.g. LTR for emails/usernames inside an Arabic UI).
  final TextDirection? textDirection;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;

    final toggle = widget.obscure
        ? IconButton(
            tooltip: _hidden ? l10n.showPassword : l10n.hidePassword,
            icon: Icon(
              _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: p.textTertiary,
            ),
            onPressed: () => setState(() => _hidden = !_hidden),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.xxs, bottom: AppSpacing.xs),
          child: Text(widget.label, style: context.textStyles.titleSmall),
        ),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _hidden,
          enableSuggestions: !widget.obscure,
          autocorrect: !widget.obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          maxLength: widget.maxLength,
          maxLines: widget.obscure ? 1 : widget.maxLines,
          inputFormatters: widget.inputFormatters,
          textDirection: widget.textDirection,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helper,
            helperMaxLines: 2,
            errorText: widget.errorText,
            errorMaxLines: 3,
            suffixIcon: widget.suffix ?? toggle,
          ),
        ),
      ],
    );
  }
}
