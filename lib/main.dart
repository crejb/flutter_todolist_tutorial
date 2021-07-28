import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: ToDoList(title: 'My To Do List'),
    );
  }
}

class ToDoList extends StatefulWidget {
  ToDoList({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<ToDoItem> _toDoItems = [];
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: getBody(),
        floatingActionButton: FloatingActionButton(
            onPressed: openAddItemDialog, child: Icon(Icons.add)));
  }

  Widget getBody() {
    if (_toDoItems.length > 0) {
      return Scrollbar(
          isAlwaysShown: false,
          controller: _scrollController,
          child: ListView(
              children: ListTile.divideTiles(
                  context: context,
                  tiles: _toDoItems.map((item) => ToDoListItem(
                      item: item, onItemChanged: onItemChanged))).toList()));
    }
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('You haven\'t added any items yet!'));
  }

  void openAddItemDialog() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      return AddToDoItemPage(onAddItemCompleted: addItem);
    }));
  }

  void addItem(String title) {
    setState(() {
      final item = ToDoItem(title: title, isDone: false);
      _toDoItems.add(item);
    });
  }

  void onItemChanged(ToDoItem item) {
    setState(() {
      _toDoItems[_toDoItems.indexOf(item)] = item.toggleDone();
    });
  }
}

typedef void ItemAddedCallback(String title);

class AddToDoItemPage extends StatefulWidget {
  final ItemAddedCallback onAddItemCompleted;
  AddToDoItemPage({required this.onAddItemCompleted});

  @override
  _AddToDoItemPageState createState() => _AddToDoItemPageState();
}

class _AddToDoItemPageState extends State<AddToDoItemPage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add New Task')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextField(
                  controller: myController,
                  decoration: const InputDecoration(
                    hintText: 'Enter task name',
                  )),
              ElevatedButton(
                  onPressed: () {
                    this.widget.onAddItemCompleted(myController.text);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'))
            ])));
  }
}

class ToDoItem {
  final String title;
  final bool isDone;
  ToDoItem({required this.title, required this.isDone});

  ToDoItem toggleDone() {
    return ToDoItem(title: this.title, isDone: !this.isDone);
  }
}

typedef void ItemDoneChangedCallback(ToDoItem item);

class ToDoListItem extends StatelessWidget {
  final ToDoItem item;
  final ItemDoneChangedCallback onItemChanged;

  ToDoListItem({required this.item, required this.onItemChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onItemChanged(item);
        },
        leading: item.isDone
            ? Icon(Icons.check_box, color: Colors.green)
            : Icon(Icons.check_box_outline_blank),
        title: Text(item.title,
            style: item.isDone ? TextStyle(color: Colors.black26) : null));
  }
}
