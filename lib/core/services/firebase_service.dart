import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devfest/data/models/notes_model.dart';

abstract class BaseFirebaseRepository {
  Future<NotesModel?> get({required String noteId});
  Future<List<NotesModel>> getAll({required String userId});
  Future<void> add({required NotesModel item});
  Future<void> remove({required String id});
  Future<void> update({required String id, required Map<String, dynamic> item});
}

class FirebaseRepository implements BaseFirebaseRepository {
  FirebaseRepository({FirebaseFirestore? firebaseFirestoreProvider})
      : _firebaseFirestoreProvider =
            firebaseFirestoreProvider ?? FirebaseFirestore.instance;
  final FirebaseFirestore? _firebaseFirestoreProvider;

  @override
  Future<void> add({required NotesModel item}) async {
    try {
      await _firebaseFirestoreProvider!
          .collection('notes')
          .doc(item.id)
          .set(item.toMap());
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    }
  }

  @override
  Future<NotesModel?> get({required String noteId}) async {
    try {
      final snap = await _firebaseFirestoreProvider!
          .collection('notes')
          .doc(noteId)
          .get();
      final d = snap.data();
      if (d != null) {
        return NotesModel.fromMap(d);
      }
      return null;
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    }
  }

  @override
  Future<List<NotesModel>> getAll({required String userId}) async {
    try {
      List<NotesModel> datas = [];
      final snap = await _firebaseFirestoreProvider!
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      for (var doc in snap.docs) {
        final d = doc.data();

        NotesModel data = NotesModel.fromMap(d);
        datas.add(data);
      }
      return datas;
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    }
  }

  @override
  Future<void> remove({required String id}) async {
    try {
      await _firebaseFirestoreProvider!.collection('notes').doc(id).delete();
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    }
  }

  @override
  Future<void> update(
      {required String id, required Map<String, dynamic> item}) async {
    try {
      await _firebaseFirestoreProvider!
          .collection('notes')
          .doc(id)
          .update({...item, 'updatedAt': DateTime.now()});
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    }
  }
}
