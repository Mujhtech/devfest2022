part of 'note_bloc.dart';

enum NoteStatus { initial, loading, success, failure }

extension NoteStatusX on NoteStatus {
  bool get isLoading => this == NoteStatus.loading;
  bool get isSuccess => this == NoteStatus.success;
  bool get isFailure => this == NoteStatus.failure;
}

class NoteState extends Equatable {
  final NoteStatus status;
  final List<NotesModel> notes;

  const NoteState({
    required this.notes,
    this.status = NoteStatus.initial,
  });

  @override
  List<Object> get props => [status, notes];

  NoteState copyWith({
    NoteStatus? status,
    List<NotesModel>? notes,
  }) {
    return NoteState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
