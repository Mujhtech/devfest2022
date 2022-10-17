import 'dart:convert';

enum SyncStatus { publish, unpblish }

class NotesModel {
  String id;
  String userId;
  String note;
  SyncStatus sync;
  DateTime createdAt;
  DateTime updatedAt;
  NotesModel({
    required this.id,
    required this.userId,
    required this.note,
    required this.sync,
    required this.createdAt,
    required this.updatedAt,
  });

  NotesModel copyWith({
    String? id,
    String? userId,
    String? note,
    SyncStatus? sync,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotesModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      note: note ?? this.note,
      sync: sync ?? this.sync,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'note': note,
      'sync': sync.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory NotesModel.fromMap(Map map) {
    return NotesModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      note: map['note'] ?? '',
      sync: SyncStatus.values.firstWhere(
        (action) => action.name == map['sync'],
        orElse: () => SyncStatus.unpblish,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotesModel(id: $id, userId: $userId, note: $note, sync: $sync, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotesModel &&
        other.id == id &&
        other.userId == userId &&
        other.note == note &&
        other.sync == sync &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        note.hashCode ^
        sync.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
