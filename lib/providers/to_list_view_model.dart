import 'package:fluent_ui/fluent_ui.dart';
import 'package:todo_desktop/providers/todo_view_model.dart';

import '../database/database.dart';

enum Status { loading, empty, success }

class TodoListViewModel extends ChangeNotifier {
  List<TodoViewModel> todos = <TodoViewModel>[];
  Status status = Status.empty;

  Future<void> getAllTodos() async {
    status = Status.loading;
    final results = await DatabaseHelper.instance.getTodos();
    todos = results.map((todo) => TodoViewModel(todo: todo)).toList();
    status = todos.isEmpty ? Status.empty : Status.success;

    notifyListeners();
  }
}
