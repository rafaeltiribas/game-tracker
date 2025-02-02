import 'package:flutter/material.dart';
import 'package:game_tracker/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(16, 137, 218, 0)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}