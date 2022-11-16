import 'package:devfest/data/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final Box appDataBox;
  final Box noteBox;

  HiveService({
    required this.appDataBox,
    required this.noteBox,
  });

  Future<void> clearAll() async {
    await appDataBox.clear();
    await noteBox.clear();
  }

  Future<void> setAppData(String key, dynamic value) async {
    return appDataBox.put(key, value);
  }

  Future<void> insert(NotesModel note) async {
    return noteBox.put(note.id, note.toMap());
  }

  Future<dynamic> getAppData(String key) {
    return appDataBox.get(key, defaultValue: '');
  }

  Future<void> insertAll(List<NotesModel> notes,
      {bool clearSync = true}) async {
    final Map<dynamic, dynamic> data = {};
    for (var checklist in notes) {
      data[checklist.id] = checklist.toMap();
    }
    await noteBox.clear();
    await noteBox.putAll(data);
    return;
  }

  Future<void> deleteAll(Iterable<String> ids) async {
    return noteBox.deleteAll(ids);
  }

  Future<List<NotesModel>> allNote() async {
    final data = noteBox.values.toList();
    return data.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<List<NotesModel>> allUnplishNote() async {
    final data = noteBox.values.toList();
    final formattedData = data.map((e) => NotesModel.fromMap(e)).toList();

    return formattedData.where((e) => e.sync == SyncStatus.unpblish).toList();
  }
}
