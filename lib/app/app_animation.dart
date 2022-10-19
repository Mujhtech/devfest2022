import 'package:devfest/app/app.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

const _defaultFadeInDuration = Duration(seconds: 1);

/// {@template animated_fade_in}
/// Widget that applies a fade in transition to its child.
/// {@endtemplate}
class AnimatedFadeIn extends StatefulWidget {
  /// {@macro animated_fade_in}
  const AnimatedFadeIn({
    Key? key,
    required this.child,
    this.duration = _defaultFadeInDuration,
  }) : super(key: key);

  /// The child which will be faded in.
  final Widget child;

  /// The duration of the fade in animation.
  final Duration duration;

  @override
  _AnimatedFadeInState createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<AnimatedFadeIn> {
  var _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _isVisible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      opacity: _isVisible ? 1.0 : 0.0,
      child: widget.child,
    );
  }
}

/// Default duration for a single pulse animation.
const defaultPulseDuration = Duration(milliseconds: 1600);

/// Default duration for the time between pulse animations.
const defaultTimeBetweenPulses = Duration(milliseconds: 800);

/// {@template animated_pulse}
/// Widget that applies a pulse animation to its child.
/// {@endtemplate}
class AnimatedPulse extends StatefulWidget {
  /// {@macro animated_pulse}
  const AnimatedPulse({
    Key? key,
    this.pulseDuration = defaultPulseDuration,
    this.timeBetweenPulses = defaultTimeBetweenPulses,
    required this.child,
  }) : super(key: key);

  /// [Widget] that will have the pulse animation
  final Widget child;

  /// The duration of a single pulse animation.
  final Duration pulseDuration;

  /// The duration of the time between pulse animations.
  final Duration timeBetweenPulses;

  @override
  _AnimatedPulseState createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.pulseDuration)
          ..addStatusListener(_onAnimationStatusChanged)
          ..forward();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (!mounted) return;
    if (status == AnimationStatus.completed) {
      _timer = Timer(widget.timeBetweenPulses, () {
        if (mounted) _controller.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller
      ..removeStatusListener(_onAnimationStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PulsePainter(_controller),
      child: widget.child,
    );
  }
}

/// {@template pulse_painter}
/// Painter for the pulse animation
/// {@endtemplate}
class PulsePainter extends CustomPainter {
  /// {@macro pulse_painter}
  const PulsePainter(this._animation) : super(repaint: _animation);

  final Animation<double> _animation;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    const color = AppColor.primary1;
    final circleSize = rect.width / 2;
    final area = circleSize * circleSize;
    final radius = sqrt(area * _animation.value * 3);
    final opacity = (1.0 - (_animation.value).clamp(0.0, 1.0));
    final paint = Paint()..color = color.withOpacity(opacity);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  bool shouldRepaint(PulsePainter oldDelegate) => true;
}

class Sprites {
  /// {@macro sprites}
  const Sprites({
    required this.asset,
    required this.size,
    required this.frames,
    this.stepTime = 0.1,
  });

  /// The sprite sheet asset name.
  /// This should be the name of the file within
  /// the `assets/images` directory.
  final String asset;

  /// The size an individual sprite within the sprite sheet
  final Size size;

  /// The number of frames within the sprite sheet.
  final int frames;

  /// Number of seconds per frame. Defaults to 0.1.
  final double stepTime;
}

/// The animation mode which determines when the animation plays.
enum AnimationMode {
  /// Animations plays on a loop
  loop,

  /// Animations plays immediately once
  oneTime
}

/// {@template animated_sprite}
/// A widget which renders an animated sprite
/// given a collection of sprites.
/// {@endtemplate}
class AnimatedSprite extends StatefulWidget {
  /// {@macro animated_sprite}
  const AnimatedSprite({
    Key? key,
    required this.sprites,
    this.mode = AnimationMode.loop,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor = AppColor.primary3,
  }) : super(key: key);

  /// The collection of sprites which will be animated.
  final Sprites sprites;

  /// The mode of animation (`trigger`, `loop` or `oneTime`).
  final AnimationMode mode;

  /// Where should display a loading indicator while loading the sprite
  final bool showLoadingIndicator;

  /// Color for loading indicator
  final Color loadingIndicatorColor;

  @override
  _AnimatedSpriteState createState() => _AnimatedSpriteState();
}

enum _AnimatedSpriteStatus { loading, loaded, failure }

extension on _AnimatedSpriteStatus {
  /// Returns true for `_AnimatedSpriteStatus.loaded`.
  bool get isLoaded => this == _AnimatedSpriteStatus.loaded;
}

class _AnimatedSpriteState extends State<AnimatedSprite> {
  late SpriteSheet _spriteSheet;
  late SpriteAnimation _animation;
  Timer? _timer;
  var _status = _AnimatedSpriteStatus.loading;
  var _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadAnimation() async {
    try {
      _spriteSheet = SpriteSheet(
        image: await Flame.images.load(widget.sprites.asset),
        srcSize: Vector2(widget.sprites.size.width, widget.sprites.size.height),
      );
      _animation = _spriteSheet.createAnimation(
        row: 0,
        stepTime: widget.sprites.stepTime,
        to: widget.sprites.frames,
        loop: widget.mode == AnimationMode.loop,
      );

      setState(() {
        _status = _AnimatedSpriteStatus.loaded;
        if (widget.mode == AnimationMode.loop ||
            widget.mode == AnimationMode.oneTime) {
          _isPlaying = true;
        }
      });
    } catch (_) {
      setState(() => _status = _AnimatedSpriteStatus.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedCrossFade(
      firstChild: widget.showLoadingIndicator
          ? SizedBox.fromSize(
              size: const Size(20, 20),
              child: AppCircularProgressIndicator(
                strokeWidth: 2,
                color: widget.loadingIndicatorColor,
              ),
            )
          : const SizedBox(),
      secondChild: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: _status.isLoaded
            ? SpriteAnimationWidget(animation: _animation, playing: _isPlaying)
            : const SizedBox(),
      ),
      crossFadeState: _status.isLoaded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}

class AppAnimatedCrossFade extends StatelessWidget {
  /// {@macro app_animated_cross_fade}
  const AppAnimatedCrossFade({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.crossFadeState,
  }) : super(key: key);

  /// First [Widget] to display
  final Widget firstChild;

  /// Second [Widget] to display
  final Widget secondChild;

  /// Specifies when to display [firstChild] or [secondChild]
  final CrossFadeState crossFadeState;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: crossFadeState,
      duration: const Duration(seconds: 1),
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              key: bottomChildKey,
              child: bottomChild,
            ),
            Align(
              alignment: Alignment.center,
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}
