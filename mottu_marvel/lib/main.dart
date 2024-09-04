import 'package:flutter/material.dart';
import 'core/dependencies/setup_dependencies.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mottu Marvel',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Container(),
    );
  }
}
