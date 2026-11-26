import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindful/features/community/data/repositories/community_repository_impl.dart';
import 'package:mindful/features/community/domain/entities/post.dart';
import 'package:mindful/features/community/presentation/providers/community_providers.dart';
import 'package:mindful/features/community/presentation/providers/feed_controller.dart';

/// Creates or edits a post. On success the new version goes into the post store and the
/// feeds reload so a new post shows at the top.
final NotifierProvider<PostComposerController, AsyncValue<void>> postComposerControllerProvider =
    NotifierProvider.autoDispose<PostComposerController, AsyncValue<void>>(
      PostComposerController.new,
    );

class PostComposerController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Returns the saved post, or null on failure (the error is in `state`).
  Future<Post?> submit(PostDraft draft, {String? editingId}) async {
    state = const AsyncLoading();
    Post? saved;
    final actions = ref.read(postActionsProvider);
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(communityRepositoryProvider);
      saved = editingId == null
          ? await repo.createPost(draft)
          : await repo.updatePost(editingId, draft);
    });
    if (!ref.mounted) return saved;

    state = result;
    if (saved case final post?) {
      actions.replace(post);
      if (editingId == null) ref.invalidate(feedControllerProvider);
    }
    return saved;
  }
}
