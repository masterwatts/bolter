import 'package:bolter_flutter/main_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Bolter());
}

class Bolter extends StatelessWidget {
  const Bolter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bolter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}
