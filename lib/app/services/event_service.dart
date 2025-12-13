import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viveri/app/data/models/event_model.dart';

class EventService {
  // IMPORTANTE:
  // Android Emulator: use 'http://10.0.2.2:8000/eventos'
  // iOS Emulator: use 'http://127.0.0.1:8000/eventos'
  // Dispositivo Físico: use o IP da sua máquina (ex: 'http://192.168.1.5:8000/eventos')
  final String baseUrl = "http://127.0.0.1:8000/eventos";

  Future<EventModel> fetchEventDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/detalhe/$id/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return EventModel.fromJson(data);
      } else {
        throw Exception('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
