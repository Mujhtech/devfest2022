import 'package:devfest/app/app.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/models/models.dart';
import 'package:flutter/material.dart';

class StickerSheet extends StatefulWidget {
  const StickerSheet({
    Key? key,
    required this.stickers,
    required this.onStickerSelected,
  }) : super(key: key);

  final Set<Asset> stickers;
  final ValueSetter<Asset> onStickerSelected;

  @override
  State<StickerSheet> createState() => _StickerSheetState();
}

class _StickerSheetState extends State<StickerSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Theme.of(context).iconTheme.color!),
                        borderRadius: BorderRadius.circular(100.0),
                        color: Theme.of(context).backgroundColor),
                    width: 42,
                    height: 42,
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: RoundedBorderOnSomeSidesWidget(
                      borderColor: Theme.of(context).iconTheme.color!,
                      contentBackgroundColor: Theme.of(context).backgroundColor,
                      borderRadius: 30,
                      borderWidth: 2,
                      topLeft: true,
                      topRight: true,
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: GridView.builder(
                        key: const PageStorageKey<String>('sticker_grid'),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 1,
                          mainAxisSpacing: 48,
                          crossAxisSpacing: 24,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 64),
                        itemCount: widget.stickers.length,
                        itemBuilder: (context, index) {
                          final sticker = widget.stickers.elementAt(index);
                          return StickerChoice(
                            asset: sticker,
                            onPressed: () => widget.onStickerSelected(sticker),
                          );
                        },
                      )))
            ],
          ),
        ));
  }
}

class StickerChoice extends StatelessWidget {
  const StickerChoice({
    Key? key,
    required this.asset,
    required this.onPressed,
  }) : super(key: key);

  final Asset asset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset.path,
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool wasSynchronouslyLoaded,
      ) {
        return AppAnimatedCrossFade(
          firstChild: SizedBox.fromSize(
            size: const Size(20, 20),
            child: const AppCircularProgressIndicator(strokeWidth: 2),
          ),
          secondChild: InkWell(
            onTap: onPressed,
            child: child,
          ),
          crossFadeState: frame == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        );
      },
    );
  }
}
