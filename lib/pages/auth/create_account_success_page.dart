import 'package:flutter/material.dart';

class CreateAccountSuccessPage extends StatelessWidget {
  const CreateAccountSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cores (Mantenha igual às outras telas)
    final Color backgroundColor = const Color(0xFFD9E5D6);
    final Color darkGreen = const Color(0xFF2F4838);
    final Color accentYellow = const Color(0xFFF2B656);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- SELO (Imagem que você adicionou) ---
            Image.asset(
              'assets/images/selo.png',
              height: 170, 
            ),
            
            const SizedBox(height: 40),

            // --- Texto "Conta Criada" ---
            Text(
              "conta criada\ncom sucesso!!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkGreen,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 60),

            // --- Botão Continuar ---
            SizedBox(
              width: 160,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: accentYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  // Geralmente, ao criar conta, vai para o Login ou para o Welcome
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const Text(
                  "Continuar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}