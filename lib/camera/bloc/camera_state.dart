part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, ready, failed, captured }

extension CameraStatusX on CameraStatus {
  bool get isLoading => this == CameraStatus.loading;
  bool get isReady => this == CameraStatus.ready;
  bool get isFailed => this == CameraStatus.failed;
  bool get isCaptured => this == CameraStatus.captured;
}

class ImageConstraint extends Equatable {
  const ImageConstraint({this.width = 1, this.height = 1});

  final double width;
  final double height;

  @override
  List<Object> get props => [width, height];
}

class ImageAssetSize extends Equatable {
  const ImageAssetSize({this.width = 1, this.height = 1});

  final double width;
  final double height;

  @override
  List<Object?> get props => [width, height];
}

class ImageAssetPosition extends Equatable {
  const ImageAssetPosition({this.dx = 0, this.dy = 0});

  final double dx;
  final double dy;

  @override
  List<Object> get props => [dx, dy];
}

class PhotoAsset extends Equatable {
  const PhotoAsset({
    required this.id,
    required this.asset,
    this.angle = 0.0,
    this.constraint = const ImageConstraint(),
    this.position = const ImageAssetPosition(),
    this.size = const ImageAssetSize(),
  });

  final String id;
  final Asset asset;
  final double angle;
  final ImageConstraint constraint;
  final ImageAssetPosition position;
  final ImageAssetSize size;

  @override
  List<Object> get props => [id, asset.name, angle, constraint, position, size];

  PhotoAsset copyWith({
    Asset? asset,
    double? angle,
    ImageConstraint? constraint,
    ImageAssetPosition? position,
    ImageAssetSize? size,
  }) {
    return PhotoAsset(
      id: id,
      asset: asset ?? this.asset,
      angle: angle ?? this.angle,
      constraint: constraint ?? this.constraint,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

class CameraState extends Equatable {
  final CameraStatus status;
  final List<CameraDescription> cameras;
  final XFile? image;
  final List<PhotoAsset> stickers;
  final String imageId;
  final String selectedAssetId;
  final double? aspectRatio;

  const CameraState(
      {required this.cameras,
      this.image,
      this.status = CameraStatus.initial,
      this.stickers = const <PhotoAsset>[],
      this.selectedAssetId = '',
      this.imageId = '',
      this.aspectRatio});

  @override
  List<Object?> get props =>
      [status, cameras, image, stickers, imageId, selectedAssetId, aspectRatio];

  CameraState copyWith(
      {CameraStatus? status,
      List<CameraDescription>? cameras,
      XFile? image,
      List<PhotoAsset>? stickers,
      double? aspectRatio,
      String? imageId,
      String? selectedAssetId}) {
    return CameraState(
        status: status ?? this.status,
        cameras: cameras ?? this.cameras,
        image: image ?? this.image,
        imageId: imageId ?? this.imageId,
        stickers: stickers ?? this.stickers,
        aspectRatio: aspectRatio ?? this.aspectRatio,
        selectedAssetId: selectedAssetId ?? this.selectedAssetId);
  }
}
