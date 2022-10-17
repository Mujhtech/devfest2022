import 'package:devfest/common/common.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final Function() onPressed;
  final bool loading;
  final String label;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final Widget? icon;
  final double radius;
  final Color backgroundBorderColor;
  final Color foregroundBorderColor;
  const SecondaryButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.foregroundColor = Colors.white,
      this.backgroundColor = Colors.black,
      this.textColor = Colors.black,
      required this.width,
      required this.height,
      this.loading = false,
      this.icon,
      this.radius = 12,
      this.foregroundBorderColor = Colors.black,
      this.backgroundBorderColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (loading) {
          return;
        }
        onPressed();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                    color: backgroundBorderColor,
                    width: 2,
                    style: BorderStyle.solid)),
          ),
          Positioned(
            top: -6,
            left: -6,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: BorderRadius.circular(radius - 2),
                  border: Border.all(
                      color: foregroundBorderColor,
                      width: 2,
                      style: BorderStyle.solid)),
              alignment: Alignment.center,
              child: loading
                  ? const Center(
                      child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )),
                    )
                  : icon != null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon!,
                            const Width5(),
                            Text(label,
                                style: Theme.of(context)
                                    .textTheme
                                    .button!
                                    .copyWith(color: textColor)),
                          ],
                        )
                      : Text(label,
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: textColor)),
            ),
          ),
        ],
      ),
    );
  }
}
