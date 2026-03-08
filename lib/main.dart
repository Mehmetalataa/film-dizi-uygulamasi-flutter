import 'package:film_dizi_uygulamasi/views/app_views.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // main.dart içinde
      theme: ThemeData(
        brightness: Brightness.dark, // Genel karanlık mod
        scaffoldBackgroundColor: const Color(0xFF000000), // Tam siyah arka plan
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFE50914), // Netflix Kırmızısı başlık
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        cardColor: const Color(0xFF1A1A1A), // Kartlar için koyu gri
      ),
      home: const AppViews(),
    );
  }
}
