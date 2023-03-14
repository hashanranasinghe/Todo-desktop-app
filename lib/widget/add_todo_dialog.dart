import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:todo_desktop/providers/to_list_view_model.dart';
import 'package:todo_desktop/providers/todo_add_view_model.dart';

import '../model/todo.dart';

class AddToDoDialog extends StatefulWidget {
  final Function? onCreated;
  final Function? onUpdated;
  final Todo? todo;
  const AddToDoDialog({
    Key? key,
    this.onCreated,
    this.onUpdated,
    this.todo,
  }) : super(key: key);

  @override
  State<AddToDoDialog> createState() => _AddToDoDialogState();
}

class _AddToDoDialogState extends State<AddToDoDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isFinished = false;
  int convert = 0;
  late TodoAddViewModel _todoAddViewModel;
  late TodoListViewModel _todoListViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
      convert = widget.todo!.isFinished;
      if (convert == 1) {
        isFinished = true;
      }
    }
    _todoAddViewModel = Provider.of<TodoAddViewModel>(context, listen: false);
    _todoListViewModel = Provider.of<TodoListViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TodoAddViewModel>(context);
    return ContentDialog(
      title: const Text("Create ToDo"),
      content: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBox(
              onChanged: (value) {
                vm.title = value;
              },
              controller: titleController,
              placeholder: "title",
            ),
            const SizedBox(
              height: 10,
            ),
            TextBox(
              onChanged: (value) {
                vm.description = value;
              },
              controller: descriptionController,
              placeholder: "description",
              maxLines: 5,
              minLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            Checkbox(
                content: const Text("Complete"),
                checked: convert == 1 ? true : isFinished,
                onChanged: (value) {
                  setState(() {
                    isFinished = value!;
                    if (isFinished == true) {
                      convert = 1;
                    } else {
                      convert = 0;
                    }
                    vm.isFinished = convert;
                  });
                }),
          ],
        ),
      ),
      actions: [
        TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            }),
        if (widget.todo != null) ...[
          TextButton(
              child: const Text("Update"),
              onPressed: () async {
                await _updateTodo(todoId: widget.todo!.id!.toInt());
                Navigator.pop(context);
              }),
        ] else ...[
          TextButton(
              child: const Text("Create"),
              onPressed: () async {
                await _todoAddViewModel.createTodo();
                await _todoListViewModel.getAllTodos();
                Navigator.pop(context);
              })
        ],
      ],
    );
  }

  _updateTodo({required int todoId}) async {
    setState(() {
      _todoAddViewModel.id = todoId;
      _todoAddViewModel.title = titleController.text;
      _todoAddViewModel.description = descriptionController.text;
      _todoAddViewModel.isFinished = convert;
    });
    await _todoAddViewModel.updateTodo();
    await _todoListViewModel.getAllTodos();
  }
}
