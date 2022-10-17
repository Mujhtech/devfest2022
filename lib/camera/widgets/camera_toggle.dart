import 'package:devfest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraToggle extends StatelessWidget {
  final CameraController? controller;
  final Function(CameraDescription) onPressed;
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
    final List<Widget> toggles = <Widget>[];

    if (cameras.isEmpty) {
      return Container();
    } else {
      for (final CameraDescription cameraDescription in cameras) {
        toggles.add(IconButton(
            icon: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
            color: controller?.description == cameraDescription
                ? AppColor.primary3
                : AppColor.white,
            onPressed: () {
              controller != null && controller!.value.isRecordingVideo
                  ? null
                  : onPressed(cameraDescription);
            }));
        //   RadioListTile<CameraDescription>(
        //     title:
        //     groupValue: controller?.description,
        //     value: cameraDescription,
        //     onChanged:

        //   ),
        // );
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: toggles);
  }
}
