import 'package:flutter/cupertino.dart';
import 'package:simple_animations/simple_animations.dart';

enum _AniProps { opacity, translate }

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool translateX;

  FadeIn({this.delay, this.child, this.translateX = true});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()
      ..add(_AniProps.opacity, Tween(begin: 0.0, end: 1.0,))
      ..add(_AniProps.translate, Tween(begin: 130.0, end: 0.0,));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: Duration(milliseconds: 500),
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: translateX ? Offset(value.get(_AniProps.translate), 0) : Offset(0, value.get(_AniProps.translate)),
          child: child,
        ),
      ),
    );
  }
}