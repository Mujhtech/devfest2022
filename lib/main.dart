import 'dart:async';

import 'package:devfest/core/core.dart';
import 'package:devfest/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'notify/notify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Hive.initFlutter();

  final appDataBox = await Hive.openBox(KHiveBoxes.appDataBox.name);
  final noteBox = await Hive.openBox(KHiveBoxes.noteBox.name);

  final hiveService = HiveService(appDataBox: appDataBox, noteBox: noteBox);
  final noteService = NoteService(hiveService: hiveService);
  final snackBarService = SnackBarService();

  unawaited(Future.wait([]));

  runApp(MyApp(
      hiveService: hiveService,
      noteService: noteService,
      snackBarService: snackBarService));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required this.hiveService,
      required this.noteService,
      required this.snackBarService})
      : super(key: key);

  final NoteService noteService;
  final HiveService hiveService;
  final SnackBarService snackBarService;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider.value(value: noteService),
      RepositoryProvider.value(value: hiveService),
      RepositoryProvider.value(value: snackBarService),
    ], child: const App());
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppThemeBloc(),
      child: Builder(builder: (context) {
        return NotifyPage(
          child: MaterialApp(
              title: AppString.appName,
              themeMode: context.watch<AppThemeBloc>().state.theme,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              home: const SplashPage()),
        );
      }),
    );
  }
}
