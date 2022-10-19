import 'package:bloc/bloc.dart';
import 'package:devfest/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_theme_event.dart';
part 'app_theme_state.dart';

typedef UuidGetter = String Function();

class AppDataBloc extends Bloc<AppThemeEvent, AppDataTheme> {
  AppDataBloc(
      {required HiveService hiveService,
      required SnackBarService snackBarService})
      : _hiveService = hiveService,
        _snackBarService = snackBarService,
        super(const AppDataTheme()) {
    on<AppDataCreated>(_setAppData);
    on<AppThemeChanged>(_setAppTheme);

    on<NoteLayoutChanged>(_setNoteLayout);
  }

  final HiveService _hiveService;
  final SnackBarService _snackBarService;

  Future<void> _setAppData(
    AppDataCreated event,
    Emitter<AppDataTheme> emit,
  ) async {
    try {
      final currentTheme = await _hiveService.getAppData('theme');
      final currentLayout = await _hiveService.getAppData('note_theme_layout');

      ThemeMode themeOption = ThemeMode.values.firstWhere(
        (theme) => theme.name == currentTheme,
        orElse: () => ThemeMode.system,
      );

      NoteDispayLayout layoutOption = NoteDispayLayout.values.firstWhere(
        (value) => value.name == currentLayout,
        orElse: () => NoteDispayLayout.grid,
      );
      return emit(state.copyWith(theme: themeOption, layout: layoutOption));
    } catch (e) {
      //
      //return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  Future<void> _setAppTheme(
    AppThemeChanged event,
    Emitter<AppDataTheme> emit,
  ) async {
    try {
      await _hiveService.setAppData('theme', event.theme.name);
      _snackBarService.displayMessage('App Theme Changed',
          status: Status.success);
      return emit(state.copyWith(theme: event.theme));
    } catch (e) {
      //
      //return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  Future<void> _setNoteLayout(
    NoteLayoutChanged event,
    Emitter<AppDataTheme> emit,
  ) async {
    try {
      await _hiveService.setAppData('note_theme_layout', event.layout.name);
      _snackBarService.displayMessage('Note Display Layout Changed',
          status: Status.success);
      return emit(state.copyWith(layout: event.layout));
    } catch (e) {
      //
      //return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  // bool _isAppThemeChangedEvent(AppThemeEvent e) {
  //   return e is PhotoCharacterDragged || e is PhotoStickerDragged;
  // }

  // bool _isNotDragEvent(PhotoboothEvent e) {
  //   return e is! PhotoCharacterDragged && e is! PhotoStickerDragged;
  // }

  // @override
  // Stream<Transition<AppThemeEvent, AppThemeState>> transformEvents(
  //   Stream<AppThemeEvent> events,
  //   TransitionFunction<AppThemeEvent, AppThemeState> transitionFn,
  // ) {
  //   return Rx.merge([
  //     events.where(_isDragEvent).debounceTime(_debounceDuration),
  //     events.where(_isNotDragEvent),
  //   ]).asyncExpand(transitionFn);
  // }

  @override
  void onEvent(AppThemeEvent event) {
    super.onEvent(event);
    // if (event is AppThemeChanged) {
    //   yield state.copyWith(theme: event.theme);
    // }
  }
}
