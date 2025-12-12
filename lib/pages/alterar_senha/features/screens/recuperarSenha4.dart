import 'package:flutter/material.dart';
import 'package:recuperarsenhas/core/constants/app_colors.dart';
import 'package:recuperarsenhas/core/widgets/viveri_logo.dart';
import 'recuperarSenha5.dart';
import 'package:recuperarsenhas/services/api_service.dart';

class recuperarSenha4 extends StatefulWidget {
  const recuperarSenha4({super.key});

  @override
  State<recuperarSenha4> createState() => _recuperarSenha4State();
}

class _recuperarSenha4State extends State<recuperarSenha4>{
  // Largura máxima para emular o tamanho de um celular
  static const double _kMobileMaxWidth = 428.0; 
  // Controlador para pegar o texto do email
  final TextEditingController _emailController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: k_backgroundColor, 
      
      body: Center( //  Centraliza o conteúdo (Container) na tela
        child: Container(
          //Define a largura máxima, mantendo o conteúdo com tamanho de celular
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
                  const Center(
                    child: Column(
                      children: [
                        ViveriLogo(), 
                        SizedBox(height: 0),

                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.1), // Espaço para baixo

                  // --- Campo de Email ---
                  Padding(
                    padding: const EdgeInsets.only(left:65.0),
                    child: const Text(
                    'Email cadastrado:',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: k_primaryColor,
                    ),
                  ),
                  ),
                  
                  const SizedBox(height: 8),

                  // TextField para o email
                  Padding(
                    padding:const EdgeInsets.only(left: 65.0,right: 65.0),
                    child: Container(
                    decoration: BoxDecoration(
                      color: k_fieldColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: k_primaryColor),
                    ),
                  ),
                 ),
                  
                  
                  const SizedBox(height: 12),

                  // Texto de instrução
                  const Center(
                    child: Text(
                      'Você receberá um código de redefinição por email!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: k_primaryColor,
                        fontFamily: "Roboto"
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 100), 

                  // Botão Enviar 
                  Padding(
                    padding: EdgeInsets.only(left:124,right:124.0), 
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          setState(() => _isLoading = true);
                          
                          final email = _emailController.text.trim();
                          
                          if (email.isNotEmpty) {
                            // Chama o Django
                            bool sucesso = await _apiService.enviarEmailRecuperacao(email);
                            
                            if (sucesso && context.mounted) {
                                // Navega passando o email para a próxima tela
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:(context) => recuperarSenha5(emailUser: email)
                                  ),
                                );
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Email não encontrado ou erro no servidor."))
                              );
                            }
                          }
                          setState(() => _isLoading = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: k_primaryColor, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                          : const Text('Enviar', style: TextStyle(fontSize: 20, color: k_iconTextColor)),
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
}