import 'package:flutter/material.dart';

import 'data/score_store.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScoreStore.initialize();
  runApp(const TollywoodQuizApp());
}

class TollywoodQuizApp extends StatelessWidget {
  const TollywoodQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tollywood Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
