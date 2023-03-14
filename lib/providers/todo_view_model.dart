import '../model/todo.dart';

class TodoViewModel {
  final Todo todo;

  TodoViewModel({required this.todo});

  int? get id {
    return todo.id;
  }

  String get title {
    return todo.title;
  }

  String get description {
    return todo.description;
  }

  int get isFinished {
    return todo.isFinished;
  }
}
