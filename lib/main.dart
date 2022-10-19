import 'dart:async';
import 'dart:developer';

import 'package:devfest/camera/bloc/camera_bloc.dart';
import 'package:devfest/core/core.dart';
import 'package:devfest/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'notify/notify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlutterError.onError = (details) {
    log(details.exceptionAsString());
    log(details.stack.toString());
  };
  await Hive.initFlutter();

  // Initiate firebase core
  unawaited(Firebase.initializeApp());

  final appDataBox = await Hive.openBox(KHiveBoxes.appDataBox.name);
  final noteBox = await Hive.openBox(KHiveBoxes.noteBox.name);

  final hiveService = HiveService(appDataBox: appDataBox, noteBox: noteBox);
  final noteService = NoteService(hiveService: hiveService);
  final snackBarService = SnackBarService();

  runZonedGuarded(
    () => runApp(MyApp(
        hiveService: hiveService,
        noteService: noteService,
        snackBarService: snackBarService)),
    (error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
    },
  );
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppDataBloc>(
            create: (BuildContext context) => AppDataBloc(
                  snackBarService: context.read<SnackBarService>(),
                  hiveService: context.read<HiveService>(),
                )..add(const AppDataCreated())),
        BlocProvider<CameraBloc>(create: (BuildContext context) => CameraBloc()..add(const CameraInitiated()))
      ],
      child: Builder(builder: (context) {
        return NotifyPage(
          child: MaterialApp(
              title: AppString.appName,
              themeMode: context.watch<AppDataBloc>().state.theme,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              home: const SplashPage()),
        );
      }),
    );
  }
}
