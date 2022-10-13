import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? controller;
  final Function(TapDownDetails, BoxConstraints) onViewFinderTap;
  final Function() incrementPointer;
  final Function() decrementPointer;
  final Function(ScaleStartDetails) handleScaleStart;
  final Function(ScaleUpdateDetails) handleScaleUpdate;
  const CameraPreviewWidget(
      {super.key,
      this.controller,
      required this.onViewFinderTap,
      required this.incrementPointer,
      required this.decrementPointer,
      required this.handleScaleStart,
      required this.handleScaleUpdate});

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(
          child: Text('Tap a camera',
              style: Theme.of(context).textTheme.headline2));
    } else {
      return Listener(
        onPointerDown: (_) => incrementPointer,
        onPointerUp: (_) => decrementPointer,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: handleScaleStart,
              onScaleUpdate: handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }
}
