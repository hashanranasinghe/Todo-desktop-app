import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:todo_desktop/providers/to_list_view_model.dart';
import 'package:todo_desktop/providers/todo_add_view_model.dart';

import 'package:todo_desktop/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TodoListViewModel()),
    ChangeNotifierProvider(create: (_) => TodoAddViewModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
