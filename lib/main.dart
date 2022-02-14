import 'package:flutter/material.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/login_screen.dart';
import 'package:todoapp/screens/new_task_screen.dart';
import 'package:todoapp/themes/custom_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: CustomTheme.lightTheme,
    home: const LoginScreen(),
    routes: {
      '/newTask': (context) => const NewTaskScreen(),
    },
  ));
}
