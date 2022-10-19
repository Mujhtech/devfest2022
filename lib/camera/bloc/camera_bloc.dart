import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:devfest/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:devfest/common/common.dart';

part 'camera_state.dart';
part 'camera_event.dart';

typedef UuidGetter = String Function();

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc([UuidGetter? uuid])
      : uuid = uuid ?? const Uuid().v4,
        super(const CameraState(cameras: [])) {
    on<CameraInitiated>(_initiatedCamera);
    on<CameraCaptured>(_imageCaptured);
    on<CameraStickerTapped>(_stickerTapped);
    on<CameraStickerDragged>(_stickerDragged);
    on<CameraTapped>((event, emit) => state.copyWith(selectedAssetId: ''));
    on<CameraClearStickersTapped>((event, emit) => state.copyWith(
          stickers: const <PhotoAsset>[],
          selectedAssetId: '',
        ));
    on<CameraClearAllTapped>((event, emit) => state.copyWith(
          stickers: const <PhotoAsset>[],
          selectedAssetId: '',
        ));
    on<CameraDeleteSelectedStickerTapped>(_deleteSelectedSticker);
  }

  final UuidGetter uuid;

  Future<void> _deleteSelectedSticker(
    CameraDeleteSelectedStickerTapped event,
    Emitter<CameraState> emit,
  ) async {
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere(
      (element) => element.id == state.selectedAssetId,
    );
    final stickerExists = index != -1;

    if (stickerExists) {
      stickers.removeAt(index);
    }

    return emit(state.copyWith(
      stickers: stickers,
      selectedAssetId: '',
    ));
  }

  Future<void> _stickerDragged(
    CameraStickerDragged event,
    Emitter<CameraState> emit,
  ) async {
    final asset = event.sticker;
    final stickers = List.of(state.stickers);
    final index = stickers.indexWhere((element) => element.id == asset.id);
    final sticker = stickers.removeAt(index);
    stickers.add(
      sticker.copyWith(
        angle: event.update.angle,
        position: ImageAssetPosition(
          dx: event.update.position.dx,
          dy: event.update.position.dy,
        ),
        size: ImageAssetSize(
          width: event.update.size.width,
          height: event.update.size.height,
        ),
        constraint: ImageConstraint(
          width: event.update.constraints.width,
          height: event.update.constraints.height,
        ),
      ),
    );

    //
    return emit(state.copyWith(stickers: stickers, selectedAssetId: asset.id));
  }

  Future<void> _stickerTapped(
    CameraStickerTapped event,
    Emitter<CameraState> emit,
  ) async {
    final asset = event.sticker;
    final newSticker = PhotoAsset(id: uuid(), asset: asset);

    //
    return emit(state.copyWith(
      stickers: List.of(state.stickers)..add(newSticker),
      selectedAssetId: newSticker.id,
    ));
  }

  Future<void> _initiatedCamera(
    CameraInitiated event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final cameras = await availableCameras();
      return emit(state.copyWith(status: CameraStatus.ready, cameras: cameras));
    } catch (e) {
      //
      return emit(state.copyWith(status: CameraStatus.failed));
    }
  }

  Future<void> _imageCaptured(
    CameraCaptured event,
    Emitter<CameraState> emit,
  ) async {
    try {
      return emit(state.copyWith(
          status: CameraStatus.captured,
          imageId: uuid(),
          image: event.image,
          aspectRatio: event.aspectRatio));
    } catch (e) {
      //
      return emit(state.copyWith(status: CameraStatus.failed));
    }
  }
}
