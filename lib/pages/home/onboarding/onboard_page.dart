import 'package:flutter/material.dart';
import '../../../constants/theme/app_colors.dart';
import 'widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding_girl.png",
      "title": "Seus eventos favoritos sempre em seu celular",
      "desc": "Eventos Nacionais, streaming, música, teatro e muito mais!",
    },
    {
      "image": "assets/images/onboarding_megaphone.png",
      "title": "Use sua voz e crie seus próprios eventos!",
      "desc": "Publique seus eventos e compartilhe com seus amigos!",
    },
  ];

  // Função para avançar
  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      // Se não for a última, desliza para a próxima
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // SE FOR A ÚLTIMA (Megafone), vai para a tela de Boas-vindas
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          // Detecta o toque em qualquer lugar da tela para avançar
          onTap: _nextPage, 
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: _onboardingData.length,
                  // O physics define como o scroll se comporta
                  itemBuilder: (context, index) => OnboardingContent(
                    image: _onboardingData[index]["image"]!,
                    title: _onboardingData[index]["title"]!,
                    description: _onboardingData[index]["desc"]!,
                  ),
                ),
              ),
              
              // Indicadores (Bolinhas)
              Padding(
                padding: const EdgeInsets.only(bottom: 60), // Espaço maior
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => _buildDot(index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 10, // Ajustei levemente o tamanho
      width: 10,  // Bolinhas redondas (width = height)
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.amarelo : const Color(0xFF333333),
        shape: BoxShape.circle,
      ),
    );
  }
}