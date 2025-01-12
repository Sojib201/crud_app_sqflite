import 'package:flutter/material.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/notes_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqfliteDatabase.initialiseDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotesAppScreen(),
    );
  }
}
