import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';

import 'package:todo/util/dialog_box.dart';
import 'package:todo/util/todolist.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
     
      theme: ThemeData(
        
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 // reference the hive box
  final _myBox = Hive.box('mybox');
   ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

//class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue.shade100,appBar: AppBar(backgroundColor: Colors.green[200],title: Text('TO DO'),centerTitle: true,),
    floatingActionButton: FloatingActionButton(backgroundColor: Colors.green[300],
        onPressed: createNewTask,
        child: Icon(Icons.add),
       ),
    body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
        
      
     );
  }
}




























   
      // floatingActionButton: FloatingActionButton(backgroundColor: Colors.green[300],
      //   onPressed: createNewTask,
      //   child: Icon(Icons.add),
      // )
      // body: ListView.builder(
      //   itemCount: db.toDoList.length,
      //   itemBuilder: (context, index) {
      //     return ToDoTile(
      //       taskName: db.toDoList[index][0],
      //       taskCompleted: db.toDoList[index][1],
      //       onChanged: (value) => checkBoxChanged(value, index),
      //       deleteFunction: (context) => deleteTask(index),
      //     );
      //   },
      // ),



//  title: Text('TO DO',style: TextStyle(color: Colors.white70),),centerTitle: true,
//         elevation: 0,
//       ),
//       floatingActionButton: FloatingActionButton(backgroundColor: Colors.green[300],
//         onPressed: createNewTask,
//         child: Icon(Icons.add),
//       ),
//       body: ListView.builder(
//         itemCount: db.toDoList.length,
//         itemBuilder: (context, index) {
//           return ToDoTile(
//             taskName: db.toDoList[index][0],
//             taskCompleted: db.toDoList[index][1],
//             onChanged: (value) => checkBoxChanged(value, index),
//             deleteFunction: (context) => deleteTask(index),
//           );
//         },
//       ),