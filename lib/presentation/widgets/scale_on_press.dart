import 'package:flutter/material.dart';
import 'package:minimal_furniture_app/constants/number_constant.dart';

class ScaleOnPress extends StatefulWidget {
  const ScaleOnPress({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<ScaleOnPress> createState() => _ScaleOnPressState();
}

class _ScaleOnPressState extends State<ScaleOnPress> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? NumberConstant.animPressScale : 1,
        duration: NumberConstant.animFast,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
