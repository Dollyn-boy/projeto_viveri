import 'dart:convert';
import 'package:http/http.dart' as http;
import 'exceptions.dart';
import '../../services/auth_service.dart';

/// Interface abstrata para o cliente HTTP
/// Permite trocar a implementação facilmente (útil para testes)
abstract class IHttpClient {
  Future<dynamic> get({required String url, Map<String, String>? headers});
  Future<dynamic> post({required String url, required Map<String, dynamic> body, Map<String, String>? headers});
  Future<dynamic> put({required String url, required Map<String, dynamic> body, Map<String, String>? headers});
  Future<dynamic> patch({required String url, required Map<String, dynamic> body, Map<String, String>? headers});
  Future<void> delete({required String url, Map<String, String>? headers});
}

/// Implementação do cliente HTTP
/// Wrapper sobre http.Client() com tratamento de erros e JSON
class HttpClient implements IHttpClient {
  final http.Client client;
  final AuthService authService;

  HttpClient({
    http.Client? client,
    AuthService? authService,
  })  : client = client ?? http.Client(),
        authService = authService ?? AuthService();

  /// Headers padrão para todas as requisições
  Future<Map<String, String>> _defaultHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Adiciona token automaticamente se existir
    final token = await authService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Mescla headers padrão com headers customizados
  Future<Map<String, String>> _mergeHeaders(Map<String, String>? customHeaders) async {
    final headers = await _defaultHeaders();
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  /// Executa requisição com retry automático em caso de 401
  Future<dynamic> _executeWithRetry(Future<http.Response> Function() request) async {
    try {
      var response = await request();

      // Se retornou 401, tenta renovar o token
      if (response.statusCode == 401) {
        print('⚠️  Token expirado (401), tentando renovar...');
        
        final renovado = await authService.renovarToken();
        
        if (renovado) {
          print('✅ Token renovado! Repetindo requisição...');
          authService.clearCache();
          // Tenta a requisição novamente com o novo token
          response = await request();
        } else {
          print('❌ Falha ao renovar token');
        }
      }

      return _handleResponse(response);
    } catch (e) {
      if (e is HttpException) rethrow;
      throw HttpException('Erro de conexão: $e');
    }
  }

  /// GET - Buscar dados
  @override
  Future<dynamic> get({required String url, Map<String, String>? headers}) async {
    return _executeWithRetry(() async {
      return await client.get(
        Uri.parse(url),
        headers: await _mergeHeaders(headers),
      );
    });
  }

  /// POST - Criar recurso
  @override
  Future<dynamic> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return _executeWithRetry(() async {
      return await client.post(
        Uri.parse(url),
        headers: await _mergeHeaders(headers),
        body: json.encode(body),
      );
    });
  }

  /// PUT - Atualizar recurso completo
  @override
  Future<dynamic> put({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return _executeWithRetry(() async {
      return await client.put(
        Uri.parse(url),
        headers: await _mergeHeaders(headers),
        body: json.encode(body),
      );
    });
  }

  /// PATCH - Atualizar recurso parcialmente
  @override
  Future<dynamic> patch({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return _executeWithRetry(() async {
      return await client.patch(
        Uri.parse(url),
        headers: await _mergeHeaders(headers),
        body: json.encode(body),
      );
    });
  }

  /// DELETE - Remover recurso
  @override
  Future<void> delete({required String url, Map<String, String>? headers}) async {
    return _executeWithRetry(() async {
      return await client.delete(
        Uri.parse(url),
        headers: await _mergeHeaders(headers),
      );
    });
  }

  /// Processa a resposta HTTP e trata erros
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Sucesso (2xx)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        final decoded = json.decode(response.body);
        return _normalizeJson(decoded);
      } catch (e) {
        throw HttpException('Erro ao decodificar JSON: $e');
      }
    }

    // Erros (4xx, 5xx)
    String errorMessage = 'Erro HTTP $statusCode';
    try {
      final errorBody = json.decode(response.body);
      if (errorBody is Map) {
        errorMessage = errorBody['detail'] ?? 
                      errorBody['error'] ?? 
                      errorBody['message'] ?? 
                      response.body;
      }
    } catch (_) {
      errorMessage = response.body;
    }

    throw HttpException(errorMessage, statusCode: statusCode);
  }

  /// Normaliza JSON para Map com String, dynamic
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

  /// Fecha o cliente HTTP
  void close() {
    client.close();
  }
}