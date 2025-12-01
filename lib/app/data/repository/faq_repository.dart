import '/services/api_service.dart';
import '../models/denuncia_model.dart';
import '../models/notificacao_model.dart';
import '../models/pergunta_model.dart';
import '../models/resposta_model.dart';

/// Repositório responsável por gerenciar operações de FAQ (Perguntas, Respostas, Votos, etc.)
class FaqRepository {
  final ApiService _api;

  FaqRepository(this._api);

  // ==================== PERGUNTAS ====================

  /// Busca todas as perguntas disponíveis
  Future<List<Pergunta>> buscarTodasPerguntas() async {
    try {
      final data = await _api.get('/FAQ/pergunta/');
      if (data == null || data is! List) return [];
      return data.map((e) => Pergunta.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar perguntas: $e');
    }
  }

  /// Busca uma pergunta específica por ID
  Future<Pergunta?> buscarPerguntaPorId(int id) async {
    try {
      final data = await _api.get('/FAQ/pergunta/$id/');
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar pergunta $id: $e');
    }
  }

  /// Cria uma nova pergunta
  ///
  /// Exemplo de payload:
  /// ```dart
  /// {
  ///   'titulo': 'Como funciona?',
  ///   'conteudo': 'Descrição da pergunta',
  ///   'evento': 1 // opcional
  /// }
  /// ```
  Future<Pergunta> criarPergunta({
    required String titulo,
    required String conteudo,
    int? eventoId,
  }) async {
    try {
      final payload = {
        'titulo': titulo,
        'conteudo': conteudo,
        if (eventoId != null) 'evento': eventoId,
      };
      final data = await _api.post('/FAQ/pergunta/', payload);
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar pergunta: $e');
    }
  }

  /// Atualiza uma pergunta completamente (requer todos os campos)
  Future<Pergunta> atualizarPergunta(
    int id, {
    required String titulo,
    required String conteudo,
    int? eventoId,
  }) async {
    try {
      final payload = {
        'titulo': titulo,
        'conteudo': conteudo,
        if (eventoId != null) 'evento': eventoId,
      };
      final data = await _api.put('/FAQ/pergunta/$id/', payload);
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pergunta $id: $e');
    }
  }

  /// Atualiza parcialmente uma pergunta (apenas campos fornecidos)
  Future<Pergunta> atualizarPerguntaParcial(
    int id,
    Map<String, dynamic> campos,
  ) async {
    try {
      final data = await _api.patch('/FAQ/pergunta/$id/', campos);
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pergunta $id parcialmente: $e');
    }
  }

  /// Deleta uma pergunta
  Future<void> deletarPergunta(int id) async {
    try {
      await _api.delete('/FAQ/pergunta/$id/');
    } catch (e) {
      throw Exception('Erro ao deletar pergunta $id: $e');
    }
  }

  // ==================== VOTOS ====================

  /// Registra um voto em uma pergunta
  ///
  /// [tipo] pode ser 'UP' (positivo) ou 'DOWN' (negativo)
  Future<Map<String, dynamic>> votarPergunta(
    int perguntaId,
    String tipo,
  ) async {
    try {
      final tipoNormalizado = tipo.toUpperCase();
      if (!['UP', 'DOWN'].contains(tipoNormalizado)) {
        throw ArgumentError('Tipo de voto inválido. Use "UP" ou "DOWN".');
      }

      final data = await _api.post('/FAQ/pergunta/$perguntaId/votar/', {
        'tipo': tipoNormalizado,
      });
      return data;
    } catch (e) {
      throw Exception('Erro ao votar na pergunta $perguntaId: $e');
    }
  }

  // ==================== RESPOSTAS ====================

  /// Busca todas as respostas, com opção de filtrar por pergunta
  Future<List<Resposta>> buscarRespostas({int? perguntaId}) async {
    try {
      final path = perguntaId != null
          ? '/FAQ/resposta/?pergunta=$perguntaId'
          : '/FAQ/resposta/';

      final data = await _api.get(path);
      if (data == null || data is! List) return [];
      return data.map((e) => Resposta.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar respostas: $e');
    }
  }

  /// Busca uma resposta específica por ID
  Future<Resposta?> buscarRespostaPorId(int id) async {
    try {
      final data = await _api.get('/FAQ/resposta/$id/');
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar resposta $id: $e');
    }
  }

  /// Cria uma nova resposta para uma pergunta
  Future<Resposta> criarResposta({
    required String conteudo,
    required int perguntaId,
  }) async {
    try {
      final payload = {'conteudo': conteudo, 'pergunta': perguntaId};
      final data = await _api.post('/FAQ/resposta/', payload);
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar resposta: $e');
    }
  }

  /// Atualiza uma resposta existente
  Future<Resposta> atualizarResposta(
    int id, {
    required String conteudo,
    required int perguntaId,
  }) async {
    try {
      final payload = {'conteudo': conteudo, 'pergunta': perguntaId};
      final data = await _api.put('/FAQ/resposta/$id/', payload);
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar resposta $id: $e');
    }
  }

  /// Deleta uma resposta
  Future<void> deletarResposta(int id) async {
    try {
      await _api.delete('/FAQ/resposta/$id/');
    } catch (e) {
      throw Exception('Erro ao deletar resposta $id: $e');
    }
  }

  // ==================== NOTIFICAÇÕES ====================

  /// Busca todas as notificações do usuário logado
  Future<List<Notificacao>> buscarNotificacoes() async {
    try {
      final data = await _api.get('/FAQ/notificacao/');
      if (data == null || data is! List) return [];
      return data.map((e) => Notificacao.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar notificações: $e');
    }
  }

  /// Marca uma notificação como lida
  Future<void> marcarNotificacaoComoLida(int id) async {
    try {
      await _api.patch('/FAQ/notificacao/$id/', {'lida': true});
    } catch (e) {
      throw Exception('Erro ao marcar notificação $id como lida: $e');
    }
  }

  // ==================== DENÚNCIAS ====================

  /// Cria uma nova denúncia
  ///
  /// Exemplo de payload:
  /// ```dart
  /// {
  ///   'tipo': 'SPAM',
  ///   'descricao': 'Motivo da denúncia',
  ///   'pergunta': 1, // ou 'resposta': 1
  /// }
  /// ```
  Future<Denuncia> criarDenuncia({
    required String tipo,
    required String descricao,
    int? perguntaId,
    int? respostaId,
  }) async {
    try {
      if (perguntaId == null && respostaId == null) {
        throw ArgumentError('É necessário informar perguntaId ou respostaId');
      }

      final payload = {
        'tipo': tipo,
        'descricao': descricao,
        if (perguntaId != null) 'pergunta': perguntaId,
        if (respostaId != null) 'resposta': respostaId,
      };

      final data = await _api.post('/FAQ/denuncia/', payload);
      return Denuncia.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar denúncia: $e');
    }
  }
}
