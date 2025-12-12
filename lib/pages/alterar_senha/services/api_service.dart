import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ATENÇÃO AQUI:
  // Se no urls.py principal do projeto (não esse do app) você usou "path('api/', ...)"
  // então a base continua '.../api'. Se não usou prefixo, remova o '/api'.
  // Vou assumir que você tem um prefixo 'api/' no projeto principal.
  static const String baseUrl = 'http://127.0.0.1:8000/api'; 

  // 1. Enviar Email
  Future<bool> enviarEmailRecuperacao(String email) async {
    // AQUI MUDOU: Ajustado para bater com seu urls.py ('auth/forgot-password/')
    final url = Uri.parse('$baseUrl/auth/forgot-password/');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro API: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }

  // 2. Validar Código e Nova Senha
  Future<bool> validarCodigo(String email, String codigo) async {
    
    final url = Uri.parse('$baseUrl/auth/check-code/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'codigo': codigo,
          //'nova_senha': novaSenha
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro API: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }
}