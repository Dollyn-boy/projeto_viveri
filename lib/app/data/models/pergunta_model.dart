import 'usuario_model.dart';
import 'evento_model.dart';

class Pergunta {
  final int id;
  final String titulo;
  final String conteudo;
  final Usuario usuario;
  final Evento? evento;
  final int votos;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Pergunta({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.usuario,
    this.evento,
    required this.votos,
    this.criadoEm,
    this.atualizadoEm,
  });

  factory Pergunta.fromJson(Map<String, dynamic> j) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    final usuarioJson = j['usuario'] ?? 0;
    return Pergunta(
      id: j['id'] ?? 0,
      titulo: j['titulo'] ?? '',
      conteudo: j['conteudo'] ?? j['descricao'] ?? '',
      usuario: usuarioJson is Map ? Usuario.fromJson(usuarioJson) : Usuario(id: usuarioJson ?? 0),
      evento: j['evento'] == null ? null : Evento.fromJson(j['evento']),
      votos: j['votos'] ?? j['votos_count'] ?? 0,
      criadoEm: parseDt(j['created_at'] ?? j['criado_em'] ?? j['created']),
      atualizadoEm: parseDt(j['updated_at'] ?? j['atualizado_em'] ?? j['updated']),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'titulo': titulo,
        'conteudo': conteudo,
        'usuario': usuario.id,
        if (evento != null) 'evento': evento!.id,
      };
}