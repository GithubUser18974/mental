import 'package:flutter/material.dart';
import 'package:mindful/app/theme/app_dimens.dart';

/// Gentle 0.97 press-scale feedback; disabled when the OS asks to reduce motion.
class PressableScale extends StatefulWidget {
  const PressableScale({required this.child, required this.enabled, super.key});

  final Widget child;
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _set(bool value) {
    if (widget.enabled && _pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed && !reduceMotion ? AppMotion.pressedScale : 1,
        duration: AppMotion.fast,
        curve: AppMotion.curve,
        child: widget.child,
      ),
    );
  }
}
