

class Pergunta {
  final int id;
  final String txt;  // Campo da API
  final DateTime data;  // Campo da API
  final int usuario;  // ID do usuário
  final int evento;  // ID do evento
  final int totalVotes;  // total_votes da API

  Pergunta({
    required this.id,
    required this.txt,
    required this.data,
    required this.usuario,
    required this.evento,
    this.totalVotes = 0,
  });

  factory Pergunta.fromJson(Map<String, dynamic> j) {
    return Pergunta(
      id: j['id'] ?? 0,
      txt: j['txt'] ?? '',
      data: j['data'] != null ? DateTime.parse(j['data']) : DateTime.now(),
      usuario: j['usuario'] ?? 0,
      evento: j['evento'] ?? 0,
      totalVotes: j['total_votes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'txt': txt,
        'data': data.toIso8601String(),
        'usuario': usuario,
        'evento': evento,
      };
}