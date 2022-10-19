import 'package:devfest/camera/bloc/camera_bloc.dart';
import 'package:devfest/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _initialStickerScale = 0.25;
const _minStickerScale = 0.05;

class DraggableStickers extends StatelessWidget {
  const DraggableStickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CameraBloc>().state;
    if (state.stickers.isEmpty) return const SizedBox();
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            key: const Key('stickersView_background_gestureDetector'),
            onTap: () {
              context.read<CameraBloc>().add(const CameraTapped());
            },
          ),
        ),
        for (final sticker in state.stickers)
          DraggableResizable(
            key: Key('stickerPage_${sticker.id}_draggableResizable_asset'),
            canTransform: sticker.id == state.selectedAssetId,
            onUpdate: (update) => context
                .read<CameraBloc>()
                .add(CameraStickerDragged(sticker: sticker, update: update)),
            onDelete: () => context
                .read<CameraBloc>()
                .add(const CameraDeleteSelectedStickerTapped()),
            size: sticker.asset.size * _initialStickerScale,
            constraints: sticker.getImageConstraints(),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                sticker.asset.path,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
            ),
          ),
      ],
    );
  }
}

extension on PhotoAsset {
  BoxConstraints getImageConstraints() {
    return BoxConstraints(
      minWidth: asset.size.width * _minStickerScale,
      minHeight: asset.size.height * _minStickerScale,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
    );
  }
}
