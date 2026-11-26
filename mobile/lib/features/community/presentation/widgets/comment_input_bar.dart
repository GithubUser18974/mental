import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_shadows.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/avatar/avatar_view.dart';
import 'package:mindful/features/community/domain/entities/comment.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Floating pill comment bar (design system): my avatar, text field, gradient send button.
/// Shows a "Replying to …" chip when answering a comment.
class CommentInputBar extends ConsumerStatefulWidget {
  const CommentInputBar({
    required this.onSend,
    required this.onCancelReply,
    this.replyTo,
    super.key,
  });

  /// Returns true when sent (the field is then cleared).
  final Future<bool> Function(String text) onSend;
  final VoidCallback onCancelReply;
  final Comment? replyTo;

  static const int maxLength = 1000;

  @override
  ConsumerState<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends ConsumerState<CommentInputBar> {
  final _text = TextEditingController();
  final _focus = FocusNode();
  bool _sending = false;

  @override
  void didUpdateWidget(CommentInputBar old) {
    super.didUpdateWidget(old);
    if (widget.replyTo != null && widget.replyTo?.id != old.replyTo?.id) _focus.requestFocus();
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _text.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final sent = await widget.onSend(text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (sent) _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final p = context.palette;
    final me = ref.watch(currentProfileProvider).value?.profile;
    final replyTo = widget.replyTo;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screen,
        AppSpacing.xs,
        AppSpacing.screen,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (replyTo != null && replyTo.author != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.replyingTo(replyTo.author!.username), // Checked in the `if`.
                    style: context.textStyles.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: l10n.cancelReply,
                  icon: Icon(Icons.close_rounded, size: 18, color: p.textSecondary),
                  onPressed: widget.onCancelReply,
                ),
              ],
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: p.surface,
              borderRadius: AppRadius.xlAll,
              border: Border.all(color: p.border),
              boxShadow: AppShadows.soft(p, context.brightness),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.xs,
                AppSpacing.xxs,
                AppSpacing.xxs,
                AppSpacing.xxs,
              ),
              child: Row(
                children: [
                  if (me != null) AvatarView(avatarKey: me.avatar, size: 36),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: TextField(
                      controller: _text,
                      focusNode: _focus,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: CommentInputBar.maxLength,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: l10n.commentHint,
                        counterText: '',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsetsDirectional.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  _SendButton(sending: _sending, label: l10n.sendComment, onPressed: _submit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.sending, required this.label, required this.onPressed});

  final bool sending;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: AppSizes.minTapTarget,
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: p.primaryGradient, shape: BoxShape.circle),
          child: Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: sending ? null : onPressed,
              child: Center(
                child: sending
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: p.onPrimary),
                      )
                    // Mirrors in RTL.
                    : Icon(Icons.send_rounded, color: p.onPrimary, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
