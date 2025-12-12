import 'package:flutter/material.dart';
import 'package:viveri/pages/login/login_page.dart';

class LoginError extends StatefulWidget {
  const LoginError({super.key});

  @override
  State<LoginError> createState() => _LoginErrorState();
}

class _LoginErrorState extends State<LoginError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 224, 212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // 1) IMAGEM
              Image.asset(
                "assets/images/palmas.png",
                height: 150,
              ),

              const SizedBox(height: 30),

              // 2) TÍTULO
              const Text(
                "Bem-vinda de volta!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 40, 64, 23),
                ),
              ),

              const SizedBox(height: 15),

              // 3) TEXTO DESCRITIVO
              const Text(
                "Muito bom ter você de volta! Vamos ver qual vai ser seu próximo evento?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 40, 64, 23),
                ),
              ),

              const SizedBox(height: 35),

              // 4) BOTÃO "CONTINUAR"
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 40, 64, 23),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 244, 177, 52),
                      fontWeight: FontWeight.bold,
                    ),
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
