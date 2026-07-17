import 'package:flutter/material.dart';

// ----- Text Sizes -----
class AppSize {
  static const TextStyle xs = TextStyle(fontSize: 10);
  static const TextStyle s = TextStyle(fontSize: 12);
  static const TextStyle m = TextStyle(fontSize: 14);
  static const TextStyle l = TextStyle(fontSize: 16);
  static const TextStyle xl = TextStyle(fontSize: 20);
}

// ----- Colors -----
class AppColors {
  // App Colors
  static const Color black = Colors.black;
  static const Color green = Color.fromARGB(255, 0, 187, 6);
  static const Color red = Color.fromARGB(255, 255, 0, 0);
  static const Color card = Colors.white;
  static const Color grey = Colors.grey;
  static final Color border = Colors.grey[300]!;
  static final Color background = Colors.grey[100]!;
  static const Color amber = Colors.amber;

  // Group Colors
  static const Color blue = Colors.blue;
  static const Color orange = Colors.orange;
  static const Color purple = Colors.purple;
  static const Color pink = Colors.pink;
}
