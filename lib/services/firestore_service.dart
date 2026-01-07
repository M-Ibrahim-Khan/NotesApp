import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _userNotesCollection {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    return _db.collection('users').doc(user.uid).collection('notes');
  }

  Future<void> addNote(Note note) async {
    // await _userNotesCollection.add(note.toMap());
    await _userNotesCollection.add({
      'title': note.title,
      'content': note.content,
      'createdAt': note.createdAt,
    });
  }

  Stream<List<Note>> getNotes() {
    return _userNotesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            return Note.fromMap(doc.data(), doc.id);
          }).toList(),
        );
    //   final data = doc.data();   what fromMap does
    //   return Note(
    //     id: doc.id,
    //     title: data['title'] ?? '',
    //     content: data['content'] ?? '',
    //     createdAt: (data['createdAt'] as Timestamp).toDate(),
    //   );
    // }).toList());
  }

  Future<void> deleteNote(String id) async {
    await _userNotesCollection.doc(id).delete();
  }

  Future<void> updateNote(Note note) async {
    await _userNotesCollection.doc(note.id).update(note.toMap());
    // await _userNotesCollection.doc(note.id).update({ what toMap does
    //   'title': note.title,
    //   'content': note.content,
    //   'createdAt': note.createdAt,
    // });
  }
}
