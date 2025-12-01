class Denuncia {
  final int id;
  final int usuarioId;
  final String conteudo;
  final String? alvoTipo;
  final int? alvoId;
  final DateTime? criadoEm;

  Denuncia({
    required this.id,
    required this.usuarioId,
    required this.conteudo,
    this.alvoTipo,
    this.alvoId,
    this.criadoEm,
  });

  factory Denuncia.fromJson(Map<String, dynamic> j) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return Denuncia(
      id: j['id'] ?? 0,
      usuarioId: j['usuario'] is Map ? (j['usuario']['id'] ?? 0) : (j['usuario'] ?? 0),
      conteudo: j['conteudo'] ?? j['descricao'] ?? '',
      alvoTipo: j['alvo_tipo'] ?? j['target_type'] ?? null,
      alvoId: j['alvo_id'] ?? j['target_id'] ?? null,
      criadoEm: parseDt(j['created_at'] ?? j['criado_em']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'usuario': usuarioId,
        'conteudo': conteudo,
        if (alvoTipo != null) 'alvo_tipo': alvoTipo,
        if (alvoId != null) 'alvo_id': alvoId,
      };
}