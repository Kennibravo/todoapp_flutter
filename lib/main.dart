import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/screens/new_category_screen.dart';
import 'package:todoapp/screens/new_task_screen.dart';
import 'package:todoapp/themes/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider.value(
      value: CategoryProvider(),
      child: MaterialApp(
        theme: CustomTheme.lightTheme,
        home: const LoginScreen(),
        routes: {
          '/newTask': (context) => const NewTaskScreen(),
          '/newCategory': (context) => const NewCategoryScreen(),
        },
      ),
    ),
  );
}
