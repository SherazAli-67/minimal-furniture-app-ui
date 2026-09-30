import 'package:flutter/material.dart';
import 'package:minimal_furniture_app/constants/number_constant.dart';

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = NumberConstant.animNormal,
    this.offset = NumberConstant.animSlideOffset,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + delay,
      curve: Interval(
        delay.inMilliseconds / (duration + delay).inMilliseconds,
        1,
        curve: Curves.easeOutCubic,
      ),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, offset * (1 - value)), child: child,),
      ),
      child: child,
    );
  }
}
