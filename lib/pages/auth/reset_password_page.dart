import 'package:flutter/material.dart';
import 'password_success_page.dart'; // Import direto, pois estão na mesma pasta 'auth'

class ResetPasswordPage extends StatefulWidget {
  // Renomeei para ResetPasswordPage para clareza
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // Cores mantidas do padrão do projeto
  final Color backgroundColor = const Color(0xFFD9E5D6);
  final Color darkGreen = const Color(0xFF2F4838);
  final Color accentYellow = const Color(0xFFF2B656);
  final Color inputFill = const Color(0xFFCCD9C9);
  final Color errorRed = const Color(0xFF7F0002);

  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String? _confirmErrorText;
  bool _showRequirements = false;

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigits = false;
  bool _hasSpecialChars = false;

  void _updatePasswordValidation(String password) {
    setState(() {
      _showRequirements = true;
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigits = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _validateAndReset() {
    setState(() {
      bool isPasswordValid = _hasMinLength &&
          _hasUppercase &&
          _hasLowercase &&
          _hasDigits &&
          _hasSpecialChars;

      if (!isPasswordValid) {
        _showRequirements = true;
        return;
      }

      if (_passController.text != _confirmPassController.text) {
        _confirmErrorText = "As senhas não coincidem!";
        return;
      }

      // Sucesso -> Navega para PasswordSuccessPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasswordSuccessPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_viveri.png', height: 160),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Informe a nova senha:",
                    style: TextStyle(
                        color: darkGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passController,
                onChanged: _updatePasswordValidation,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputFill,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                ),
              ),
              if (_showRequirements) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("A senha deve conter:",
                          style: TextStyle(
                              color: darkGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      _buildRequirement("Mais de 8 caracteres", _hasMinLength),
                      _buildRequirement(
                          "Conter letras maiúsculas", _hasUppercase),
                      _buildRequirement(
                          "Conter letras minúsculas", _hasLowercase),
                      _buildRequirement(
                          "Incluir pelo menos um número", _hasDigits),
                      _buildRequirement(
                          "Incluir pelo menos um caractere especial",
                          _hasSpecialChars),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Confirme a senha:",
                    style: TextStyle(
                        color: darkGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputFill,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: _confirmErrorText != null
                        ? BorderSide(color: errorRed, width: 1)
                        : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: _confirmErrorText != null
                        ? BorderSide(color: errorRed, width: 1)
                        : BorderSide.none,
                  ),
                ),
              ),
              if (_confirmErrorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(_confirmErrorText!,
                      style: TextStyle(color: errorRed, fontSize: 12)),
                ),
              const SizedBox(height: 60),
              SizedBox(
                width: 160,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: accentYellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                  onPressed: _validateAndReset,
                  child: const Text("Redefinir",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isValid ? darkGreen : const Color(0xFF7F0002),
            ),
          ),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: darkGreen, fontSize: 10)),
        ],
      ),
    );
  }
}
