import 'package:devfest/data/models/notes_model.dart';
import 'package:flutter/material.dart';
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

  Future<void> setTheme(ThemeMode themeOption) async {
    return appDataBox.put('theme', themeOption.name);
  }

  Future<void> insert(NotesModel note) async {
    return noteBox.put(note.id, note.toMap());
  }

  Future<void> insertAll(List<NotesModel> checklists,
      {bool clearSync = true}) async {
    final Map<dynamic, dynamic> data = {};
    for (var checklist in checklists) {
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
}
