import 'package:flutter/material.dart';
import 'package:hive_app/boxes/boxes.dart';
import 'package:hive_app/models/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final title = TextEditingController();
  final descp = TextEditingController();
  NotesModel? editingNote;

  void deleteEntry(NotesModel notesModel) async {
    await notesModel.delete();
  }

  void editEntry(NotesModel notesModel) {
    editingNote = notesModel;
    title.text = notesModel.title;
    descp.text = notesModel.descp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Notes app using hive',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          final data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data[index].title),
                        const SizedBox(height: 3),
                        Text(data[index].descp),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => editEntry(data[index]),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => deleteEntry(data[index]),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descp,
              decoration: const InputDecoration(hintText: 'Descp'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                final box = Boxes.getData();

                if (editingNote != null) {
                  editingNote!.title = title.text;
                  editingNote!.descp = descp.text;
                  editingNote!.save();
                  editingNote = null;
                } else {
                  final data = NotesModel(title: title.text, descp: descp.text);
                  box.add(data);
                }

                title.clear();
                descp.clear();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)),
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
