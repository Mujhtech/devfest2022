part of 'preview_bloc.dart';

enum ShareStatus { initial, loading, success, failure }

enum ShareUrl { none, twitter, facebook }

extension ShareStatusX on ShareStatus {
  bool get isLoading => this == ShareStatus.loading;
  bool get isSuccess => this == ShareStatus.success;
  bool get isFailure => this == ShareStatus.failure;
}

class PreviewState extends Equatable {
  const PreviewState({
    this.isDrawerActive = false,
    this.shouldDisplayPropsReminder = true,
    this.imageId,
    this.image,
    this.assets,
    this.aspectRatio,
    this.isSaveEnabled = false,
    this.isSharingEnabled = false,
    this.compositeStatus = ShareStatus.initial,
    this.uploadStatus = ShareStatus.initial,
    this.file,
    this.bytes,
    this.explicitShareUrl = '',
    this.facebookShareUrl = '',
    this.twitterShareUrl = '',
    this.shareUrl = ShareUrl.none,
  });

  final bool isDrawerActive;
  final bool shouldDisplayPropsReminder;
  final String? imageId;
  final XFile? image;
  final List<PhotoAsset>? assets;
  final double? aspectRatio;
  final bool isSharingEnabled;
  final bool isSaveEnabled;
  final ShareStatus compositeStatus;
  final ShareStatus uploadStatus;
  final XFile? file;
  final Uint8List? bytes;
  final String explicitShareUrl;
  final String twitterShareUrl;
  final String facebookShareUrl;
  final ShareUrl shareUrl;

  @override
  List<Object?> get props => [
        isDrawerActive,
        shouldDisplayPropsReminder,
        shareUrl,
        imageId,
        image,
        assets,
        aspectRatio,
        isSaveEnabled,
        isSharingEnabled,
        compositeStatus,
        uploadStatus,
        file,
        bytes,
        twitterShareUrl,
        facebookShareUrl,
      ];

  PreviewState copyWith({
    bool? isDrawerActive,
    String? imageId,
    bool? shouldDisplayPropsReminder,
    bool? isSharingEnabled,
    List<PhotoAsset>? assets,
    XFile? image,
    double? aspectRatio,
    bool? isSaveEnabled,
    ShareStatus? compositeStatus,
    ShareStatus? uploadStatus,
    XFile? file,
    Uint8List? bytes,
    String? explicitShareUrl,
    String? twitterShareUrl,
    String? facebookShareUrl,
    ShareUrl? shareUrl,
  }) {
    return PreviewState(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      imageId: imageId ?? this.imageId,
      image: image ?? this.image,
      assets: assets ?? this.assets,
      isSaveEnabled: isSaveEnabled ?? this.isSaveEnabled,
      isSharingEnabled: isSharingEnabled ?? this.isSharingEnabled,
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      shouldDisplayPropsReminder:
          shouldDisplayPropsReminder ?? this.shouldDisplayPropsReminder,
      compositeStatus: compositeStatus ?? this.compositeStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      file: file ?? this.file,
      bytes: bytes ?? this.bytes,
      explicitShareUrl: explicitShareUrl ?? this.explicitShareUrl,
      twitterShareUrl: twitterShareUrl ?? this.twitterShareUrl,
      facebookShareUrl: facebookShareUrl ?? this.facebookShareUrl,
      shareUrl: shareUrl ?? this.shareUrl,
    );
  }
}
