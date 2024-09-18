import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lekhtwo/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore service
  final FireStoreService fireStoreService = FireStoreService();

  // Text controller
  final TextEditingController textController = TextEditingController();

  // Open a dialog box to add or edit a note
  void openNoteBox(String? docID, {String? currentNoteText}) {
    // if editing, set the current note text to the controller
    if (docID != null && currentNoteText != null) {
      textController.text = currentNoteText;
    } else {
      textController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter your note"),
        ),
        actions: [
          // Button to save
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                // Add new note
                fireStoreService.addNote(textController.text);
              } else {
                // Update the existing note
                fireStoreService.updateNote(docID, textController.text);
              }

              // Clear the text controller
              textController.clear();

              // Close the dialog
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Add" : "Update"), // Change button text dynamically
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lekh (notes)")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(null), // Pass null for new note
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getNotesStream(),
        builder: (context, snapshot) {
          // If we have data, get all the docs
          if (snapshot.hasData) {
            List<DocumentSnapshot> noteList = snapshot.data!.docs;

            // Display as a list
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = noteList[index];
                String docID = document.id;

                // Get note from each doc
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['notes']; // Correct key is 'notes'

                // Display as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: SizedBox(
                    width: 100, // Adjust the width based on the number of icons
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID, currentNoteText: noteText), // Pass docID and current note text to edit
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => fireStoreService.deleteNote(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Text("Error loading notes...");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
