import 'usuario_model.dart';
import 'evento_model.dart';

class Notificacao {
  final int id;
  final Usuario usuario;
  final Evento? evento;
  final String conteudo;
  final int? perguntaId;
  final bool lida;
  final DateTime? criadoEm;

  Notificacao({
    required this.id,
    required this.usuario,
    this.evento,
    required this.conteudo,
    this.perguntaId,
    this.lida = false,
    this.criadoEm,
  });

  factory Notificacao.fromJson(Map<String, dynamic> j) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    final usuarioJson = j['usuario'] ?? 0;
    return Notificacao(
      id: j['id'] ?? 0,
      usuario: usuarioJson is Map ? Usuario.fromJson(usuarioJson) : Usuario(id: usuarioJson ?? 0),
      evento: j['evento'] == null ? null : Evento.fromJson(j['evento']),
      conteudo: j['conteudo'] ?? '',
      perguntaId: j['pergunta'] is Map ? (j['pergunta']['id'] ?? null) : (j['pergunta'] ?? null),
      lida: j['lida'] ?? j['read'] ?? false,
      criadoEm: parseDt(j['created_at'] ?? j['criado_em']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'usuario': usuario.id,
        if (evento != null) 'evento': evento!.id,
        'conteudo': conteudo,
        if (perguntaId != null) 'pergunta': perguntaId,
        'lida': lida,
      };
}