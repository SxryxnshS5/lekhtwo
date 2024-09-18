import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  // Get the collection of notes
  final CollectionReference notes = 
      FirebaseFirestore.instance.collection('notes');

  // CREATE: Add a new note
  Future<void> addNote(String note) {
    return notes.add({
      'notes': note, // Key is 'notes' (same as in update)
      'timestamp': Timestamp.now(),
    });
  }

  // READ: Get notes from the database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = 
        notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // UPDATE: Update a note given a document ID
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'notes': newNote, // Correct key to match 'notes' from addNote
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: Delete a note given a document ID
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
