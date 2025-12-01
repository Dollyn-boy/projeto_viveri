import 'usuario_model.dart';

class Resposta {
  final int id;
  final String conteudo;
  final Usuario usuario;
  final int perguntaId;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Resposta({
    required this.id,
    required this.conteudo,
    required this.usuario,
    required this.perguntaId,
    this.criadoEm,
    this.atualizadoEm,
  });

  factory Resposta.fromJson(Map<String, dynamic> j) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    final usuarioJson = j['usuario'] ?? 0;
    return Resposta(
      id: j['id'] ?? 0,
      conteudo: j['conteudo'] ?? j['texto'] ?? '',
      usuario: usuarioJson is Map ? Usuario.fromJson(usuarioJson) : Usuario(id: usuarioJson ?? 0),
      perguntaId: j['pergunta'] is Map ? (j['pergunta']['id'] ?? 0) : (j['pergunta'] ?? 0),
      criadoEm: parseDt(j['created_at'] ?? j['criado_em']),
      atualizadoEm: parseDt(j['updated_at'] ?? j['atualizado_em']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'conteudo': conteudo,
        'usuario': usuario.id,
        'pergunta': perguntaId,
      };
}