import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_ui/Views/AddToDoItemPage.dart';

import '../ToDoListModel.dart';
import 'ToDoListItem.dart';

class ToDoList extends StatefulWidget {
  ToDoList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
                bottom: const TabBar(
                    tabs: [Tab(text: 'All Items'), Tab(text: 'Priority')])),
            body:
                TabBarView(children: [getItemsBody(), getPriorityItemsBody()]),
            floatingActionButton: FloatingActionButton(
                onPressed: openAddItemDialog, child: Icon(Icons.add))));
  }

  Widget getItemsBody() {
    return Consumer<ToDoListModel>(builder: (context, model, child) {
      if (model.itemCount > 0) {
        return Scrollbar(
            isAlwaysShown: false,
            controller: _scrollController,
            child: ListView(
                children: ListTile.divideTiles(
                    context: context,
                    tiles: model.toDoItems
                        .map((item) => ToDoListItem(item: item))).toList()));
      }
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('You haven\'t added any items yet!'));
    });
  }

  Widget getPriorityItemsBody() {
    return Consumer<ToDoListModel>(builder: (context, model, child) {
      return Scrollbar(
          isAlwaysShown: false,
          controller: _scrollController,
          child: ListView(
              children: ListTile.divideTiles(
                  context: context,
                  tiles: model.toDoItems
                      .where((item) => model.isFavourite(item))
                      .map((item) => ToDoListItem(item: item))).toList()));
    });
  }

  void openAddItemDialog() {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => AddToDoItemPage()));
  }
}
