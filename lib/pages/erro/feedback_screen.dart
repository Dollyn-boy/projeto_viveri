// ARQUIVO: lib/feedback_screen.dart

import 'package:flutter/material.dart';

const Color kBackgroundColor = Color(0xFFDCE6DE);
const Color kCardColor = Color(0xFFC5D1CB);
const Color kButtonColor = Color(0xFF2F483D);
const Color kButtonTextColor = Color(0xFFE6A63E);

class FeedbackScreen extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String primaryButtonText;
  final VoidCallback onPrimaryAction;
  final String? secondaryButtonText;   
  final VoidCallback? onSecondaryAction; 

  const FeedbackScreen({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.onPrimaryAction,
    this.secondaryButtonText,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
            decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // Usando o padrão novo do Flutter (substituto do withOpacity)
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // O card fica do tamanho do conteúdo
              children: [
                Icon(
                  icon,
                  size: 100,
                  color: iconColor,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),

                // Lógica para mostrar 1 ou 2 botões
                if (secondaryButtonText != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _CustomButton(
                          text: secondaryButtonText!,
                          onPressed: onSecondaryAction,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _CustomButton(
                          text: primaryButtonText,
                          onPressed: onPrimaryAction,
                        ),
                      ),
                    ],
                  )
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    child: _CustomButton(
                      text: primaryButtonText,
                      onPressed: onPrimaryAction,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Botão Interno Padronizado
class _CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _CustomButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: kButtonTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
//OPÇÃO A
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => FeedbackScreen(
//       icon: Icons.highlight_off_rounded,
//       iconColor: const Color(0xFF8B4513), // Marrom
//       title: "Aconteceu um problema!",
//       description: "texto informativo, informando alguma informação informativa sobre o informe do problema.",
//       primaryButtonText: "Voltar",
//       onPrimaryAction: () {
//         Navigator.pop(context); // Volta para a tela anterior
//       },
//     ),
//   ),
// );

//OPÇÃO B
//Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => FeedbackScreen(
//       icon: Icons.warning_amber_rounded,
//       iconColor: const Color(0xFF8B4513), // Marrom
//       title: "Ocorreu um erro!",
//       description: "Aconteceu alguma coisa e não foi possível finalizar o coiso.",
//       primaryButtonText: "Tentar novamente",
//       onPrimaryAction: () {
//         Navigator.pop(context); // Volta para a tela anterior para o usuário tentar de novo
//       },
//     ),
//   ),
// );

//OPÇÃO C
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => FeedbackScreen(
//       icon: Icons.warning_amber_rounded,
//       iconColor: const Color(0xFFF9A825), // Amarelo
//       title: "Tem certeza?",
//       description: "Caso faça isso, isso e isso vai acontecer, podendo que isso aconteça!",
      
//       // Botão Esquerdo (Cancelar a ação e voltar)
//       secondaryButtonText: "Cancelar",
//       onSecondaryAction: () {
//         Navigator.pop(context); 
//       },

//       // Botão Direito (Confirmar e sair/prosseguir)
//       primaryButtonText: "Continuar",
//       onPrimaryAction: () {
//         // Substitua LoginPage() pela tela que você quer ir
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => LoginPage()), 
//         );
//       },
//     ),
//   ),
// );