import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the given [url] in a new tab of the host browser
Future<void> openLink(String url, {VoidCallback? onError}) async {
  Uri link = Uri(host: url);
  if (await canLaunchUrl(link)) {
    await launchUrl(link);
  } else if (onError != null) {
    onError();
  }
}
