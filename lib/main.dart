import 'package:flutter/material.dart';
import 'package:projeto_victor/telas/home.dart';
import 'package:projeto_victor/telas/favoritos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receitas',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Tela principal
        '/favoritos': (context) => FavoritosScreen(), // Tela de favoritos
      },
    );
  }
}
