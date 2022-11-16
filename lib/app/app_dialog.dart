import 'package:devfest/app/app_color.dart';
import 'package:flutter/material.dart';

/// Displays a dialog above the current contents of the app.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  double? height,
  bool barrierDismissible = true,
}) =>
    showDialog<T>(
      context: context,
      barrierColor: AppColor.transparent,
      barrierDismissible: barrierDismissible,
      builder: (context) => _AppDialog(height: height, child: child),
    );

class _AppDialog extends StatelessWidget {
  const _AppDialog({Key? key, required this.child, this.height})
      : super(key: key);

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 900,
        height: height,
        decoration: BoxDecoration(
          border:
              Border.all(width: 2, color: Theme.of(context).iconTheme.color!),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).backgroundColor,
              Theme.of(context).backgroundColor,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
