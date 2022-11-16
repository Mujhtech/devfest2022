import 'package:devfest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraToggle extends StatelessWidget {
  final CameraController? controller;
  final Function() onPressed;
  final List<CameraDescription> cameras;
  const CameraToggle(
      {super.key,
      required this.onPressed,
      required this.cameras,
      this.controller});

  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        throw ArgumentError('Unknown lens direction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return controller != null
        ? IconButton(
            icon:
                Icon(getCameraLensIcon(controller!.description.lensDirection)),
            color: AppColor.white,
            onPressed: () {
              controller != null && controller!.value.isRecordingVideo
                  ? null
                  : onPressed();
            })
        : Container();
  }
}
