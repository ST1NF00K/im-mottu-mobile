import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/characters/view/pages/characters_list_page.dart';
import 'app/splashscreen/splash_screen.dart';
import 'core/dependencies/setup_dependencies.dart';

import 'core/firebase/crashlytics_service.dart';
import 'firebase_options.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    setupDependencies();
    getIt.get<CrashlyticsService>().initialize();

    runApp(const MyApp());
  }, (error, stack) => getIt.get<CrashlyticsService>().recordError(error, stack));
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
