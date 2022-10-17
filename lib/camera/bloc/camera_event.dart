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
  const CameraCaptured();
}
