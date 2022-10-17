import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

part 'camera_state.dart';
part 'camera_event.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(const CameraState(cameras: [])) {
    on<CameraInitiated>(_initiatedCamera);
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
}
