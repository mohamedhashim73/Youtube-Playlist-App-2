/*
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    getNotes();
    super.initState();
  }
  final notesReference = Hive.box('Notes');
  int itemsLength = 0 ;
  List<Map<String,dynamic>> data = [];

  void addNote() async {
    await notesReference.add({
      'name' : 'Mohamed Hashim',
      'email' : 'mohamed@gmail.com',
    });
    getNotes();
  }

  void getNotes(){
    data.clear();
    setState(() {
      data = notesReference.keys.map((key){
        final currentItem = notesReference.getAt(key);
        return {
          'key' : key,
          'name' : currentItem['name'],
          'email' : currentItem['email']
        };
      }).toList();
      debugPrint("Length is : ${data.length}");
    });
  }

  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              data[0]['name'].toString(),
            ),
            Text(
              '$itemsLength',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          if( !isOpened )
            {
              globalKey.currentState!.showBottomSheet((context){
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  color: Colors.grey.withOpacity(0.4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      const TextField(
                        decoration: InputDecoration(
                            hintText: "Name",
                            border: UnderlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "Email",
                            border: UnderlineInputBorder()
                        ),
                      ),
                      SizedBox(height: 15,),
                      Align(
                        alignment: Alignment.topRight,
                        child: MaterialButton(
                          onPressed: (){},
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text("Add Note"),
                        ),
                      )
                    ],
                  ),
                );
              }).closed.then((value){
                debugPrint("Closed Automatically");
              });
              setState((){
                isOpened = true;
              });
            }
          else
            {
              Navigator.pop(context);
              setState(() {
                isOpened = false;
              });
            }
        },
        tooltip: 'Increment',
        child: Icon(isOpened ? Icons.clear : Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

 */