import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/models/user_model.dart';
import 'package:viveri/constants/api_constants.dart';

class UserService {
  String baseUrl = ApiConstants.baseUrl;
  Future<UserModel> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/me/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Falha ao carregar usuário');
    }
  }
}
