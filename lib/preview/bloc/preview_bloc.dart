import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:devfest/camera/bloc/camera_bloc.dart';
import 'package:devfest/core/core.dart';
import 'package:devfest/image_compositor/image_compositor.dart';
import 'package:equatable/equatable.dart';

part 'preview_event.dart';
part 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc({required PhotosRepository photosRepository})
      : _photosRepository = photosRepository,
        super(const PreviewState()) {
    on<PreviewDrawerToggled>(_toggle);
    on<PreviewSaved>(_save);
    on<PreviewShared>(_share);
  }

  final PhotosRepository _photosRepository;

  Future<void> _save(
    PreviewSaved event,
    Emitter<PreviewState> emit,
  ) async {
    try {
      emit(state.copyWith(compositeStatus: ShareStatus.loading));
      final bytes = await _composite(
          data: event.image.path,
          width: 200,
          height: 200,
          aspectRatio: event.aspectRatio,
          assets: event.assets);

      final file = XFile.fromData(
        bytes,
        mimeType: 'image/png',
        name: _getPhotoFileName(event.imageId),
      );
      final shareUrls = await _photosRepository.sharePhoto(
        fileName: _getPhotoFileName(event.imageId),
        data: bytes,
        shareText: '',
      );
      emit(state.copyWith(
        bytes: bytes,
        file: file,
        compositeStatus: ShareStatus.success,
        explicitShareUrl: shareUrls.explicitShareUrl,
        facebookShareUrl: shareUrls.facebookShareUrl,
        twitterShareUrl: shareUrls.twitterShareUrl,
      ));
    } catch (e) {
      //
      print(e);
    }
  }

  Future<void> _share(
    PreviewShared event,
    Emitter<PreviewState> emit,
  ) async {
    try {
      emit(state.copyWith(compositeStatus: ShareStatus.loading));
      final bytes = await _composite(
          data: event.image.path,
          width: 200,
          height: 200,
          aspectRatio: event.aspectRatio,
          assets: event.assets);

      final file = XFile.fromData(
        bytes,
        mimeType: 'image/png',
        name: _getPhotoFileName(event.imageId),
      );
      final shareUrls = await _photosRepository.sharePhoto(
        fileName: _getPhotoFileName(event.imageId),
        data: bytes,
        shareText: '',
      );
      emit(state.copyWith(
        bytes: bytes,
        file: file,
        compositeStatus: ShareStatus.success,
        explicitShareUrl: shareUrls.explicitShareUrl,
        facebookShareUrl: shareUrls.facebookShareUrl,
        twitterShareUrl: shareUrls.twitterShareUrl,
      ));
    } catch (e) {
      //
      print(e);
    }
  }

  Future<void> _toggle(
    PreviewDrawerToggled event,
    Emitter<PreviewState> emit,
  ) async {
    return emit(state.copyWith(
      isDrawerActive: !state.isDrawerActive,
      shouldDisplayPropsReminder: false,
    ));
  }

  Future<Uint8List> _composite(
      {required String data,
      required int width,
      required int height,
      required double aspectRatio,
      required List<PhotoAsset> assets}) async {
    final composite = await _photosRepository.composite(
      aspectRatio: aspectRatio,
      data: data,
      width: width,
      height: height,
      layers: [
        ...assets.map(
          (l) => CompositeLayer(
            angle: l.angle,
            assetPath: 'assets/${l.asset.path}',
            constraints: Vector2D(l.constraint.width, l.constraint.height),
            position: Vector2D(l.position.dx, l.position.dy),
            size: Vector2D(l.size.width, l.size.height),
          ),
        )
      ],
    );
    return Uint8List.fromList(composite);
  }

  String _getPhotoFileName(String photoName) => '$photoName.png';
}
