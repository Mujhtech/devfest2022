import 'package:devfest/core/core.dart';
import 'package:devfest/data/models/notes_model.dart';

class NoteService implements NoteInterface {
  final HiveService hiveService;

  NoteService({required this.hiveService});

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
      final all = await hiveService.allNote();

      return all;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update(NotesModel checklist) async {
    try {
      await hiveService.insert(checklist);

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
