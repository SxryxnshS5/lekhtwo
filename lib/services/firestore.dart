import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {

  // get collection of notes
  final CollectionReference notes = 
  FirebaseFirestore.instance.collection('notes');
  // CREATE: add a new note
  Future<void> addNote(String note){
    return notes.add({
      'notes': note,
      'timestamp': Timestamp.now(),
    });
  }
  // READ: get notes from dataase

  // UPDATE: update notes given a doc id

  // DELETE: delete notes given a doc id
}