part of 'note_bloc.dart';

enum NoteStatus { initial, loading, success, failure, sync }

enum NoteSyncStatus { success, failure, sync }

extension NoteStatusX on NoteStatus {
  bool get isLoading => this == NoteStatus.loading;
  bool get isSuccess => this == NoteStatus.success;
  bool get isFailure => this == NoteStatus.failure;
}

extension NoteSyncStatusX on NoteSyncStatus {
  bool get isSyncing => this == NoteSyncStatus.sync;
  bool get isSuccess => this == NoteSyncStatus.success;
  bool get isFailure => this == NoteSyncStatus.failure;
}

class NoteState extends Equatable {
  final NoteStatus status;
  final NoteSyncStatus syncStatus;
  final List<NotesModel>? notes;

  const NoteState({
    this.notes,
    this.syncStatus = NoteSyncStatus.success,
    this.status = NoteStatus.initial,
  });

  @override
  List<Object?> get props => [status, notes, syncStatus];

  NoteState copyWith({
    NoteStatus? status,
    List<NotesModel>? notes,
    NoteSyncStatus? syncStatus,
  }) {
    return NoteState(
        status: status ?? this.status,
        notes: notes ?? this.notes,
        syncStatus: syncStatus ?? this.syncStatus);
  }
}
