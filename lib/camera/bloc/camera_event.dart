part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraInitiated extends CameraEvent {
  const CameraInitiated();
}

class CameraCaptured extends CameraEvent {
  final double aspectRatio;
  final XFile image;

  const CameraCaptured({required this.aspectRatio, required this.image});

  @override
  List<Object> get props => [aspectRatio, image];
}

class CameraStickerTapped extends CameraEvent {
  const CameraStickerTapped({required this.sticker});

  final Asset sticker;

  @override
  List<Object> get props => [sticker];
}

class CameraStickerDragged extends CameraEvent {
  const CameraStickerDragged({required this.sticker, required this.update});

  final PhotoAsset sticker;
  final DragUpdate update;

  @override
  List<Object> get props => [sticker, update];
}

class CameraClearStickersTapped extends CameraEvent {
  const CameraClearStickersTapped();
}

class CameraClearAllTapped extends CameraEvent {
  const CameraClearAllTapped();
}

class CameraDeleteSelectedStickerTapped extends CameraEvent {
  const CameraDeleteSelectedStickerTapped();
}

class CameraTapped extends CameraEvent {
  const CameraTapped();
}
