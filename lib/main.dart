import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/edit_note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool bottomSheetOpened = false;
  final notesRef = Hive.box('Notes');
  List<Map<String,dynamic>> notesData = [];
  bool searchOpened = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> addNote({required String title,required String description}) async {
    await notesRef.add({
      'title' : title,
      'description' : description
    });
    getNotes();
    // call notes from cache
  }

  void deleteNote({required int noteKey}) async {
    await notesRef.delete(noteKey);
    getNotes();
  }

  void getNotes(){
    setState(() {
      notesData = notesRef.keys.map((e){
        final currentNote = notesRef.get(e);
        return {
          'key' : e,
          'title' : currentNote['title'],
          'description' : currentNote['description'],
        };
      }).toList();
    });
    debugPrint("Notes length is : ${notesData.length}");
  }

  List<Map<String,dynamic>> notesFiltered = [];
  void filterNotes({required String input}){
    setState(() {
      notesFiltered = notesData.where((element) => element['title'].toString().toLowerCase().startsWith(input.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          if( bottomSheetOpened == false )
            {
              scaffoldKey.currentState!.showBottomSheet((context){
                return Container(
                  color: Colors.grey.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            hintText: 'Title',
                            border: UnderlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 12,),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Description',
                            border: UnderlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 12,),
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: MaterialButton(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          onPressed: ()
                          {
                            if( titleController.text.isNotEmpty && descriptionController.text.isNotEmpty )
                              {
                                addNote(title: titleController.text, description: descriptionController.text);
                                Navigator.pop(context);
                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor : Colors.red,content: Text("Please, fill Textformfield, try again!")));
                              }
                          },
                          child: Text("Add Note"),
                        ),
                      )
                    ],
                  ),
                );
              }).closed.then((value){
                titleController.clear();
                descriptionController.clear();
                setState(() {
                  bottomSheetOpened = false;
                });
                debugPrint("Closed ......");
              });
              setState(() {
                bottomSheetOpened = true;
              });
            }
          else
            {
              setState(() {
                bottomSheetOpened = false;
              });
              Navigator.pop(context);
            }
        },
        child: Icon(bottomSheetOpened ? Icons.clear : Icons.add),
      ),
      appBar: AppBar(
        title: searchOpened == false ?
        const Text("Notes App") : TextField(
          onChanged: (input)
          {
            filterNotes(input: input);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white)
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: ()
              {
                setState(() {
                  searchOpened = !searchOpened;
                });
              },
              child: Icon(searchOpened == false ? Icons.search : Icons.clear),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
            itemBuilder: (context,index)
            {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Text(notesFiltered.isEmpty ? notesData[index]['title'] : notesFiltered[index]['title'],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text(notesFiltered.isEmpty ? notesData[index]['description'] : notesFiltered[index]['description']),
                    SizedBox(height: 7,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:
                      [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return EditNote(title: notesData[index]['title'],description: notesData[index]['description'],noteKey: notesData[index]['key']);
                            }));
                          },
                          child: Icon(Icons.edit),
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: ()
                          {
                            deleteNote(noteKey: notesData[index]['key']);
                          },
                          child: Icon(Icons.delete,color: Colors.red,),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context,index){
              return SizedBox(height: 12.5,);
            },
            itemCount: notesFiltered.isEmpty ? notesData.length : notesFiltered.length
        ),
      )
    );
  }
}

