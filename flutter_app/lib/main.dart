import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/views/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: ChitoseBusApp()));
}

class ChitoseBusApp extends StatelessWidget {
  const ChitoseBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIT シャトルバス',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00FF88),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'monospace',
      ),
      home: const HomeScreen(),
    );
  }
}
