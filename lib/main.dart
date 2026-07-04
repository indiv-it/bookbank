import 'package:flutter/material.dart';
import 'package:bookbank/Widgets/NavigationBar.dart';
import 'package:bookbank/Theme/app_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
      home: HomePage(),
    );
  }
}
