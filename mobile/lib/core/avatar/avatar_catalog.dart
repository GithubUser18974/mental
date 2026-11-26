/// Generated avatars: an illustration + a soft color, keyed `icon-color`.
/// Mirrors the backend `AvatarCatalog` (artwork ships with the app, so new
/// options always need an app release anyway).
abstract final class AvatarCatalog {
  static const List<String> icons = [
    'lotus',
    'leaf',
    'cloud',
    'moon',
    'sun',
    'star',
    'wave',
    'feather',
    'mountain',
    'flower',
    'butterfly',
    'tree',
  ];

  static const List<String> colors = [
    'lavender',
    'rose',
    'sky',
    'mint',
    'peach',
    'sand',
    'lilac',
    'sea',
  ];

  static String key(String icon, String color) => '$icon-$color';

  /// Splits `icon-color`; unknown keys fall back to the first option.
  static (String icon, String color) parse(String key) {
    final parts = key.split('-');
    final icon = parts.isNotEmpty && icons.contains(parts.first) ? parts.first : icons.first;
    final color = parts.length > 1 && colors.contains(parts[1]) ? parts[1] : colors.first;
    return (icon, color);
  }
}
