import 'package:devfest/extensions/screen.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onPressed;
  final bool loading;
  final String label;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color textColor;
  final double? width;
  final Widget? icon;
  final double radius;
  final Color backgroundBorderColor;
  final Color foregroundBorderColor;
  const PrimaryButton(
      {Key? key,
      required this.onPressed,
      required this.label,
      this.foregroundColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.white,
      this.width,
      this.loading = false,
      this.icon,
      this.radius = 10,
      this.foregroundBorderColor = Colors.white,
      this.backgroundBorderColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: MaterialButton(
        hoverElevation: 0,
        elevation: 0,
        onPressed: () {
          if (loading) {
            return;
          }
          onPressed();
        },
        color: foregroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: foregroundBorderColor,
              width: 2,
            )),
        child: Container(
          width: width ?? context.screenWidth(1),
          height: 56,
          alignment: Alignment.center,
          child: loading
              ? const Center(
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )),
                )
              : icon != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(label,
                            style: Theme.of(context)
                                .textTheme
                                .button!
                                .copyWith(color: textColor)),
                        const SizedBox(
                          width: 10,
                        ),
                        icon!
                      ],
                    )
                  : Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: textColor)),
        ),
      ),
    );
  }
}
