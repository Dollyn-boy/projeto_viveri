import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/api_constants.dart';

class AlterarSenhaPage extends StatefulWidget {
  const AlterarSenhaPage({super.key});

  @override
  State<AlterarSenhaPage> createState() => _AlterarSenhaPageState();
}

class _AlterarSenhaPageState extends State<AlterarSenhaPage> {
  final _atualCtrl = TextEditingController();
  final _novaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  // Variável para controlar todos os campos (visisbilidade das senhas)
  bool _ocultarSenhas = true;

  // Token teste
  final String _authToken = "TOKEN_DE_AUTENTICACAO"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2D1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6E7E67),
        elevation: 0,
        centerTitle: true,
        title: const Text("Alterar senha", style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF4D675A),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF1C40F)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            
            _campo("Informe a senha atual:", _atualCtrl),
            const SizedBox(height: 16),
            
            _campo("Informe a nova senha:", _novaCtrl),
            const SizedBox(height: 16),
            
            _campo("Confirme a senha:", _confirmarCtrl),
            
            const SizedBox(height: 8),

            // Controle único de visibilidade para as 3 senhas
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Mostrar senhas", style: TextStyle(color: Color(0xFF4D675A), fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(
                    _ocultarSenhas ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF4D675A),
                  ),
                  onPressed: () {
                    setState(() {
                      _ocultarSenhas = !_ocultarSenhas;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4D675A)),
                onPressed: _alterarSenha,
                child: const Text("Redefinir", style: TextStyle(color: Color(0xFFF1C40F), fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // Widget usa a variável global _ocultarSenhas
  Widget _campo(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: _ocultarSenhas, // Controlado pela variável única
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFC8D5C0),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
        )
      ],
    );
  }

  Future<void> _alterarSenha() async {
    if (_novaCtrl.text != _confirmarCtrl.text) {
      _msg("As novas senhas não coincidem");
      return;
    }

    final url = Uri.parse(ApiConstants.changePassword);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $_authToken',
        },
        body: jsonEncode({
          'old_password': _atualCtrl.text,
          'new_password': _novaCtrl.text,
          'new_password_confirm': _confirmarCtrl.text,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _msg("Senha redefinida com sucesso!");
        _atualCtrl.clear();
        _novaCtrl.clear();
        _confirmarCtrl.clear();
      } else {
        String errorMsg = "Erro no servidor.";
        if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          errorMsg = data['old_password']?.first ?? 
                     data['new_password']?.first ?? 
                     data['new_password_confirm']?.first ?? 
                     data['detail'] ?? "Verifique os campos.";
        } else if (response.statusCode == 401) {
          errorMsg = "Não autorizado. Faça login novamente.";
        }
        _msg(errorMsg);
      }
    } catch (e) {
      if (mounted) _msg("Erro de conexão.");
    }
  }

  void _msg(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }
}