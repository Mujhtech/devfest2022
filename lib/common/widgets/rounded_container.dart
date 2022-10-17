import 'package:devfest/extensions/screen.dart';
import 'package:flutter/material.dart';

class RoundedBorderOnSomeSidesWidget extends StatelessWidget {
  /// Color of the content behind this widget
  final Color contentBackgroundColor;
  final Color borderColor;
  final Widget child;

  final double borderRadius;
  final double borderWidth;
  final EdgeInsets? padding;

  /// The sides where we want the rounded border to be
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;
  final double? width;

  const RoundedBorderOnSomeSidesWidget({super.key, 
    required this.borderColor,
    required this.contentBackgroundColor,
    required this.child,
    required this.borderRadius,
    required this.borderWidth,
    this.padding,
    this.width,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.screenWidth(1),
      decoration: BoxDecoration(
        color: borderColor,
        borderRadius: BorderRadius.only(
          topLeft: topLeft ? Radius.circular(borderRadius) : Radius.zero,
          topRight: topRight ? Radius.circular(borderRadius) : Radius.zero,
          bottomLeft: bottomLeft ? Radius.circular(borderRadius) : Radius.zero,
          bottomRight: bottomRight ? Radius.circular(borderRadius) : Radius.zero,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
          top: topLeft || topRight ? borderWidth : 0,
          left: topLeft || bottomLeft ? borderWidth : 0,
          bottom: bottomLeft || bottomRight ? borderWidth : 0,
          right: topRight || bottomRight ? borderWidth : 0,
        ),
        padding: padding,
        decoration: BoxDecoration(
          color: contentBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: topLeft ? Radius.circular(borderRadius - borderWidth) : Radius.zero,
            topRight: topRight ? Radius.circular(borderRadius - borderWidth) : Radius.zero,
            bottomLeft: bottomLeft ? Radius.circular(borderRadius - borderWidth) : Radius.zero,
            bottomRight: bottomRight ? Radius.circular(borderRadius - borderWidth) : Radius.zero,
          ),
        ),
        child: child,
      ),
    );
  }
}