import 'dart:collection';

import 'package:flutter/material.dart';

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

class ToDoItem {
  final String title;
  ToDoItem({required this.title});
}
