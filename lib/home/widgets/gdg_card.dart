import 'package:devfest/app/app.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class GDGCard extends StatelessWidget {
  final GDGModel gdg;
  final int index;
  const GDGCard({super.key, required this.gdg, required this.index});

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
      onTap: () => showCupertinoModalBottomSheet(
          context: context,
          elevation: 0,
          expand: true,
          shadow: const BoxShadow(color: Colors.transparent),
          backgroundColor: Colors.transparent,
          transitionBackgroundColor: Colors.transparent,
          builder: (context) => GDGModal(gdg: gdg)),
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
                  SvgPicture.asset(AppVector.developersLogo,
                      width: 50, height: 50, semanticsLabel: AppString.devfest),
                  Text(
                    gdg.name,
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
