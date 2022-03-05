import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/providers/user_provider.dart';
import 'package:todoapp/screens/category_tasks_screen.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/screens/new_category_screen.dart';
import 'package:todoapp/screens/new_task_screen.dart';
import 'package:todoapp/screens/register_screen.dart';
import 'package:todoapp/screens/view_task_screen.dart';
import 'package:todoapp/themes/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CategoryProvider(),
        ),
        // ChangeNotifierProxyProvider<TaskProvider, CategoryProvider>(
        //   update: (ctx, taskProvider, previousCategory) =>
        //       CategoryProvider(taskProvider.tasks),
        //   create: (_) => CategoryProvider([]),
        // ),
        ChangeNotifierProxyProvider<CategoryProvider, TaskProvider>(
          update: (ctx, categoryProvider, previousTask) =>
              TaskProvider(categoryProvider.categories),
          create: (_) => TaskProvider([]),
        ),

        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: CustomTheme.lightTheme,
        home: const LoginScreen(),
        routes: {
          '/homeScreen': (context) => HomeScreen(),
          '/newTask': (context) => const NewTaskScreen(),
          '/newCategory': (context) => const NewCategoryScreen(),
          '/viewTask': (context) => const ViewTaskScreen(),
          '/loginScreen': (context) => const LoginScreen(),
          '/registerScreen': (context) => const RegisterUserScreen(),
          '/categoryTasksScreen': (context) => const CategoryTasksScreen(),
        },
      ),
    ),
  );
}
