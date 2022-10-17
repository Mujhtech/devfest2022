part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, ready, failed }

extension CameraStatusX on CameraStatus {
  bool get isLoading => this == CameraStatus.loading;
  bool get isReady => this == CameraStatus.ready;
  bool get isFailed => this == CameraStatus.failed;
}

class CameraState extends Equatable {
  final CameraStatus status;
  final List<CameraDescription> cameras;

  const CameraState({
    required this.cameras,
    this.status = CameraStatus.initial,
  });

  @override
  List<Object> get props => [status, cameras];

  CameraState copyWith({
    CameraStatus? status,
    List<CameraDescription>? cameras,
  }) {
    return CameraState(
      status: status ?? this.status,
      cameras: cameras ?? this.cameras,
    );
  }
}
