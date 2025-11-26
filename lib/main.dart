import 'package:flutter/material.dart';
import 'pages/filtro_preco/filtro_preco_page.dart';
import 'pages/alterar_senha/alterar_senha_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AlterarSenhaPage(),
        '/filtro-preco': (context) => const FiltroPrecoPage(),
        '/alterar-senha': (context) => const AlterarSenhaPage(),
      },
    );
  }
}
