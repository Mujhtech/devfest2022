import 'package:cached_network_image/cached_network_image.dart';
import 'package:devfest/app/app.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int index;
  const ProductCard({super.key, required this.product, required this.index});

  Color backgroundColor() {
    if (index % 4 == 0) {
      return AppColor.primary4;
    } else if (index % 3 == 0) {
      return AppColor.primary2;
    } else if (index % 2 == 0) {
      return AppColor.primary3;
    } else {
      return AppColor.primary1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => showCupertinoModalBottomSheet(
      //     context: context,
      //     elevation: 0,
      //     expand: true,
      //     shadow: const BoxShadow(color: Colors.transparent),
      //     backgroundColor: Colors.transparent,
      //     transitionBackgroundColor: Colors.transparent,
      //     builder: (context) => GDGModal(gdg: gdg)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: backgroundColor(),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.black
                        : AppColor.white,
                    width: 2,
                    style: BorderStyle.solid)),
          ),
          Positioned(
            top: -6,
            left: -6,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColor.black,
                      width: 2,
                      style: BorderStyle.solid)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (product.image != null && product.image!.contains('.svg'))
                    SvgPicture.network(
                      product.image!,
                      width: 30,
                      height: 30,
                    )
                  else
                    CachedNetworkImage(
                      imageUrl: product.image!,
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        width: 30,
                        height: 30,
                      ),
                      placeholder: (context, url) => BrokenImage(
                        size: 25,
                        color: backgroundColor(),
                      ),
                      errorWidget: (context, url, error) => BrokenImage(
                        size: 25,
                        color: backgroundColor(),
                      ),
                    ),
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w900, color: AppColor.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
