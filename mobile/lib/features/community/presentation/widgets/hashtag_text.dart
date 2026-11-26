import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_theme.dart';
import 'package:mindful/app/theme/app_typography.dart';

/// Post/comment text with `#hashtags` highlighted (Latin and Arabic tags).
class HashtagText extends StatelessWidget {
  const HashtagText(this.text, {this.maxLines, this.style, super.key});

  final String text;
  final int? maxLines;
  final TextStyle? style;

  static final RegExp _tag = RegExp(r'#[\p{L}\p{N}_]+', unicode: true);

  @override
  Widget build(BuildContext context) {
    final base = style ?? context.textStyles.bodyLarge;
    final tagStyle = base?.withWeight(FontWeight.w600).copyWith(color: context.palette.primary);

    final spans = <TextSpan>[];
    var start = 0;
    for (final match in _tag.allMatches(text)) {
      if (match.start > start) spans.add(TextSpan(text: text.substring(start, match.start)));
      spans.add(TextSpan(text: match.group(0), style: tagStyle));
      start = match.end;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));

    return Text.rich(
      TextSpan(style: base, children: spans),
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.clip : TextOverflow.ellipsis,
    );
  }
}
