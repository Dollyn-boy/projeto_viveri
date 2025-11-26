class ApiConstants {
  // Base da URL: Se mudar o servidor, só altera aqui.
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Endpoints específicos concatenados com a base
  static const String eventos = '$baseUrl/eventos/';
  static const String changePassword = '$baseUrl/usuarios/change-password/';
}