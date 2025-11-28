import 'package:flutter/material.dart';
import '../../../../constants/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ocupa a largura toda
      height: 56, // Altura padrão de botões mobile (SEGUNDO O CHAT KKKKK)
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Verde Escuro
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bordas arredondadas
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.amarelo, // Texto amarelo  
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}