import 'package:isar/isar.dart';

///this file is needed to generate isar file
///to create file we need to run: dart run build_runner build
part 'note_model.g.dart';

@Collection()
class NotesModel {
  Id id = Isar.autoIncrement;
  late String text;
}
