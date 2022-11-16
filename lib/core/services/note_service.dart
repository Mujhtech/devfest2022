import 'package:devfest/core/core.dart';
import 'package:devfest/data/models/notes_model.dart';

class NoteService implements NoteInterface {
  final HiveService hiveService;
  final FirebaseRepository? _firebaseRepository;

  NoteService({required this.hiveService})
      : _firebaseRepository = FirebaseRepository();

  @override
  Future<List<NotesModel>> all() async {
    try {
      final all = await hiveService.allNote();

      return all;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> create(NotesModel checklist) async {
    try {
      await hiveService.insert(checklist);

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> delete(List<NotesModel> checklists) async {
    try {
      await hiveService.deleteAll(checklists.map((e) => e.id));

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<NotesModel>> sync() async {
    try {
      final all = await hiveService.allUnplishNote();

      await Future.forEach(all, (e) async {
        final note = (e as NotesModel).copyWith(sync: SyncStatus.publish);

        final isNoteAdded = await _firebaseRepository!.get(noteId: note.id);

        if (isNoteAdded != null) {
          await _firebaseRepository!.update(id: note.id, item: note.toMap());
          await hiveService.insert(note);
        } else {
          await _firebaseRepository!.add(item: note);
          await hiveService.insert(note);
        }
      });

      return all;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update(NotesModel note) async {
    try {
      await hiveService.insert(note);

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
