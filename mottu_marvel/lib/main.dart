import 'package:flutter/material.dart';
import 'app/characters/view/pages/characters_list_page.dart';
import 'app/splashscreen/splash_screen.dart';
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
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/home': (_) => const CharactersListPage(),
      },
    );
  }
}
