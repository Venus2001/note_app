import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapptest/components/drawer.dart';
import 'package:provider/provider.dart';

import '../model/note.dart';
import '../model/note_database.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Create note dialog
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Enter your note...'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                context.read<NoteDatabase>().addNote(textController.text);
                textController.clear();
              }
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Update note dialog
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Edit your note...'),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                context
                    .read<NoteDatabase>()
                    .updateNote(note.id, textController.text);
                textController.clear();
              }
              Navigator.pop(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
        ],
      ),
    );
  }

  // Delete note confirmation dialog
  void deleteNote(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note?'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteDatabase>().deleteNote(id);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    final currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 30),
        child: FloatingActionButton(
          onPressed: createNote,
          child: Icon(Icons.add,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25, top: 20),
                  child: Text(
                    'Notes',
                    style: GoogleFonts.dmSerifText(
                        fontSize: 45,
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
              ],
            ),
            Expanded(
              child: currentNotes.isEmpty
                  ? Center(
                      child: Text(
                        'No notes yet!\nTap the + button to add one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: currentNotes.length,
                      itemBuilder: (context, index) {
                        final note = currentNotes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // margin:
                            //     EdgeInsets.only(left: 12, right: 12, top: 16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(
                                note.text,
                                style: TextStyle(fontSize: 16),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 20),
                                    onPressed: () => updateNote(note),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 20),
                                    onPressed: () => deleteNote(note.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
