import 'package:flutter/material.dart';
import 'package:notes_app_isar_database/Database/isar_database.dart';
import 'package:notes_app_isar_database/models/note_model.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textConntroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNotes();
  }

  ///create a note
  void createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textConntroller,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context
                        .read<NoteDatabase>()
                        .addNNotes(textConntroller.text.trim());
                    textConntroller.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("add Note"),
                )
              ],
            ));
  }

  /// fetch note
  void fetchNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  /// update note
  void updateNote(NotesModel Note) {
    //pre-fill the current note text
    textConntroller.text = Note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Update Notes'),
              content: TextField(
                controller: textConntroller,
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    context
                        .read<NoteDatabase>()
                        .updateNote(Note.id, textConntroller.text);
                    textConntroller.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Update'),
                )
              ],
            ));
  }

  /// delete note
  void deleteNotes(int id) {
    context.read<NoteDatabase>().deleteNotes(id);
  }

  @override
  Widget build(BuildContext context) {
    ///note database
    final noteDatabase = context.watch<NoteDatabase>();

    //create Notes by list
    List<NotesModel> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Notes app using isar Database!!!!",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: currentNotes.isEmpty
          ? Center(
              child: Text('You need to Add Notes!!!'),
            )
          : ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                ///get notes by index
                final note = currentNotes[index];
                return ListTile(
                  title: Text(
                    '${note.text}',
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: SizedBox(
                    height: 100,
                    width: 100,
                    child: Row(
                      children: [
                        //update
                        IconButton(
                            onPressed: () => updateNote(note),
                            icon: const Icon(Icons.edit)),
                        //delete
                        IconButton(
                            onPressed: () => deleteNotes(note.id),
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(Icons.add),
      ),
    );
  }
}
