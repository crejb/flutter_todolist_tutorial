import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

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
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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

class ToDoItem {
  final String title;
  ToDoItem({required this.title});
}

class ToDoListItem extends StatelessWidget {
  final ToDoItem item;

  ToDoListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoListModel>(builder: (context, model, child) {
      final isDone = model.isDone(item);
      final isFavourite = model.isFavourite(item);

      var toggleDone = () {
        if (isDone) {
          model.unmarkDone(item);
        } else {
          model.markDone(item);
        }
      };

      var toggleFavourite = () {
        if (isFavourite) {
          model.unmarkFavourite(item);
        } else {
          model.markFavourite(item);
        }
      };

      var removeItem = () {
        model.remove(item);
      };

      return ListTile(
          onTap: () {},
          leading: isDone
              ? IconButton(
                  icon: Icon(Icons.check_box, color: Colors.green),
                  onPressed: toggleDone)
              : IconButton(
                  icon: Icon(Icons.check_box_outline_blank),
                  onPressed: toggleDone),
          title: Text(item.title,
              style: isDone ? TextStyle(color: Colors.black26) : null),
          //trailing: buildFavouriteButton(model, item));
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            buildFavouriteButton(model, item),
            buildRemoveButton(model, item)
          ]));
      // trailing: Row(children: [
      //   isFavourite
      //       ? IconButton(
      //           icon: Icon(Icons.favorite, color: Colors.red),
      //           onPressed: toggleFavourite)
      //       : IconButton(
      //           icon: Icon(Icons.favorite_outline),
      //           onPressed: toggleFavourite),
      //   IconButton(icon: Icon(Icons.remove_circle), onPressed: removeItem)
      // ]));
    });
  }

  Widget buildFavouriteButton(ToDoListModel model, ToDoItem item) {
    return model.isFavourite(item)
        ? IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () => model.unmarkFavourite(item))
        : IconButton(
            icon: Icon(Icons.favorite_outline),
            onPressed: () => model.markFavourite(item));
  }

  Widget buildRemoveButton(ToDoListModel model, ToDoItem item) {
    return IconButton(
        icon: Icon(Icons.remove_circle), onPressed: () => model.remove(item));
  }
}

class ToDoListModel extends ChangeNotifier {
  final List<ToDoItem> _toDoItems = [];
  final Set<ToDoItem> _completedItems = {};
  final Set<ToDoItem> _favouriteItems = {};

  UnmodifiableListView<ToDoItem> get toDoItems =>
      UnmodifiableListView(_toDoItems);

  int get itemCount => _toDoItems.length;

  void add(ToDoItem item) {
    _toDoItems.add(item);
    notifyListeners();
  }

  void remove(ToDoItem item) {
    if (_toDoItems.remove(item)) {
      _completedItems.remove(item);
      _favouriteItems.remove(item);
      notifyListeners();
    }
  }

  void markDone(ToDoItem item) {
    if (_completedItems.add(item)) {
      notifyListeners();
    }
  }

  void unmarkDone(ToDoItem item) {
    if (_completedItems.remove(item)) {
      notifyListeners();
    }
  }

  bool isDone(ToDoItem item) {
    return _completedItems.contains(item);
  }

  bool isFavourite(ToDoItem item) {
    return _favouriteItems.contains(item);
  }

  void markFavourite(ToDoItem item) {
    if (_favouriteItems.add(item)) {
      notifyListeners();
    }
  }

  void unmarkFavourite(ToDoItem item) {
    if (_favouriteItems.remove(item)) {
      notifyListeners();
    }
  }
}
