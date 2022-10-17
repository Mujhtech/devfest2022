import 'package:flutter/material.dart';

class BrokenImage extends StatelessWidget {
  final Color? color;
  final double? size;
  const BrokenImage({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.broken_image,
        size: size ?? 20, color: color ?? Theme.of(context).iconTheme.color);
  }
}
