// registration_screen.dart

import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Cores extraídas da imagem
  final Color bgLightGreen = const Color(0xFFD6E2D5);
  final Color inputFillColor = const Color(0xFFC6D5C6);
  final Color buttonColor = const Color(0xFF35483D);
  final Color yellowAccent = const Color(0xFFFFBC2F);
  final Color errorColor = const Color(0xFFA83232);
  final Color labelColor = const Color(0xFF1F2923);

  // Controladores e Estados
  bool isCpfSelected = true;
  bool obscurePassword = true;
  bool termsAccepted = false;
  String? genderValue;

  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto
  final TextEditingController _docController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Foco para exibir regras de senha
  final FocusNode _passFocus = FocusNode();
  bool _showPassRules = false;

  @override
  void initState() {
    super.initState();
    _passFocus.addListener(() {
      setState(() {
        _showPassRules = _passFocus.hasFocus || _passController.text.isNotEmpty;
      });
    });
    
    // Listener para atualizar as regras da senha em tempo real
    _passController.addListener(() {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _docController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  // Lógica simples de validação de senha
  bool get has8Chars => _passController.text.length >= 8;
  bool get hasUpper => _passController.text.contains(RegExp(r'[A-Z]'));
  bool get hasLower => _passController.text.contains(RegExp(r'[a-z]'));
  bool get hasDigit => _passController.text.contains(RegExp(r'[0-9]'));
  bool get hasSpecial => _passController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLightGreen,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // --- CABEÇALHO (Avatar e Toggle) ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- AQUI ESTÁ A ALTERAÇÃO DA IMAGEM ---
                    Stack(
                      children: [
                        Container(
                          width: 110, // Aumentei um pouco para 110
                          height: 110,
                          decoration: BoxDecoration(
                            color: yellowAccent, // Cor de fundo caso a imagem tenha transparência
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black87, width: 2), // Borda preta
                            image: const DecorationImage(
                              // Carrega a imagem do seu asset
                              // Nota: Certifique-se de que 'assets/images/pinto.png' está configurado no pubspec.yaml
                              image: AssetImage('assets/images/pinto.png'), 
                              fit: BoxFit.cover, // Preenche o círculo
                            ),
                          ),
                        ),
                        // Ícone da seta (Upload)
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF35483D),
                              shape: BoxShape.circle,
                              border: Border.all(color: bgLightGreen, width: 2), // Borda clarinha para separar
                            ),
                            child: const Icon(Icons.arrow_upward, color: Colors.yellow, size: 16),
                          ),
                        )
                      ],
                    ),
                    // ----------------------------------------
                    
                    const SizedBox(width: 20),
                    // Toggle CPF/CNPJ
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2F3E33),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildToggleButton("CPF", true),
                                _buildToggleButton("CNPJ", false),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Campo Documento
                            SizedBox(
                            width: 180, // Largura fixa para alinhar com o design
                            child: _buildTextField(
                              controller: _docController, 
                              hint: "", 
                              // Simula o erro "Documento Inválido" da imagem
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Documento Inválido!";
                                return null;
                              },
                              isSmall: true
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                
                const SizedBox(height: 20),

                // --- NOME E SOBRENOME ---
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Nome:"),
                          _buildTextField(controller: _nameController, hint: ""),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("sobrenome:"),
                          _buildTextField(controller: _surnameController, hint: ""),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // --- EMAIL ---
                _buildLabel("Email:"),
                _buildTextField(
                  controller: _emailController, 
                  hint: "",
                  // Simula o erro "Email já cadastrado" se digitar "erro"
                  validator: (value) {
                    if (value != null && value.contains("erro")) return "Email já cadastrado!";
                    return null;
                  }
                ),

                const SizedBox(height: 15),

                // --- SENHA ---
                _buildLabel("Senha:"),
                _buildTextField(
                  controller: _passController,
                  hint: "",
                  obscureText: obscurePassword,
                  focusNode: _passFocus,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.brown[800],
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),

                // --- REGRAS DA SENHA (Aparece condicionalmente) ---
                if (_showPassRules) ...[
                  const SizedBox(height: 10),
                  const Text("A senha deve conter:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _buildPassRule(has8Chars, "Mais de 8 caracteres"),
                  _buildPassRule(hasUpper, "Conter letras maiúsculas"),
                  _buildPassRule(hasLower, "Conter letras minúsculas"),
                  _buildPassRule(hasDigit, "Incluir pelo menos um número"),
                  _buildPassRule(hasSpecial, "Incluir pelo menos um caractere especial"),
                ],

                const SizedBox(height: 15),

                // --- GÊNERO ---
                _buildLabel("Genero:"),
                DropdownButtonFormField<String>(
                  value: genderValue,
                  decoration: _inputDecoration(),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[800]),
                  items: ['Masculino', 'Feminino', 'Outro']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      genderValue = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // --- CHECKBOX TERMOS ---
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: termsAccepted,
                        activeColor: buttonColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (v) => setState(() => termsAccepted = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("concordo com os termos e condições", style: TextStyle(fontSize: 12)),
                  ],
                ),

                const SizedBox(height: 30),

                // --- BOTÃO CRIAR CONTA ---
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // Valida o formulário para exibir os erros visuais
                        if (_formKey.currentState!.validate()) {
                          // Sucesso
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Criar Conta",
                        style: TextStyle(color: Color(0xFFFFBC2F), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- FOOTER LOGIN ---
                const Center(
                  child: Text(
                    "Já tem uma conta? Faça login",
                    style: TextStyle(color: Color(0xFF1F2923), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 2.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: labelColor, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    FocusNode? focusNode,
    String? Function(String?)? validator,
    bool isSmall = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      validator: validator,
      cursorColor: buttonColor,
      decoration: _inputDecoration().copyWith(
        suffixIcon: suffixIcon,
        errorStyle: TextStyle(
          color: errorColor,
          fontSize: 12,
        ),
        // Pequeno ajuste de altura se for o campo pequeno
        contentPadding: isSmall ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8) : null,
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: inputFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      errorBorder: OutlineInputBorder( // Borda vermelha igual imagem 3
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorColor, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: errorColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
    );
  }

  Widget _buildToggleButton(String text, bool isCpf) {
    final bool isSelected = isCpfSelected == isCpf;
    return GestureDetector(
      onTap: () {
        setState(() {
          isCpfSelected = isCpf;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? yellowAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? labelColor : yellowAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildPassRule(bool isValid, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: isValid ? Colors.green[800] : errorColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 11, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}