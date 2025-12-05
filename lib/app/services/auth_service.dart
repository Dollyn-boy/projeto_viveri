import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/api_constants.dart';

/// Serviço de autenticação que gerencia o token JWT
class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  final String baseUrl = ApiConstants.baseUrl;
  
  
  String? _cachedToken;
  String? _cachedRefreshToken;

  /// Salva o token de acesso
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Salva o refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    _cachedRefreshToken = refreshToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Salva ambos os tokens (access e refresh)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  /// Obtém o token de acesso
  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  /// Obtém o refresh token
  Future<String?> getRefreshToken() async {
    if (_cachedRefreshToken != null) return _cachedRefreshToken;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedRefreshToken = prefs.getString(_refreshTokenKey);
    return _cachedRefreshToken;
  }

  /// Verifica se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Remove os tokens (logout)
  Future<void> logout() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  /// Limpa o cache (útil após atualizar o token)
  void clearCache() {
    _cachedToken = null;
    _cachedRefreshToken = null;
  }

  /// Renova o token de acesso usando o refresh token
  /// Retorna true se conseguiu renovar, false caso contrário
  Future<bool> renovarToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        print('❌ Sem refresh token disponível');
        return false;
      }

      print('🔄 Renovando token...');
      
      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newAccessToken = data['access'] as String;
        
        await saveToken(newAccessToken);
        print('✅ Token renovado com sucesso!');
        return true;
      } else {
        print('❌ Falha ao renovar token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erro ao renovar token: $e');
      return false;
    }
  }
}
