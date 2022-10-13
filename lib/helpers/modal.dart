import 'package:devfest/app/app.dart';
import 'package:devfest/platform/platform.dart';
import 'package:flutter/material.dart';

/// Show a modal as bottom sheet when mobile or portrait. Else displays a dialog
Future<T?> showAppModal<T>({
  required BuildContext context,
  required Widget portraitChild,
  required Widget landscapeChild,
  PlatformHelper? platformHelper,
}) {
  platformHelper = platformHelper ?? PlatformHelper();
  final orientation = MediaQuery.of(context).orientation;

  if (platformHelper.isMobile || orientation == Orientation.portrait) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => portraitChild,
    );
  } else {
    return showAppDialog(
      context: context,
      child: landscapeChild,
    );
  }
}
