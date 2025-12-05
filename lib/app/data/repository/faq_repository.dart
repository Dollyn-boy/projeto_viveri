import '../http/http_client.dart';
import '../models/denuncia_model.dart';
import '../models/notificacao_model.dart';
import '../models/pergunta_model.dart';
import '../models/resposta_model.dart';

class FaqRepository {
  final IHttpClient _httpClient;
  final String _baseUrl;

  FaqRepository({
    required IHttpClient httpClient,
    required String baseUrl,
  })  : _httpClient = httpClient,
        _baseUrl = baseUrl;

  // ==================== PERGUNTAS ====================

  /// Busca todas as perguntas
  Future<List<Pergunta>> buscarTodasPerguntas() async {
    try {
      final data = await _httpClient.get(
        url: '$_baseUrl/faq/pergunta/',
      );
      
      if (data == null || data is! List) return [];
      return data.map((e) => Pergunta.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar perguntas: $e');
    }
  }

  /// Busca perguntas de um evento específico
  Future<List<Pergunta>> buscarPerguntasPorEvento(int eventoId) async {
    try {
      final data = await _httpClient.get(
        url: '$_baseUrl/faq/pergunta/?evento=$eventoId',
      );
      
      if (data == null || data is! List) return [];
      return data.map((e) => Pergunta.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar perguntas do evento $eventoId: $e');
    }
  }

  /// Busca uma pergunta por ID
  Future<Pergunta?> buscarPerguntaPorId(int id) async {
    try {
      final data = await _httpClient.get(
        url: '$_baseUrl/faq/pergunta/$id/',
      );
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar pergunta $id: $e');
    }
  }

  /// Cria uma nova pergunta
  Future<Pergunta> criarPergunta({
    required String txt,
    required int eventoId,
    int? usuarioId,
  }) async {
    try {
      final payload = {
        'txt': txt,
        'evento': eventoId,
        if (usuarioId != null) 'usuario': usuarioId,
      };

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/pergunta/',
        body: payload,
      );
      
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar pergunta: $e');
    }
  }

  /// Atualiza uma pergunta
  Future<Pergunta> atualizarPergunta(
    int id, {
    required String txt,
    int? eventoId,
  }) async {
    try {
      final payload = {
        'txt': txt,
        if (eventoId != null) 'evento': eventoId,
      };

      final data = await _httpClient.put(
        url: '$_baseUrl/faq/pergunta/$id/',
        body: payload,
      );
      
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pergunta $id: $e');
    }
  }

  /// Atualiza parcialmente uma pergunta
  Future<Pergunta> atualizarPerguntaParcial(
    int id,
    Map<String, dynamic> campos,
  ) async {
    try {
      final data = await _httpClient.patch(
        url: '$_baseUrl/faq/pergunta/$id/',
        body: campos,
      );
      
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pergunta $id parcialmente: $e');
    }
  }

  /// Deleta uma pergunta
  Future<void> deletarPergunta(int id) async {
    try {
      await _httpClient.delete(
        url: '$_baseUrl/faq/pergunta/$id/',
      );
    } catch (e) {
      throw Exception('Erro ao deletar pergunta $id: $e');
    }
  }

  // ==================== VOTOS ====================

  /// Vota em uma pergunta
  Future<Map<String, dynamic>> votarPergunta(
    int perguntaId,
    String tipo,
  ) async {
    try {
      final tipoNormalizado = tipo.toUpperCase();
      if (!['UP', 'DOWN'].contains(tipoNormalizado)) {
        throw ArgumentError('Tipo de voto inválido. Use "UP" ou "DOWN".');
      }

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/pergunta/$perguntaId/votar/',
        body: {'tipo': tipoNormalizado},
      );
      
      return data;
    } catch (e) {
      throw Exception('Erro ao votar na pergunta $perguntaId: $e');
    }
  }

  /// Cancela o voto do usuário em uma pergunta
  Future<void> cancelarVotoPergunta(int perguntaId) async {
    try {
      await _httpClient.delete(
        url: '$_baseUrl/faq/pergunta/$perguntaId/votar/',
      );
    } catch (e) {
      throw Exception('Erro ao cancelar voto na pergunta $perguntaId: $e');
    }
  }

  // ==================== RESPOSTAS ====================

  /// Busca todas as respostas
  Future<List<Resposta>> buscarRespostas({int? perguntaId}) async {
    try {
      final path = perguntaId != null
          ? '$_baseUrl/faq/resposta/?pergunta=$perguntaId'
          : '$_baseUrl/faq/resposta/';

      final data = await _httpClient.get(url: path);
      
      if (data == null || data is! List) return [];
      return data.map((e) => Resposta.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar respostas: $e');
    }
  }

  /// Busca uma resposta específica por ID
  Future<Resposta?> buscarRespostaPorId(int id) async {
    try {
      final data = await _httpClient.get(
        url: '$_baseUrl/faq/resposta/$id/',
      );
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao buscar resposta $id: $e');
    }
  }

  /// Cria uma nova resposta
  Future<Resposta> criarResposta({
    required String txt,
    required int perguntaId,
  }) async {
    try {
      final payload = {
        'txt': txt,
        'pergunta': perguntaId,
      };

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/resposta/',
        body: payload,
      );
      
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar resposta: $e');
    }
  }

  /// Atualiza uma resposta
  Future<Resposta> atualizarResposta({
    required int id,
    required String txt,
  }) async {
    try {
      final payload = {
        'txt': txt,
      };

      final data = await _httpClient.put(
        url: '$_baseUrl/faq/resposta/$id/',
        body: payload,
      );
      
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar resposta $id: $e');
    }
  }

  /// Deleta uma resposta
  Future<void> deletarResposta(int id) async {
    try {
      await _httpClient.delete(
        url: '$_baseUrl/faq/resposta/$id/',
      );
    } catch (e) {
      throw Exception('Erro ao deletar resposta $id: $e');
    }
  }

  // ==================== NOTIFICAÇÕES ====================

  /// Busca notificações
  Future<List<Notificacao>> buscarNotificacoes() async {
    try {
      final data = await _httpClient.get(
        url: '$_baseUrl/faq/notificacao/',
      );
      
      if (data == null || data is! List) return [];
      return data.map((e) => Notificacao.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar notificações: $e');
    }
  }

  // ==================== DENÚNCIAS ====================

  /// Busca denúncias (admin)
  Future<List<Denuncia>> buscarDenuncias() async {
    try {
      final data = await _httpClient.get(
        url: '$_baseUrl/faq/denuncia/',
      );
      
      if (data == null || data is! List) return [];
      return data.map((e) => Denuncia.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar denúncias: $e');
    }
  }

  /// Cria uma denúncia
  Future<Denuncia> criarDenuncia({
    required String descricao,
    int? perguntaId,
    int? respostaId,
  }) async {
    try {
      if (perguntaId == null && respostaId == null) {
        throw ArgumentError('É necessário informar perguntaId ou respostaId');
      }

      final payload = {
        'descricao': descricao,
        if (perguntaId != null) 'pergunta': perguntaId,
        if (respostaId != null) 'resposta': respostaId,
      };

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/denuncia/',
        body: payload,
      );
      
      return Denuncia.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar denúncia: $e');
    }
  }
}
