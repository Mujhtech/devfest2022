import 'dart:io';

import 'package:devfest/app/app_circular_progressbar.dart';
import 'package:devfest/app/app_color.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GDGModal extends StatefulWidget {
  final GDGModel gdg;
  const GDGModal({Key? key, required this.gdg}) : super(key: key);

  @override
  State<GDGModal> createState() => _GDGModalState();
}

class _GDGModalState extends State<GDGModal> {
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };
  bool isLoading = true;

  final UniqueKey _key = UniqueKey();

  init() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    init();
  }

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
                      child: isLoading
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: AppCircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    color: AppColor.primary1,
                                    strokeWidth: 3,
                                  ),
                                ),
                                const Height5(),
                                Text(
                                  'Loading, Please wait...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(fontWeight: FontWeight.w700),
                                )
                              ],
                            )
                          : WebView(
                              key: _key,
                              gestureRecognizers: gestureRecognizers,
                              initialUrl: widget.gdg.url,
                              //javascriptChannels: _monoJavascriptChannel,
                              javascriptMode: JavascriptMode.unrestricted,
                              onPageStarted: (url) {
                                isLoading = false;
                                setState(() {});
                              },
                              onPageFinished: (url) {
                                isLoading = false;
                                setState(() {});
                              },
                            )))
            ],
          ),
        ));
  }
}
