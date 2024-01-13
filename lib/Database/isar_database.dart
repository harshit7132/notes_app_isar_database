import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app_isar_database/models/note_model.dart';
import 'package:path_provider/path_provider.dart';

/// all isar database CURD  operations

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  ///initilize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NotesModelSchema], directory: dir.path);
  }

  ///list of notes
  final List<NotesModel> currentNotes = [];

  /// create
  Future<void> addNNotes(String textFromUser) async {
    final newNote = NotesModel()..text = textFromUser;

    ///save note to db
    await isar.writeTxn(() => isar.notesModels.put(newNote));

    ///fetch from db
    fetchNotes();
  }

  /// read
  Future<void> fetchNotes() async {
    List<NotesModel> fetchNotes = await isar.notesModels.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
    notifyListeners();
  }

  /// update
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notesModels.get(id);

    //if notes is not null
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notesModels.put(existingNote));
      await fetchNotes();
    }
  }

  /// delete
  Future<void> deleteNotes(int id) async {
    await isar.writeTxn(() => isar.notesModels.delete(id));
    await fetchNotes();
  }
}
