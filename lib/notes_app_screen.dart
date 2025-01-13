import 'package:flutter/material.dart';
import 'package:notes_app/add_notes_screen.dart';
import 'package:notes_app/database.dart';
import 'package:notes_app/notes_model.dart';

class NotesAppScreen extends StatefulWidget {
  const NotesAppScreen({super.key});

  @override
  State<NotesAppScreen> createState() => _NotesAppScreenState();
}

class _NotesAppScreenState extends State<NotesAppScreen> {
  List<NotesModel> notesItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    notesItems = await SqfliteDatabase.getDataFromDatabase();

    print(notesItems.length);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
      ),
      body: ListView.builder(
          itemCount: notesItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: ListTile(
                tileColor: Colors.green.shade200,
                title: Text(notesItems[index].title!),
                subtitle: Text(notesItems[index].description!),
                leading: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNoteScreen(
                          model: notesItems[index],
                        ),
                      ),
                    );

                    await SqfliteDatabase.updateDataInDatabase(
                      result,
                      result.time,
                    );

                    notesItems[index] = result;

                    setState(() {});
                  },
                  icon: const Icon(Icons.edit),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await SqfliteDatabase.deleteDataFromDatabase(
                        notesItems[index].time!);

                    notesItems.removeAt(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );

          print('xxxxxxxxxxxx');

          if (result != null) {
            notesItems.add(result);

            await SqfliteDatabase.insertData(result);

            setState(() {});
          }
        },
      ),
    );
  }
}
