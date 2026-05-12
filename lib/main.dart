import 'package:flutter/material.dart';
import 'pages/input_page.dart';

void main() {
  runApp(const MyApp()); // Pastikan tidak ada kata 'const' di sini
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Modern',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primarySwatch: Colors.blue,
      ),
      // DI SINI KUNCINYA: Mengirimkan parameter yang diwajibkan ke InputPage
      home: InputPage(
        onThemeToggle: _toggleTheme, 
        isDarkMode: _themeMode == ThemeMode.dark
      ),
    );
  }
}