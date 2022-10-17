part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class NoteRefreshed extends NoteEvent {
  const NoteRefreshed();
}

class NoteCreated extends NoteEvent {
  final NotesModel note;
  const NoteCreated({required this.note});
}

class NoteUpdated extends NoteEvent {
  const NoteUpdated();
}

class NoteDeleted extends NoteEvent {
  const NoteDeleted();
}
