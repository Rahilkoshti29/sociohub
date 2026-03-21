import 'package:flutter/material.dart';
import 'package:sociohub/home_screen.dart';
import 'package:sociohub/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xffE53935),
      ),
      home: SplashScreen(),
    );
  }
}
