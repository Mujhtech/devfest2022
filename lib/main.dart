import 'dart:async';
import 'dart:developer';

import 'package:devfest/auth/bloc/auth_bloc.dart';
import 'package:devfest/camera/bloc/camera_bloc.dart';
import 'package:devfest/core/core.dart';
import 'package:devfest/core/services/auth_service.dart';
import 'package:devfest/note/note.dart';
import 'package:devfest/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  await Firebase.initializeApp();

  final appDataBox = await Hive.openBox(KHiveBoxes.appDataBox.name);
  final noteBox = await Hive.openBox(KHiveBoxes.noteBox.name);

  final hiveService = HiveService(appDataBox: appDataBox, noteBox: noteBox);
  final noteService = NoteService(hiveService: hiveService);
  final snackBarService = SnackBarService();
  final authenticationRepository = AuthenticationRepository();
  final firebaseStorage = FirebaseStorage.instance;
  final photoRepository = PhotosRepository(firebaseStorage: firebaseStorage);

  runZonedGuarded(
    () => runApp(MyApp(
        hiveService: hiveService,
        noteService: noteService,
        snackBarService: snackBarService,
        authenticationRepository: authenticationRepository,
        photoRepository: photoRepository)),
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
      required this.snackBarService,
      required this.photoRepository,
      required this.authenticationRepository})
      : super(key: key);

  final NoteService noteService;
  final HiveService hiveService;
  final SnackBarService snackBarService;
  final AuthenticationRepository authenticationRepository;
  final PhotosRepository photoRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider.value(value: noteService),
      RepositoryProvider.value(value: hiveService),
      RepositoryProvider.value(value: snackBarService),
      RepositoryProvider.value(value: authenticationRepository),
      RepositoryProvider.value(value: photoRepository)
    ], child: const App());
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteBloc>(
            create: (BuildContext context) => NoteBloc(
                noteService: context.read<NoteService>(),
                snackBarService: context.read<SnackBarService>())
              ..add(const NoteRefreshed())),
        BlocProvider<AppDataBloc>(
            create: (BuildContext context) => AppDataBloc(
                  snackBarService: context.read<SnackBarService>(),
                  hiveService: context.read<HiveService>(),
                )..add(const AppDataCreated())),
        BlocProvider<CameraBloc>(
            create: (BuildContext context) =>
                CameraBloc()..add(const CameraInitiated())),
        BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>()))
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
