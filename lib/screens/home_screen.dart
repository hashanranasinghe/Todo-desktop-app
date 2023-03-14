import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'package:todo_desktop/database/database.dart';

import 'package:todo_desktop/widget/add_todo_dialog.dart';

import '../model/todo.dart';
import '../providers/to_list_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _populateTodoList();
  }

  _populateTodoList() {
    Provider.of<TodoListViewModel>(context, listen: false).getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TodoListViewModel>(context);
    return NavigationView(
      appBar: _getAppBar(),
      pane: _getNavigationPane(vm),
    );
  }

  _getAppBar() {
    return NavigationAppBar(
        title: const Text(
          "ToDo app",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: Row(
          children: [
            const Spacer(),
            Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                    child: const Text("Create Todo"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return const AddToDoDialog();
                          });
                    })),
            const SizedBox(
              width: 20,
            )
          ],
        ));
  }

  _getNavigationPane(TodoListViewModel vm) {
    return NavigationPane(
        header: const FlutterLogo(
          style: FlutterLogoStyle.horizontal,
          size: 100,
        ),
        onChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selected: selectedIndex,
        items: [
          PaneItem(
              icon: const Icon(FluentIcons.to_do_logo_outline),
              title: const Text("List Todo"),
              body: Center(child: _getToDOList(vm))),
          PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text("Settings"),
              body: const Center(
                child: Text("Settings"),
              )),
        ]);
  }

  _getToDOList(TodoListViewModel vm) {
    switch (vm.status) {
      case Status.loading:
        return Align(
          alignment: Alignment.center,
          child: ProgressRing(),
        );
      case Status.success:
        return ListView.builder(
            itemCount: vm.todos.length,
            itemBuilder: (context, index) {
              final todo = vm.todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: Row(
                  children: [
                    IconButton(
                      icon: Icon(FluentIcons.update_restore),
                      onPressed: () async {
                        Todo getTodo = await DatabaseHelper.instance
                            .getTodoById(todo.id!.toInt());
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AddToDoDialog(todo: getTodo);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(FluentIcons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return ContentDialog(
                              title:
                                  Text('Are you sure you want to delete this?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () async {
                                    await DatabaseHelper.instance
                                        .deleteTodo(todo.id!.toInt());
                                    _populateTodoList();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            });
      case Status.empty:
        return Align(
          alignment: Alignment.center,
          child: Text("No todos found...."),
        );
    }
  }
}
