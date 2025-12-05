/// Modelo Resposta - alinhado com a API Django
class Resposta {
  final int id;
  final String txt;  // Campo da API
  final DateTime data;  // Campo da API
  final int usuario;  // ID do usuário
  final int pergunta;  // ID da pergunta

  Resposta({
    required this.id,
    required this.txt,
    required this.data,
    required this.usuario,
    required this.pergunta,
  });

  factory Resposta.fromJson(Map<String, dynamic> j) {
    return Resposta(
      id: j['id'] ?? 0,
      txt: j['txt'] ?? '',
      data: j['data'] != null ? DateTime.parse(j['data']) : DateTime.now(),
      usuario: j['usuario'] ?? 0,
      pergunta: j['pergunta'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'txt': txt,
        'data': data.toIso8601String(),
        'usuario': usuario,
        'pergunta': pergunta,
      };
}