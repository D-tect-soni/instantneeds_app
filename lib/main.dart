import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const InstantNeedsApp());
}

class InstantNeedsApp extends StatelessWidget {
  const InstantNeedsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InstantNeeds',
      home: const SplashScreen(),
    );
  }
}