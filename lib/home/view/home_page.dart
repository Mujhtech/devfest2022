import 'package:devfest/app/app.dart';
import 'package:devfest/home/view/camera_page.dart';
import 'package:devfest/home/view/devfest_page.dart';
import 'package:devfest/home/view/note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 1;
  final GlobalKey bottomNavigationKey = GlobalKey();

  final List<Widget> screens = [
    const NotePage(),
    const CameraPage(),
    const DevfestPage()
  ];

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
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavigationKey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 5,
        selectedLabelStyle:
            Theme.of(context).textTheme.headline4!.copyWith(fontSize: 12),
        unselectedLabelStyle:
            Theme.of(context).textTheme.headline4!.copyWith(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        onTap: (int value) {
          _page = value;
          setState(() {});
        },
        iconSize: 18,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        selectedItemColor: Theme.of(context).iconTheme.color,
        unselectedItemColor: Theme.of(context).textTheme.bodyText1!.color,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 2, color: Theme.of(context).iconTheme.color!)),
                  child: Icon(
                    Icons.description,
                    size: 20,
                    color: Theme.of(context).iconTheme.color,
                  )),
              label: 'Notes'),
          BottomNavigationBarItem(
              icon: Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 2, color: Theme.of(context).iconTheme.color!)),
                  child: Icon(
                    Icons.photo_camera,
                    size: 20,
                    color: Theme.of(context).iconTheme.color,
                  )),
              label: 'Snap'),
          BottomNavigationBarItem(
            icon: Container(
              height: 35,
              width: 35,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      width: 2, color: Theme.of(context).iconTheme.color!)),
              child: SvgPicture.asset(
                AppVector.developersLogo,
                width: 20,
                height: 20,
                semanticsLabel: AppString.devfest,
              ),
            ),
            label: AppString.devfest,
          ),
        ],
      ),
    );
  }
}
