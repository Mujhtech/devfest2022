import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_theme_event.dart';
part 'app_theme_state.dart';

typedef UuidGetter = String Function();

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(const AppThemeState()) {
    on<AppThemeChanged>(
        (event, emit) => emit(state.copyWith(theme: event.theme)));
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
