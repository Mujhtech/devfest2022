import 'package:devfest/data/models/notes_model.dart';

abstract class NoteInterface {
  Future<List<NotesModel>> all();
  Future<List<NotesModel>> sync();
  Future<bool> create(NotesModel checklist);
  Future<bool> update(NotesModel checklist);
  Future<bool> delete(List<NotesModel> checklists);
}
