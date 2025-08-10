import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/mbti_result_provider.dart';
import 'utils/theme_config.dart';

void main() {
  runApp(const MBTIApp());
}

class MBTIApp extends StatelessWidget {
  const MBTIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MBTIResultProvider()),
      ],
      child: MaterialApp(
        title: 'MBTI 성격 유형 테스트',
        theme: MBTITheme.lightTheme,
        darkTheme: MBTITheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MBTIAppColors {
  static const Color primary = Color(0xFF9C88FF);
  static const Color primaryLight = Color(0xFFE8E3FF);
  static const Color secondary = Color(0xFF6C63FF);
  static const Color surface = Color(0xFFF8F6FF);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFF9800);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);
}

