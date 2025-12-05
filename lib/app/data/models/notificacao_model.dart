/// Modelo Notificacao - alinhado com a API Django
class Notificacao {
  final int id;
  final String tipo;  // 'ALERTA' ou 'INFO'
  final String conteudo;  // Campo da API
  final DateTime data;  // Campo da API
  final int usuario;  // ID do usuário
  final int evento;  // ID do evento
  final int? pergunta;  // ID da pergunta (opcional)

  Notificacao({
    required this.id,
    required this.tipo,
    required this.conteudo,
    required this.data,
    required this.usuario,
    required this.evento,
    this.pergunta,
  });

  factory Notificacao.fromJson(Map<String, dynamic> j) {
    return Notificacao(
      id: j['id'] ?? 0,
      tipo: j['tipo'] ?? 'INFO',
      conteudo: j['conteudo'] ?? '',
      data: j['data'] != null ? DateTime.parse(j['data']) : DateTime.now(),
      usuario: j['usuario'] ?? 0,
      evento: j['evento'] ?? 0,
      pergunta: j['pergunta'],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'tipo': tipo,
        'conteudo': conteudo,
        'data': data.toIso8601String(),
        'usuario': usuario,
        'evento': evento,
        if (pergunta != null) 'pergunta': pergunta,
      };
}