import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? _token;

  ApiService({required this.baseUrl, String? token}) : _token = token;

  /// Define o token de autenticação (Bearer ou Token)
  void setToken(String? token) => _token = token;

  /// Retorna os headers padrão para requisições
  Map<String, String> _headers() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Token $_token'; // ajuste para 'Bearer $_token' se usar JWT
    }
    return headers;
  }

  /// GET - buscar dados
  Future<dynamic> get(String path) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.get(uri, headers: _headers());
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(0, 'Erro de conexão: $e');
    }
  }

  /// POST - criar recurso
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.post(
        uri,
        headers: _headers(),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(0, 'Erro de conexão: $e');
    }
  }

  /// PUT - atualizar recurso completo
  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.put(
        uri,
        headers: _headers(),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(0, 'Erro de conexão: $e');
    }
  }

  /// PATCH - atualizar recurso parcialmente
  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.patch(
        uri,
        headers: _headers(),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException(0, 'Erro de conexão: $e');
    }
  }

  /// DELETE - remover recurso
  Future<void> delete(String path) async {
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response = await http.delete(uri, headers: _headers());
      
      final statusCode = response.statusCode;
      // DELETE pode retornar 204 (No Content) ou 200
      if (statusCode < 200 || statusCode >= 300) {
        throw ApiException(statusCode, response.body);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(0, 'Erro de conexão: $e');
    }
  }

  /// Processa a resposta HTTP
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Respostas de sucesso (2xx)
    if (statusCode >= 200 && statusCode < 300) {
      // Se corpo vazio (ex: DELETE 204), retorna null
      if (response.body.isEmpty) return null;

      try {
        final decoded = json.decode(response.body);
        return _normalizeJson(decoded);
      } catch (e) {
        throw ApiException(statusCode, 'Erro ao decodificar JSON: $e');
      }
    }

    // Erros (4xx, 5xx)
    String errorMessage;
    try {
      final errorBody = json.decode(response.body);
      // Tenta extrair mensagem de erro do Django/DRF
      if (errorBody is Map) {
        errorMessage = errorBody['detail'] ?? 
                      errorBody['error'] ?? 
                      errorBody['message'] ?? 
                      response.body;
      } else {
        errorMessage = response.body;
      }
    } catch (_) {
      errorMessage = response.body;
    }

    throw ApiException(statusCode, errorMessage);
  }

  /// Normaliza JSON para Map<String, dynamic> e List<Map<String, dynamic>>
  /// Isso corrige o erro "Map<dynamic, dynamic> can't be assigned to Map<String, dynamic>"
  dynamic _normalizeJson(dynamic data) {
    if (data is List) {
      return data.map((item) {
        if (item is Map) {
          return Map<String, dynamic>.from(item);
        }
        return item;
      }).toList();
    } else if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return data;
  }
}

/// Exceção customizada para erros da API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    if (statusCode == 0) return 'ApiException: $message';
    
    String errorType;
    switch (statusCode) {
      case 400:
        errorType = 'Requisição Inválida';
        break;
      case 401:
        errorType = 'Não Autenticado';
        break;
      case 403:
        errorType = 'Acesso Negado';
        break;
      case 404:
        errorType = 'Não Encontrado';
        break;
      case 500:
        errorType = 'Erro no Servidor';
        break;
      default:
        errorType = 'Erro HTTP';
    }
    
    return 'ApiException($statusCode - $errorType): $message';
  }

  /// Retorna true se for erro de autenticação
  bool isAuthError() => statusCode == 401 || statusCode == 403;

  /// Retorna true se for erro de validação
  bool isValidationError() => statusCode == 400;
}