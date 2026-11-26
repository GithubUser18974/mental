import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/features/community/domain/entities/post.dart';

/// Up to four post images: one large, or a 2-column grid. Signed URLs expire, so a
/// failed load shows a calm placeholder instead of an error.
class PostImages extends StatelessWidget {
  const PostImages({required this.images, super.key});

  final List<PostImage> images;

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      final image = images.first;
      final ratio = image.width > 0 && image.height > 0 ? image.width / image.height : 4 / 3;
      return _Tile(image: image, aspectRatio: ratio.clamp(0.75, 1.8));
    }
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.xs,
      crossAxisSpacing: AppSpacing.xs,
      children: [for (final image in images.take(4)) _Tile(image: image)],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.image, this.aspectRatio = 1});

  final PostImage image;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: AppRadius.mdAll,
        child: ColoredBox(
          color: p.surfaceMuted,
          child: Image.network(
            image.url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Center(child: Icon(Icons.image_outlined, color: p.primaryLight, size: 32)),
          ),
        ),
      ),
    );
  }
}
