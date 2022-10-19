part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class NoteRefreshed extends NoteEvent {
  final bool refresh;
  const NoteRefreshed({this.refresh = false});
}

class NoteCreated extends NoteEvent {
  final NotesModel note;
  const NoteCreated({required this.note});
}

class NoteDeleted extends NoteEvent {
  final NotesModel note;
  const NoteDeleted({required this.note});
}

class NoteUpdated extends NoteEvent {
  const NoteUpdated();
}
