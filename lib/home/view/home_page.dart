import 'dart:ui';

import 'package:devfest/app/app.dart';
import 'package:devfest/home/view/camera_page.dart';
import 'package:devfest/home/view/note_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 1;
  final GlobalKey bottomNavigationKey = GlobalKey();

  final List<Widget> screens = [const CameraPage(), const NotePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: screens[_page],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.transparent,
          child: ClipRRect(
             borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: BottomNavigationBar(
                key: bottomNavigationKey,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedLabelStyle:
                    Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                unselectedLabelStyle:
                    Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                type: BottomNavigationBarType.fixed,
                currentIndex: _page,
                onTap: (int value) {
                  _page = value;
                  setState(() {});
                },
                iconSize: 18,
                backgroundColor: AppColor.primary4.withOpacity(.2),
                selectedItemColor: Theme.of(context).iconTheme.color,
                unselectedItemColor: Theme.of(context).textTheme.bodyText1!.color,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.photo_camera), label: 'Selfies'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.description), label: 'Notes'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
