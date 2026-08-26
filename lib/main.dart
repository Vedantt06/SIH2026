import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const MahaPashuSurakshaApp());
}

class MahaPashuSurakshaApp extends StatelessWidget {
  const MahaPashuSurakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MahaPashu Suraksha',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}