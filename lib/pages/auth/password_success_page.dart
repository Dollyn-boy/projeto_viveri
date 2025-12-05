import 'package:flutter/material.dart';

class PasswordSuccessPage extends StatelessWidget {
  const PasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFD9E5D6);
    final Color darkGreen = const Color(0xFF2F4838);
    final Color accentYellow = const Color(0xFFF2B656);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/selo.png',
              height: 170, 
            ),
            
            const SizedBox(height: 40),
            
            const SizedBox(height: 40),

            // --- Texto ---
            Text(
              "Senha alterada\ncom sucesso!",
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
                  Navigator.pushNamed(context, '/create-account-success');
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