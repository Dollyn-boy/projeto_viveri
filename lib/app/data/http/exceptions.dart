/// Exceção customizada para erros HTTP
class HttpException implements Exception {
  final String message;
  final int? statusCode;

  HttpException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
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
      return 'HttpException($statusCode - $errorType): $message';
    }
    return 'HttpException: $message';
  }

  /// Retorna true se for erro de autenticação
  bool isAuthError() => statusCode == 401 || statusCode == 403;

  /// Retorna true se for erro de validação
  bool isValidationError() => statusCode == 400;
}
