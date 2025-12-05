
/// Modelo Voto - alinhado com a API Django
class Voto {
  final int id;
  final String tipo;  // 'UP' ou 'DOWN'
  final DateTime data;  // Campo da API
  final int usuario;  // ID do usuário
  final int pergunta;  // ID da pergunta

  Voto({
    required this.id,
    required this.tipo,
    required this.data,
    required this.usuario,
    required this.pergunta,
  });

  factory Voto.fromJson(Map<String, dynamic> j) {
    return Voto(
      id: j['id'] ?? 0,
      tipo: j['tipo'] ?? 'UP',
      data: j['data'] != null ? DateTime.parse(j['data']) : DateTime.now(),
      usuario: j['usuario'] ?? 0,
      pergunta: j['pergunta'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'tipo': tipo,
        'data': data.toIso8601String(),
        'usuario': usuario,
        'pergunta': pergunta,
      };
}