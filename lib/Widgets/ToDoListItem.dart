import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ToDoListModel.dart';

class ToDoListItem extends StatelessWidget {
  final ToDoItem item;

  ToDoListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoListModel>(builder: (context, model, child) {
      final isDone = model.isDone(item);

      return ListTile(
          onTap: () {},
          leading: buildDoneButton(model, item),
          title: Text(item.title,
              style: isDone ? TextStyle(color: Colors.black26) : null),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            buildFavouriteButton(model, item),
            buildRemoveButton(model, item)
          ]));
    });
  }

  Widget buildDoneButton(ToDoListModel model, ToDoItem item) {
    return model.isDone(item)
        ? IconButton(
            icon: Icon(Icons.check_box, color: Colors.green),
            onPressed: () => model.unmarkDone(item))
        : IconButton(
            icon: Icon(Icons.check_box_outline_blank),
            onPressed: () => model.markDone(item));
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
