part of 'preview_bloc.dart';

abstract class PreviewEvent extends Equatable {
  const PreviewEvent();

  @override
  List<Object?> get props => [];
}

class PreviewDrawerToggled extends PreviewEvent {
  const PreviewDrawerToggled();
}

class PreviewSaved extends PreviewEvent {
  final XFile image;
  final List<PhotoAsset> assets;
  final double aspectRatio;
  final bool isSaveEnabled;
  final String imageId;

  const PreviewSaved(
      {required this.assets,
      required this.aspectRatio,
      required this.image,
      required this.imageId,
      required this.isSaveEnabled});
}

class PreviewShared extends PreviewEvent {
  final XFile image;
  final List<PhotoAsset> assets;
  final double aspectRatio;
  final bool isSharingEnabled;
  final String imageId;

  const PreviewShared(
      {required this.assets,
      required this.aspectRatio,
      required this.image,
      required this.imageId,
      required this.isSharingEnabled});
}
