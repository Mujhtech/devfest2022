import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'preview_event.dart';
part 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc() : super(const PreviewState()) {
    on<PreviewDrawerToggled>(_toggle);
  }

  Future<void> _toggle(
    PreviewDrawerToggled event,
    Emitter<PreviewState> emit,
  ) async {
    return emit(state.copyWith(
      isDrawerActive: !state.isDrawerActive,
      shouldDisplayPropsReminder: false,
    ));
  }
}
