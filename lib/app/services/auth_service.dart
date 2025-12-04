import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de autenticação que gerencia o token JWT
class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  
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
}
