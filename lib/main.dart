import 'package:flutter/material.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/themes/custom_theme.dart';

void main() => runApp(
      MaterialApp(
        theme: CustomTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
