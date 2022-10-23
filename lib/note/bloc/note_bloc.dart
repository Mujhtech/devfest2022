import 'dart:developer';

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
        super(const NoteState()) {
    on<NoteCreated>(_createNote);
    on<NoteRefreshed>(_getAllNotes);
    on<NoteSync>(_syncNotes);
    on<NoteDeleted>(_deleteNote);
  }

  final NoteService _noteService;
  final SnackBarService _snackBarService;

  Future<void> _syncNotes(
    NoteSync event,
    Emitter<NoteState> emit,
  ) async {
    try {
      emit(state.copyWith(syncStatus: NoteSyncStatus.sync));
      await _noteService.sync();
      emit(state.copyWith(syncStatus: NoteSyncStatus.success));
      _snackBarService.displayMessage('Sync successful',
          status: Status.success);
    } catch (e) {
      //
      log(e.toString());
      emit(state.copyWith(syncStatus: NoteSyncStatus.failure));
      _snackBarService.displayMessage('Sync failed', status: Status.failed);
      //return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  Future<void> _getAllNotes(
    NoteRefreshed event,
    Emitter<NoteState> emit,
  ) async {
    try {
      if (event.refresh || state.notes == null) {
        final notes = await _noteService.all();
        return emit(state.copyWith(status: NoteStatus.success, notes: notes));
      }
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
        add(const NoteRefreshed(refresh: true));
      }
      _snackBarService.displayMessage('Saved', status: Status.success);
    } catch (e) {
      //
      return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  Future<void> _deleteNote(
    NoteDeleted event,
    Emitter<NoteState> emit,
  ) async {
    try {
      final notes = await _noteService.delete([event.note]);
      if (notes) {
        add(const NoteRefreshed());
      }
      _snackBarService.displayMessage('Note Deleted', status: Status.success);
    } catch (e) {
      //
      return emit(state.copyWith(status: NoteStatus.failure));
    }
  }

  @override
  void onEvent(NoteEvent event) {
    super.onEvent(event);
    // if (event is AppThemeChanged) {
    //   yield state.copyWith(theme: event.theme);
    // }
  }
}
