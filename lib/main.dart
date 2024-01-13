import 'package:flutter/material.dart';
import 'package:notes_app_isar_database/Database/isar_database.dart';
import 'package:notes_app_isar_database/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() async {
  ///initialize isar
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => NoteDatabase(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NotesPage(),
    );
  }
}
