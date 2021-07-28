import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_ui/Widgets/ToDoList.dart';

import '../ToDoListModel.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ToDoListModel(),
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: ToDoList(title: 'My To Do List')));
  }
}
