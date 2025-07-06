import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  CollectionReference getNoteCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  Future<List<NoteModel>> fetchNotes(String userId) async {
    final snapshot = await getNoteCollection(userId).get();
    return snapshot.docs
        .map((doc) => NoteModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addNote(String userId, String text) async {
    await getNoteCollection(userId).add({'text': text});
  }

  Future<void> updateNote(String userId, String noteId, String text) async {
    await getNoteCollection(userId).doc(noteId).update({'text': text});
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await getNoteCollection(userId).doc(noteId).delete();
  }
}