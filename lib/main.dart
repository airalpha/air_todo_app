import 'package:air_todo/ui/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      theme: ThemeData.dark(),
      title: "AIR TODO",
      home: Home(),
    );
  }
}
