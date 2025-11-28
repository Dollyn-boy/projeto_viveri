import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/theme/app_colors.dart';
import 'shared/widgets/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            // Permite rolar se a tela for pequena
            child: ConstrainedBox(
              // o conteúdo tenha no MÍNIMO a altura da tela
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                // Solução do Botão Grande:
                // Cria uma area central de no máximo 400px de largura.
                // No celular ocupa tudo, no PC fica centralizado bunitu.
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 40.0,
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // --- PARTE DE CIMA ---
                      Column(
                        children: [
                          const SizedBox(height: 40), // Espaço no topo
                          Image.asset(
                            'assets/images/logo_viveri.png',
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            "Olá, Bem-vindo!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.title,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Para começar, você deve\ncomeçar uma conta!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: AppColors.textBody,
                            ),
                          ),
                        ],
                      ),

                      // --- PARTE DE BAIXO ---
                      Column(
                        children: [
                          const SizedBox(height: 40), // Margem
                          Wrap(
                            alignment: WrapAlignment
                                .center, // Centraliza o conteúdo se quebrar linha
                            crossAxisAlignment: WrapCrossAlignment
                                .center, // Alinha o texto verticalmente
                            spacing:
                                4, // Espaço entre os textos
                            children: [
                              Text(
                                "Já tem conta?", 
                                style: GoogleFonts.roboto( // Font que tava no Figma
                                  color: AppColors.textBody,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector( // Tornar o texto clicável
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    "Faça login!",
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.title,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          PrimaryButton(
                            text: "Criar uma conta",
                            onPressed: () {
                              Navigator.pushNamed(context, '/cadastro');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
