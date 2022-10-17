import 'package:devfest/app/app_color.dart';
import 'package:devfest/core/core.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final SnackbarModel snackbarModel;
  final void Function() onDismiss;

  const CustomSnackBar({
    Key? key,
    required this.snackbarModel,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: (_) => onDismiss(),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: size.width,
          decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(5)),
              color: snackbarModel.status == Status.success
                  ? AppColor.primary3
                  : AppColor.primary2),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snackbarModel.title != null)
                  Text(snackbarModel.title!,
                      style: Theme.of(context).textTheme.headline1),
                Text(snackbarModel.message,
                    style: Theme.of(context).textTheme.bodyText1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
