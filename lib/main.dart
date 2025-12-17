import 'package:flutter/material.dart';
import 'package:viveri/pages/criarEventos/descritivo24_page.dart';
import 'package:viveri/pages/criarEventos/descritivo25_page.dart';
import 'package:viveri/pages/criarEventos/descritivo26_page.dart';
import 'package:viveri/pages/criarEventos/descritivo27_page.dart';
import 'package:viveri/pages/criarEventos/descritivo28_page.dart';
import 'package:viveri/pages/criarEventos/eventocriado.dart';
import 'package:viveri/pages/eventosCriados_e_Fav/Eventos_main.dart';
import 'package:viveri/pages/home/home_page.dart';
import 'package:viveri/pages/home/onboarding/onboard_page.dart';
import 'package:viveri/pages/home/splash/splash_page.dart';
import 'pages/createCPF/registration_screen.dart';
import 'pages/filtro_preco/filtro_preco_page.dart';
import 'pages/alterar_senha/alterar_senha_page.dart';
import 'pages/auth/recover_password_page.dart';
import 'pages/auth/password_success_page.dart';
import 'pages/auth/create_account_success_page.dart';
import 'package:viveri/pages/createCNPJ/screens/cadastro_cnpj_screen.dart';
import 'pages/FAQ/criar_pergunta_page.dart';
import 'pages/login/login_page.dart';
import 'package:viveri/pages/eventosCriados_e_Fav/controller/Eventscontroller.dart';
import 'package:provider/provider.dart'; //só por conta do ChangeNotifierProvider

import 'paginasTestes/FaqTestePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppController(),

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viveri',
      theme: ThemeData(
        // Define a cor base do app
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      home: const SplashPage(), // Tela inicial é a Splash

      routes: {
        '/onboarding': (context) =>
            const OnboardingPage(), // Rota para Onboarding
        '/welcome': (context) => const HomePage(), // Rota para a HomePage

        '/login': (context) => const LoginPage(),

        '/cadastro': (context) => const RegistrationScreen(),

        '/filtro-preco': (context) => const FiltroPrecoPage(),
        '/alterar-senha': (context) => const AlterarSenhaPage(),

        '/recuperar-senha': (context) => const RecoverPasswordPage(),
        '/password-success': (context) => const PasswordSuccessPage(),
        '/create-account-success': (context) =>
            const CreateAccountSuccessPage(),

        // EVENTOS
        '/criar-eventos-etapa-1': (context) => Descritivo24Page(),
        '/criar-eventos-etapa-2': (context) => Descritivo25Page(),
        '/criar-eventos-etapa-3': (context) => Descritivo26Page(),
        '/criar-eventos-etapa-4': (context) => Descritivo27Page(),
        '/criar-eventos-etapa-5': (context) => Descritivo28Page(),
        '/criar-eventos-sucesso': (context) => EventoCriadoSucesso(),

        '/eventos-criados': (context) => const MainEventsPage(),
        '/criar-pergunta': (context) => const CriarPerguntaPage(),
        '/cnpj': (context) => const CadastroCnpjScreen(),

        '/testeFaq': (context) => const FaqTestePage(),

        '/faq-user': (context) => const FaqTestePage(),
      },
    );
  }
}
