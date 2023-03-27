import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepad/database/notes_db.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/screens/EditNoteScreen.dart';
import 'package:notepad/screens/NoteDetailsScreen.dart';
import 'package:notepad/widget/NoteCardWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Center(
            child: Text(
              'Notes',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Designer',
              ),
            ),
          ),
          // actions: [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text(
                      'No Notes',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Designer',
                        fontSize: 24,
                      ),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );

            refreshNotes();
          },
        ),
      );
  Widget buildNotes() => MasonryGridView.count(
        padding: const EdgeInsets.all(4),
        itemCount: notes.length,
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        // gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        // ),
        crossAxisSpacing: 2,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetailsScreen(
                    noteId: note.id!,
                  ),
                ),
              );
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
