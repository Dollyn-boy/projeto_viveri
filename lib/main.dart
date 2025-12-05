import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';
import 'package:viveri/pages/eventosCriados_e_Fav/controller/Eventscontroller.dart';

void main() {
  runApp(ChangeNotifierProvider(
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
        '/onboarding': (context) => const OnboardingPage(), // Rota para Onboarding 
        '/welcome': (context) => const HomePage(), // Rota para a HomePage 
        '/login': (context) => const Scaffold(
              body: Center(child: Text("Aqui será o Login")), // por enquanto q nao tem login
        ),
        '/cadastro': (context) => const RegistrationScreen(),


        '/filtro-preco': (context) => const FiltroPrecoPage(),
        '/alterar-senha': (context) => const AlterarSenhaPage(),

        '/recuperar-senha': (context) => const RecoverPasswordPage(),
        '/password-success': (context) => const PasswordSuccessPage(),
        '/create-account-success': (context) => const CreateAccountSuccessPage(),
        
        '/eventos-criados': (context) => const MainEventsPage(),
      },
    );
  }
}
