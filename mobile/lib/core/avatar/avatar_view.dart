import 'package:flutter/material.dart';
import 'package:mindful/core/avatar/avatar_catalog.dart';

/// Renders a generated avatar key (`icon-color`) as a soft colored circle with an icon.
/// Used everywhere a member is shown (profile, posts, comments).
class AvatarView extends StatelessWidget {
  const AvatarView({required this.avatarKey, this.size = 48, this.semanticLabel, super.key});

  final String avatarKey;
  final double size;
  final String? semanticLabel;

  static const Map<String, IconData> _icons = {
    'lotus': Icons.spa_rounded,
    'leaf': Icons.eco_rounded,
    'cloud': Icons.cloud_rounded,
    'moon': Icons.nightlight_round,
    'sun': Icons.wb_sunny_rounded,
    'star': Icons.star_rounded,
    'wave': Icons.waves_rounded,
    'feather': Icons.air_rounded,
    'mountain': Icons.landscape_rounded,
    'flower': Icons.local_florist_rounded,
    'butterfly': Icons.emoji_nature_rounded,
    'tree': Icons.park_rounded,
  };

  /// Pastel backgrounds with a darker foreground of the same hue (readable in both themes).
  static const Map<String, (Color background, Color foreground)> _colors = {
    'lavender': (Color(0xFFE4DAFB), Color(0xFF6A4BC4)),
    'rose': (Color(0xFFFADDE4), Color(0xFFB0405E)),
    'sky': (Color(0xFFD9EBFB), Color(0xFF2F6FA8)),
    'mint': (Color(0xFFD7F2E6), Color(0xFF2B7A5B)),
    'peach': (Color(0xFFFDE4D2), Color(0xFFB0602A)),
    'sand': (Color(0xFFF3EAD6), Color(0xFF85683A)),
    'lilac': (Color(0xFFF0DDF5), Color(0xFF8A3FA0)),
    'sea': (Color(0xFFD4EFF0), Color(0xFF237479)),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = AvatarCatalog.parse(avatarKey);
    final (background, foreground) = _colors[color]!; // parse() only returns known colors

    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(_icons[icon], size: size * 0.5, color: foreground),
      ),
    );
  }
}
