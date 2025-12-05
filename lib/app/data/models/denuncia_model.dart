/// Modelo Denuncia - alinhado com a API Django
class Denuncia {
  final int id;
  final String descricao;  // Campo da API
  final DateTime data;  // Campo da API
  final int? usuario;  // ID do usuário (nullable)
  final int? pergunta;  // ID da pergunta (nullable)
  final int? resposta;  // ID da resposta (nullable)

  Denuncia({
    required this.id,
    required this.descricao,
    required this.data,
    this.usuario,
    this.pergunta,
    this.resposta,
  });

  factory Denuncia.fromJson(Map<String, dynamic> j) {
    return Denuncia(
      id: j['id'] ?? 0,
      descricao: j['descricao'] ?? '',
      data: j['data'] != null ? DateTime.parse(j['data']) : DateTime.now(),
      usuario: j['usuario'],
      pergunta: j['pergunta'],
      resposta: j['resposta'],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'descricao': descricao,
        'data': data.toIso8601String(),
        if (usuario != null) 'usuario': usuario,
        if (pergunta != null) 'pergunta': pergunta,
        if (resposta != null) 'resposta': resposta,
      };
}