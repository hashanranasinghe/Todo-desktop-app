import 'package:fluent_ui/fluent_ui.dart';
import 'package:todo_desktop/model/todo.dart';

import '../database/database.dart';

class TodoAddViewModel extends ChangeNotifier {
  late int id;
  late String title;
  late String description;
  late int isFinished;

  Future<void> createTodo() async {
    final todo =
        Todo(title: title, description: description, isFinished: isFinished);
    await DatabaseHelper.instance.add(todo);
    notifyListeners();
  }

  Future<void> updateTodo() async {
    final todo = Todo(
        id: id, title: title, description: description, isFinished: isFinished);
    await DatabaseHelper.instance.update(todo);
    notifyListeners();
  }
}
