import 'package:bloc/bloc.dart';
import 'package:devfest/core/services/services.dart';
import 'package:devfest/data/models/notes_model.dart';
import 'package:equatable/equatable.dart';

part 'note_state.dart';
part 'note_event.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(
      {required NoteService noteService,
      required SnackBarService snackBarService})
      : _noteService = noteService,
        _snackBarService = snackBarService,
        super(const NoteState(notes: [])) {
    on<NoteCreated>(_createNote);
    on<NoteRefreshed>(_getAllNotes);
  }

  final NoteService _noteService;
  final SnackBarService _snackBarService;

  Future<void> _getAllNotes(
    NoteRefreshed event,
    Emitter<NoteState> emit,
  ) async {
    try {
      final notes = await _noteService.all();
      return emit(state.copyWith(status: NoteStatus.success, notes: notes));
    } catch (e) {
      //
      return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  Future<void> _createNote(
    NoteCreated event,
    Emitter<NoteState> emit,
  ) async {
    try {
      final notes = await _noteService.update(event.note);
      if (notes) {
        add(const NoteRefreshed());
      }
      _snackBarService.displayMessage('Saved', status: Status.success);
      return emit(state.copyWith(status: NoteStatus.loading));
    } catch (e) {
      //
      return emit(state.copyWith(status: NoteStatus.failure));
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
  void onEvent(NoteEvent event) {
    super.onEvent(event);
    // if (event is AppThemeChanged) {
    //   yield state.copyWith(theme: event.theme);
    // }
  }
}
