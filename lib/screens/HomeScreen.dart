import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notepad/database/notes_db.dart';
import 'package:notepad/model/note.dart';
import 'package:notepad/flutter_staggered_grid_view.dart';
import 'package:notepad/screens/EditNoteScreen.dart';
import 'package:notepad/screens/NoteDetailsScreen.dart';
import 'package:notepad/widget/NoteCardWidget.dart';

class HomeScreen extends StatefulWidget {
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Note Pad",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Designer',
            ),
          ),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(
            height: 10,
            width: 12,
          )
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : notes.isEmpty
                ? Text(
                    'No notes here to Show',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Designer',
                        fontSize: 24),
                  )
                : buildNotes(context),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNoteScreen()),
          );

          refreshNotes();
        },
      ),
    );
  }
  // Widget buildNotes() => StaggeredGridView.countBuilder(
  //       padding: EdgeInsets.all(8),
  //       itemCount: notes.length,
  //       staggeredTileBuilder: (index) => StaggeredTile.fit(2),
  //       crossAxisCount: 4,
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       itemBuilder: (context, index) {
  //         final note = notes[index];

  //         return GestureDetector(
  //           onTap: () async {
  //             await Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => NoteDetailsScreen(noteId: note.id!),
  //             ));

  //             refreshNotes();
  //           },
  //           child: NoteCardWidget(note: note, index: index),
  //         );
  //       },
  //     );
  // ignore: dead_code
  Widget buildNotes(BuildContext context) => MasonryGridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
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
