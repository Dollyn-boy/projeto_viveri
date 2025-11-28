import 'package:flutter/material.dart';
import '../../../constants/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Função para esperar e navegar
  void _navigateToNextScreen() async {
    // Espera 3 segundos - PODE MUDAR!!!
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Navega para o Onboarding e remove a Splash da pilha (não pode voltar para ela)
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cor de fundo da Splash 
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo 
            SizedBox(
              width: 280, // ajustar tamanho talvez
              height: 271,
              child: Image.asset(
                'assets/images/logo_viveri.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
          
          ],
        ),
      ),
    );
  }
}