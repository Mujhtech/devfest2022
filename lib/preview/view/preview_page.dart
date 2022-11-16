import 'dart:io';

import 'package:devfest/app/app.dart';
import 'package:devfest/camera/bloc/camera_bloc.dart';
import 'package:devfest/common/widgets/secondary_button.dart';
import 'package:devfest/core/core.dart';
import 'package:devfest/extensions/extensions.dart';
import 'package:devfest/preview/preview.dart';
import 'package:devfest/preview/widgets/draggable_stickers.dart';
import 'package:devfest/preview/widgets/sticker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PreviewBloc(photosRepository: context.read<PhotosRepository>()),
      child: const PreviewView(),
    );
  }
}

class PreviewView extends StatefulWidget {
  const PreviewView({super.key});

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CameraBloc>().state;
    final image = state.image;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: AppColor.black,
        //systemNavigationBarColor: Theme.of(context).canvasColor,
        statusBarIconBrightness: Theme.of(context).brightness,
        //systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: context.screenHeight(0.89),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (image != null)
                        Image.file(
                          File(image.path),
                          filterQuality: FilterQuality.high,
                          isAntiAlias: true,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              '$error, $stackTrace',
                              key: const Key('previewImage_errorText'),
                            );
                          },
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                          width: 40,
                          height: 100,
                          decoration: BoxDecoration(
                              color: AppColor.primary1.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.sticky_note_2),
                                  color: AppColor.white,
                                  iconSize: 20,
                                  onPressed: () {
                                    showCupertinoModalBottomSheet(
                                        context: context,
                                        elevation: 0,
                                        expand: true,
                                        shadow: const BoxShadow(
                                            color: Colors.transparent),
                                        backgroundColor: Colors.transparent,
                                        transitionBackgroundColor:
                                            Colors.transparent,
                                        builder: (context) => StickerSheet(
                                              stickers: AppAsset.stickers,
                                              onStickerSelected: (value) {
                                                context.read<CameraBloc>().add(
                                                    CameraStickerTapped(
                                                        sticker: value));
                                                Navigator.of(context).pop();
                                              },
                                            ));
                                  }),
                              IconButton(
                                  icon: const Icon(Icons.text_fields),
                                  color: AppColor.white,
                                  iconSize: 20,
                                  onPressed: () {}),
                            ],
                          ),
                        ),
                      ),
                      const DraggableStickers()
                    ],
                  ),
                ),
                Container(
                  height: 60.4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: AppColor.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SecondaryButton(
                          onPressed: () {
                            context.read<PreviewBloc>().add(PreviewShared(
                                assets: state.stickers,
                                aspectRatio: state.aspectRatio!,
                                image: state.image!,
                                imageId: state.imageId,
                                isSharingEnabled: true));
                          },
                          foregroundColor: AppColor.primary3,
                          foregroundBorderColor: AppColor.white,
                          backgroundBorderColor: AppColor.primary1,
                          label: 'Share',
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                            color: AppColor.white,
                          ),
                          textColor: AppColor.white,
                          width: 100,
                          height: 40),
                      SecondaryButton(
                          onPressed: () {
                            context.read<PreviewBloc>().add(PreviewSaved(
                                assets: state.stickers,
                                aspectRatio: state.aspectRatio!,
                                image: state.image!,
                                imageId: state.imageId,
                                isSaveEnabled: true));
                          },
                          icon: const Icon(
                            Icons.save_alt,
                            size: 20,
                            color: AppColor.white,
                          ),
                          textColor: AppColor.white,
                          foregroundColor: AppColor.primary1,
                          foregroundBorderColor: AppColor.white,
                          backgroundBorderColor: AppColor.primary3,
                          label: 'Save',
                          width: 100,
                          height: 40)
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
