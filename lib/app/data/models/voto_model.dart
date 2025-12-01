import 'tipo_voto.dart';

class Voto {
  final int id;
  final int usuarioId;
  final int perguntaId;
  final TipoVoto tipo;

  Voto({
    required this.id,
    required this.usuarioId,
    required this.perguntaId,
    required this.tipo,
  });

  factory Voto.fromJson(Map<String, dynamic> j) => Voto(
        id: j['id'] ?? 0,
        usuarioId: j['usuario'] is Map ? (j['usuario']['id'] ?? 0) : (j['usuario'] ?? 0),
        perguntaId: j['pergunta'] is Map ? (j['pergunta']['id'] ?? 0) : (j['pergunta'] ?? 0),
        tipo: TipoVotoExt.fromJson(j['tipo']) ?? TipoVoto.UP,
      );

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'usuario': usuarioId,
        'pergunta': perguntaId,
        'tipo': tipo.toJson(),
      };
}