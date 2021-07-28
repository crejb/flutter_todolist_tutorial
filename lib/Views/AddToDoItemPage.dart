import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ToDoListModel.dart';

class AddToDoItemPage extends StatefulWidget {
  @override
  _AddToDoItemPageState createState() => _AddToDoItemPageState();
}

class _AddToDoItemPageState extends State<AddToDoItemPage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ToDoListModel>(context, listen: false);
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
                    model.add(ToDoItem(title: myController.text));
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'))
            ])));
  }
}
