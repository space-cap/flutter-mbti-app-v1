import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MBTIApp());
}

class MBTIApp extends StatelessWidget {
  const MBTIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MBTI 성격 유형 테스트',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      );
  }
}

