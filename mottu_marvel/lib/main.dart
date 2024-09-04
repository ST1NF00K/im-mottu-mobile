import 'package:flutter/material.dart';
import 'app/characters/view/pages/characters_list_page.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CharactersListPage(),
    );
  }
}
