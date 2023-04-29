import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/main.dart';
class EditNote extends StatelessWidget {
  final String title;
  final String description;
  final int noteKey;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesRef = Hive.box('Notes');
  EditNote({Key? key,required this.noteKey,required this.description,required this.title}) : super(key: key);

  void updateNote(){
    notesRef.put(noteKey, {
      'title' : titleController.text,
      'description' : descriptionController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = title;
    descriptionController.text = description;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if( titleController.text != title || descriptionController.text != description )
            {
              updateNote();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotesScreen()));
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red ,content: Text("There is no change on data")));
            }
        },
        child: const Icon(Icons.edit),
      ),
      appBar: AppBar(title: Text("Edit"),automaticallyImplyLeading: false,elevation: 0,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children:
          [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: UnderlineInputBorder()
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  border: InputBorder.none
              ),
            )
          ],
        ),
      ),
    );
  }
}
