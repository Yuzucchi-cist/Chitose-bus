import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presentation/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ChitoseBusApp()));
}

class ChitoseBusApp extends StatelessWidget {
  const ChitoseBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIST シャトルバス',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00FF88),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        // google_fonts で Noto Sans JP をバンドルし、システムフォントに依存せず
        // Linux 環境でも日本語を正しく表示する。
        textTheme: GoogleFonts.notoSansJpTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
