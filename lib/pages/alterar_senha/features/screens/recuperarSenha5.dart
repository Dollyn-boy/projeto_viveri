import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recuperarsenhas/core/constants/app_colors.dart';
import 'package:recuperarsenhas/core/widgets/viveri_logo.dart';
import 'package:recuperarsenhas/services/api_service.dart';

class recuperarSenha5 extends StatefulWidget {
  final String emailUser;
  const recuperarSenha5({super.key, required this.emailUser});

  @override
  State<recuperarSenha5> createState() => _recuperarSenha5State();
}

class _recuperarSenha5State extends State<recuperarSenha5> {
  // Configurações
  static const double _kMobileMaxWidth = 428.0; // Largura máxima para emular celular
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  // Estado do contador
  int _secondsRemaining = 60; 
  Timer? _timer;
  
  // Controladores para os 5 campos de entrada
  final List<TextEditingController> _codeControllers = 
      List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(5, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // --- Função para mudar o foco automaticamente ---
  void _onCodeChanged(String value, int index) {
    if (value.length == 1 && index < _codeControllers.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Formata os segundos restantes para 'mm:ss'
    String timeString = 
        '00:${_secondsRemaining.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: k_backgroundColor,
      
      body: Center( // Centraliza o Container na tela
        child: Container(
          
          constraints: const BoxConstraints(
            maxWidth: _kMobileMaxWidth,
          ),
          
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Seta de Voltar
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: BackButton(color: k_primaryColor),
                    ),
                  ),

                  // Espaço acima do ícone
                  SizedBox(height: screenHeight * 0.1),

                  //Ícone
                  Center(
                    child: Column(
                      children: [
                        const ViveriLogo(), 
                        const SizedBox(height: 0),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.1), // Espaço

                  Padding(
                    padding: const EdgeInsets.only(left:60),
                    child: const Text(
                    'Informe o código recebido por email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      
                      color: k_primaryColor, 
                    ),
                  ),
                  ),
                  const SizedBox(height: 8),

                  // --- Campos de Entrada do Código (5 dígitos) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _codeControllers.length, 
                      (index) => _buildCodeField(index),
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  // --- Contador de Reenvio ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tentar novamente em: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: k_primaryColor.withOpacity(0.8), 
                          fontFamily: 'Robot'
                        ),
                      ),
                      Text(
                        timeString,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: k_primaryColor, 
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(height: 100),

                  // --- Botão Validar ---
                  Padding(
                    padding: EdgeInsets.only(left:124,right:124.0),
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                             // Junta os 5 dígitos
                             String fullCode = _codeControllers.map((c) => c.text).join();
                             

                             // Validação simples
                             if (fullCode.length != 5) {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preencha os 5 dígitos do código.")));
                               return;
                             }
                             
                             setState(() => _isLoading = true);

                             // Chama API
                             bool sucesso = await _apiService.validarCodigo(
                                widget.emailUser, 
                                fullCode 
                            
                             );

                             setState(() => _isLoading = false);

                             if (sucesso && context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Código Válido!")));
                               // LINKAR COM A NOVA PAG
                               Navigator.of(context).popUntil((route) => route.isFirst);
                             } else if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao validar. Verifique o código.")));
                             }
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: k_iconColor, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading 
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: k_iconTextColor))
                            : const Text('Validar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: k_iconTextColor, fontFamily: "Roboto")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Método para criar um único campo de entrada (Box) ---
  Widget _buildCodeField(int index) {
  
    // Cálculo da largura de cada campo
    final fieldWidth = 60.0; 

    return Container(
      margin: EdgeInsets.only(right: index < _codeControllers.length - 1 ? 4.0 : 0.0),
      width: fieldWidth,
      height: 50,
      decoration: BoxDecoration(
        color: k_fieldColor, 
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          controller: _codeControllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1, // Apenas um caractere por campo
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: k_primaryColor, 
            fontFamily: "Roboto"
          ),
          decoration: const InputDecoration(
            counterText: '', // Remove o contador de caracteres
            border: InputBorder.none,
          ),
          onChanged: (value) => _onCodeChanged(value, index),
        ),
      ),
    );
  }
}