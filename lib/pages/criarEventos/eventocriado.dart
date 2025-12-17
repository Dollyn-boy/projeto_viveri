import 'package:flutter/material.dart';

class EventoCriadoSucesso extends StatelessWidget {
  const EventoCriadoSucesso({super.key});

  @override
  Widget build(BuildContext context) {
    const Color corFundo = Color(0xFFD6E0D2);
    const Color corTextoPrincipal = Color(0xFF284017);
    const Color corDestaque = Color.fromARGB(255, 189, 161, 109);       
    return Scaffold(
      backgroundColor: corFundo,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
       
              Container(
                width: 140, 
                height: 140,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 1, 97, 1), 
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withOpacity(0.9), 
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded, 
                  size: 80,
                  color: corDestaque, 
                ),
              ),
              
              const SizedBox(height: 40),
              
              const Text(
                "Evento criado\ncom sucesso!!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: corTextoPrincipal,
                ),
              ),
              
              const SizedBox(height: 60),

              ElevatedButton(
                onPressed: () {
       
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: corTextoPrincipal,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(
                    color: corDestaque,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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