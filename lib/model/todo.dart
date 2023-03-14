class Todo {
  final int? id;
  final String title;
  final String description;
  final int isFinished;

  Todo(
      {this.id,
      required this.title,
      required this.description,
      required this.isFinished});

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isFinished: json['isFinished']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isFinished': isFinished
    };
  }
}
