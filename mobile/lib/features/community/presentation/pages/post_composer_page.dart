import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/core/errors/app_exception.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/core/widgets/app_snack_bar.dart';
import 'package:mindful/core/widgets/app_text_field.dart';
import 'package:mindful/core/widgets/form_page.dart';
import 'package:mindful/core/widgets/primary_button.dart';
import 'package:mindful/core/widgets/state_views.dart';
import 'package:mindful/features/community/domain/entities/community_enums.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/providers/post_composer_controller.dart';
import 'package:mindful/features/community/presentation/providers/post_store.dart';
import 'package:mindful/features/community/presentation/widgets/composer_options.dart';
import 'package:mindful/features/profile/presentation/providers/current_profile_provider.dart';

/// Create (no [postId]) or edit a post (FR-COM-002).
class PostComposerPage extends ConsumerWidget {
  const PostComposerPage({this.postId, super.key});

  final String? postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = postId;
    if (id == null) return const _ComposerForm();

    // Editing: start from the freshest known version of the post.
    final loaded = ref.watch(postDetailProvider(id));
    final store = ref.watch(postStoreProvider);
    return loaded.when(
      loading: () => const Scaffold(body: AppBackground(child: LoadingView())),
      error: (error, _) => Scaffold(
        body: AppBackground(
          child: ErrorView(error: error, onRetry: () => ref.invalidate(postDetailProvider(id))),
        ),
      ),
      data: (post) => _ComposerForm(editing: store.resolve(post) ?? post),
    );
  }
}

class _ComposerForm extends ConsumerStatefulWidget {
  const _ComposerForm({this.editing});

  final Post? editing;

  @override
  ConsumerState<_ComposerForm> createState() => _ComposerFormState();
}

class _ComposerFormState extends ConsumerState<_ComposerForm> {
  static const int maxLength = 2000;

  final _formKey = GlobalKey<FormState>();
  late final _content = TextEditingController(text: widget.editing?.content);
  late String? _category = widget.editing?.category.slug;
  late ContentWarning? _warning = widget.editing?.contentWarning;
  late bool _allowComments = widget.editing?.allowComments ?? true;
  late bool _onlyMe = widget.editing?.visibility == PostVisibility.onlyMe;
  bool _categoryMissing = false;

  bool get _isEdit => widget.editing != null;

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _categoryMissing = _category == null);
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid || _category == null) return;

    final draft = PostDraft(
      categorySlug: _category!, // Checked above.
      content: _content.text.trim(),
      contentWarning: _warning,
      allowComments: _allowComments,
      visibility: _onlyMe ? PostVisibility.onlyMe : PostVisibility.community,
    );
    final saved = await ref
        .read(postComposerControllerProvider.notifier)
        .submit(draft, editingId: widget.editing?.id);
    if (!mounted) return;

    if (saved != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? l10n.postUpdated : l10n.postShared)),
      );
      context.pop();
      return;
    }
    final error = ref.read(postComposerControllerProvider).error;
    if (error != null && error is! ValidationException) showErrorSnackBar(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final submitting = ref.watch(postComposerControllerProvider).isLoading;
    final error = ref.watch(postComposerControllerProvider).error;
    final fieldErrors = error is ValidationException ? error : null;
    final me = ref.watch(currentProfileProvider).value?.profile;

    return FormPage(
      title: _isEdit ? l10n.composerEditTitle : l10n.composerNewTitle,
      subtitle: me == null ? null : l10n.composerSubtitle(me.username),
      badge: l10n.composerBadge,
      bottom: PrimaryButton(
        label: _isEdit ? l10n.composerSaveChanges : l10n.composerPublish,
        isLoading: submitting,
        onPressed: _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.composerCategory, style: context.textStyles.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            CategoryGrid(
              selected: _category,
              onSelected: (slug) => setState(() {
                _category = slug;
                _categoryMissing = false;
              }),
            ),
            if (_categoryMissing || fieldErrors?.firstErrorFor('category') != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: AppSpacing.xs),
                child: Text(
                  fieldErrors?.firstErrorFor('category') ?? l10n.composerCategoryRequired,
                  style: context.textStyles.bodySmall?.copyWith(color: context.palette.danger),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              label: l10n.composerContent,
              hint: l10n.composerContentHint,
              controller: _content,
              maxLength: maxLength,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              errorText: fieldErrors?.firstErrorFor('content'),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? l10n.composerContentRequired : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.composerContentWarning, style: context.textStyles.titleMedium),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.composerContentWarningHelp,
              style: context.textStyles.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            ContentWarningPicker(
              selected: _warning,
              onSelected: (warning) => setState(() => _warning = warning),
            ),
            const SizedBox(height: AppSpacing.lg),
            ComposerSwitch(
              title: l10n.composerAllowComments,
              value: _allowComments,
              onChanged: (value) => setState(() => _allowComments = value),
            ),
            ComposerSwitch(
              title: l10n.composerHideFromCommunity,
              subtitle: l10n.composerHideFromCommunityHelp,
              value: _onlyMe,
              onChanged: (value) => setState(() => _onlyMe = value),
            ),
          ],
        ),
      ),
    );
  }
}
