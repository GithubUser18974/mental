import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_catalog.dart';
import 'package:mindful/core/avatar/avatar_view.dart';

/// Pick an illustration and a color; the large preview shows the result.
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({required this.value, required this.onChanged, super.key});

  /// Current avatar key `icon-color`.
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final (icon, color) = AvatarCatalog.parse(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: AvatarView(avatarKey: value, size: 88)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (i, option) in AvatarCatalog.icons.indexed)
              _Choice(
                selected: option == icon,
                semanticLabel: l10n.avatarOption(i + 1),
                onTap: () => onChanged(AvatarCatalog.key(option, color)),
                child: AvatarView(avatarKey: AvatarCatalog.key(option, color), size: 44),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (i, option) in AvatarCatalog.colors.indexed)
              _Choice(
                selected: option == color,
                semanticLabel: l10n.avatarOption(i + 1),
                onTap: () => onChanged(AvatarCatalog.key(icon, option)),
                child: AvatarView(avatarKey: AvatarCatalog.key(icon, option), size: 32),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
          child: Divider(color: p.border),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.semanticLabel,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final String semanticLabel;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          constraints: const BoxConstraints(
            minWidth: AppSizes.minTapTarget,
            minHeight: AppSizes.minTapTarget,
          ),
          padding: const EdgeInsetsDirectional.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: selected ? p.primary : Colors.transparent, width: 2),
          ),
          // Size to the avatar — a plain Center would expand to the Wrap's full width.
          child: Center(widthFactor: 1, heightFactor: 1, child: child),
        ),
      ),
    );
  }
}
