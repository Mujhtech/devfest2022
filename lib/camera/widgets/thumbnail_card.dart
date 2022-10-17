import 'dart:io';

import 'package:camera/camera.dart';
import 'package:devfest/app/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ThumbnailCard extends StatelessWidget {
  final VideoPlayerController? localVideoController;
  final XFile? imageFile;
  const ThumbnailCard({super.key, this.localVideoController, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (localVideoController == null && imageFile == null)
          Container()
        else
          Container(
            width: 50.0,
            height: 50.0,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(width: 2, color: AppColor.white)),
            child: (localVideoController == null)
                ? (
                    // The captured image on the web contains a network-accessible URL
                    // pointing to a location within the browser. It may be displayed
                    // either with Image.network or Image.memory after loading the image
                    // bytes to memory.
                    kIsWeb
                        ? Image.network(
                            imageFile!.path,
                            width: 50.0,
                            height: 50.0,
                          )
                        : Image.file(
                            File(imageFile!.path),
                            width: 50.0,
                            height: 50.0,
                          ))
                : Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.pink)),
                    child: Center(
                      child: AspectRatio(
                          aspectRatio: localVideoController != null
                              ? localVideoController!.value.aspectRatio
                              : 1.0,
                          child: VideoPlayer(localVideoController!)),
                    ),
                  ),
          ),
      ],
    );
  }
}
