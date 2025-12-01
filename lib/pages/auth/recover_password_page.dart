import 'package:flutter/material.dart';

class RecoverPasswordPage extends StatelessWidget {
  const RecoverPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFFD9E5D6);
    final Color darkGreen = const Color(0xFF2F4838);
    final Color accentYellow = const Color(0xFFF2B656);
  

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_viveri.png',
                height: 160, 
              ),
              const SizedBox(height: 40), 
              // --- Título ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email cadastrado:",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // --- Campo de Texto ---
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFCCD9C9), 
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  
                  // Borda Vermelha (Simulando o erro visualmente)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 8), // Espacinho entre a caixa e o erro

              // --- Texto de Erro Centralizado ---
              const Center(
                child: Text(
                  "Email não encontrado!",
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 60),

              // --- Botão Enviar ---
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
                    
                    Navigator.pushNamed(context, '/password-success');
                  },
                  child: const Text(
                    "Enviar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}