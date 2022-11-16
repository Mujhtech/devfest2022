import 'package:camera/camera.dart';
import 'package:devfest/app/app_color.dart';
import 'package:devfest/camera/bloc/camera_bloc.dart';
import 'package:devfest/core/interface/interface.dart';
import 'package:devfest/extensions/screen.dart';
import 'package:devfest/camera/camera.dart';
import 'package:devfest/preview/preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

T? _ambiguate<T>(T? value) => value;

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CameraView();
    // return BlocProvider(
    //     create: (context) {
    //       return CameraBloc()..add(const CameraInitiated());
    //     },
    //     child: const CameraView());
  }
}

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;

  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  late AnimationController _flashModeControlRowAnimationController;
  late AnimationController _exposureModeControlRowAnimationController;
  late AnimationController _focusModeControlRowAnimationController;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int initialCamera = 0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  init() async {
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    setState(() {});

    final systemCam = context.read<CameraBloc>().state.cameras;

    if (systemCam.isNotEmpty) {
      onNewCameraSelected(systemCam.last);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    controller?.dispose();
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(controller!.description);
    }
  }

  void _logError(String code, String? message) {
    if (message != null) {
      print('Error: $code\nError Message: $message');
    } else {
      print('Error: $code');
    }
  }

  IconData flashModeIcon() {
    if (controller == null || controller?.value.flashMode == FlashMode.off) {
      return Icons.flash_off;
    } else if (controller?.value.flashMode == FlashMode.auto) {
      return Icons.flash_auto;
    } else if (controller?.value.flashMode == FlashMode.always) {
      return Icons.flash_on;
    } else {
      return Icons.highlight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraBloc = context.select((CameraBloc bloc) => bloc.state);

    final orientation = MediaQuery.of(context).orientation;
    final aspectRatio = orientation == Orientation.portrait
        ? CameraAspectRatio.portrait
        : CameraAspectRatio.landscape;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        SizedBox(
            height: context.screenHeight(1),
            child: CameraPreviewWidget(
              decrementPointer: () => _pointers--,
              incrementPointer: () => _pointers++,
              controller: controller,
              handleScaleStart: _handleScaleStart,
              handleScaleUpdate: _handleScaleUpdate,
              onViewFinderTap: (p0, p1) => onViewFinderTap(p0, p1),
            )),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            width: 40,
            height: 350,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CameraToggle(
                    controller: controller,
                    onPressed: () {
                      final cameraLength = cameraBloc.cameras.length;
                      if (initialCamera == (cameraLength - 1)) {
                        initialCamera = 0;
                      } else {
                        initialCamera += 1;
                      }
                      setState(() {});

                      onNewCameraSelected(cameraBloc.cameras[initialCamera]);
                    },
                    cameras: cameraBloc.cameras),
                IconButton(
                    icon: Icon(flashModeIcon()),
                    color: AppColor.white,
                    onPressed: () {
                      if (controller != null) {
                        if (controller!.value.flashMode == FlashMode.off) {
                          onSetFlashModeButtonPressed(FlashMode.torch);
                        } else if (controller!.value.flashMode ==
                            FlashMode.torch) {
                          onSetFlashModeButtonPressed(FlashMode.auto);
                        } else if (controller!.value.flashMode ==
                            FlashMode.auto) {
                          onSetFlashModeButtonPressed(FlashMode.always);
                        } else if (controller!.value.flashMode ==
                            FlashMode.always) {
                          onSetFlashModeButtonPressed(FlashMode.off);
                        }
                      } else {
                        return;
                      }
                    }),
                IconButton(
                  icon: Icon(
                      controller?.value.isCaptureOrientationLocked ?? false
                          ? Icons.screen_lock_rotation
                          : Icons.screen_rotation),
                  color: AppColor.white,
                  onPressed: controller != null
                      ? onCaptureOrientationLockButtonPressed
                      : null,
                ),
                ...!kIsWeb
                    ? <Widget>[
                        IconButton(
                          icon: const Icon(Icons.exposure),
                          color: AppColor.white,
                          onPressed: controller != null
                              ? onExposureModeButtonPressed
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_center_focus),
                          color: AppColor.white,
                          onPressed: controller != null
                              ? onFocusModeButtonPressed
                              : null,
                        )
                      ]
                    : <Widget>[],
                IconButton(
                  onPressed: controller != null
                      ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                      : null,
                  icon: Icon(enableAudio ? Icons.volume_up : Icons.volume_mute),
                ),
                IconButton(
                  onPressed: controller != null
                      ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                      : null,
                  color: AppColor.white,
                  icon: const Icon(Icons.center_focus_strong),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imageFile != null)
                ThumbnailCard(
                  imageFile: imageFile,
                ),
              IconButton(
                  icon: const Icon(Icons.radio_button_unchecked),
                  color: AppColor.white,
                  iconSize: 100,
                  onPressed: () {
                    if (controller != null &&
                        controller!.value.isInitialized &&
                        !controller!.value.isRecordingVideo) {
                      onTakePictureButtonPressed(aspectRatio);
                    }
                  }),
            ],
          ),
        )
      ],
    );
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed(double aspectRatio) {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) {
          context
              .read<CameraBloc>()
              .add(CameraCaptured(aspectRatio: aspectRatio, image: file));
          controller = null;
          controller?.dispose();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PreviewPage()));
          //showInSnackBar('Picture saved to ${file.path}');
        }
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Flash mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Exposure mode set to ${mode.toString().split('.').last}');
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
