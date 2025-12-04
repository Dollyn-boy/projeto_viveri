import '../http/http_client.dart';
import '../models/denuncia_model.dart';
import '../models/notificacao_model.dart';
import '../models/pergunta_model.dart';
import '../models/resposta_model.dart';

/// EXEMPLO: faqRepository usando HttpClient (abordagem do vídeo)
/// 
/// Esta é a mesma funcionalidade do faq_repository.dart
/// mas usando HttpClient ao invés de ApiService
class faqRepository {
  final IHttpClient _httpClient;
  final String _baseUrl;

  faqRepository({
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
    required String titulo,
    required String conteudo,
    int? eventoId,
    String? token,
  }) async {
    try {
      final payload = {
        'titulo': titulo,
        'conteudo': conteudo,
        if (eventoId != null) 'evento': eventoId,
      };

      // Se tiver token, adiciona no header
      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/pergunta/',
        body: payload,
        headers: headers,
      );
      
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar pergunta: $e');
    }
  }

  /// Atualiza uma pergunta
  Future<Pergunta> atualizarPergunta(
    int id, {
    required String titulo,
    required String conteudo,
    int? eventoId,
    String? token,
  }) async {
    try {
      final payload = {
        'titulo': titulo,
        'conteudo': conteudo,
        if (eventoId != null) 'evento': eventoId,
      };

      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.put(
        url: '$_baseUrl/faq/pergunta/$id/',
        body: payload,
        headers: headers,
      );
      
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pergunta $id: $e');
    }
  }

  /// Atualiza parcialmente uma pergunta
  Future<Pergunta> atualizarPerguntaParcial(
    int id,
    Map<String, dynamic> campos, {
    String? token,
  }) async {
    try {
      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.patch(
        url: '$_baseUrl/faq/pergunta/$id/',
        body: campos,
        headers: headers,
      );
      
      return Pergunta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao atualizar pergunta $id parcialmente: $e');
    }
  }

  /// Deleta uma pergunta
  Future<void> deletarPergunta(int id, {String? token}) async {
    try {
      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      await _httpClient.delete(
        url: '$_baseUrl/faq/pergunta/$id/',
        headers: headers,
      );
    } catch (e) {
      throw Exception('Erro ao deletar pergunta $id: $e');
    }
  }

  // ==================== VOTOS ====================

  /// Vota em uma pergunta
  Future<Map<String, dynamic>> votarPergunta(
    int perguntaId,
    String tipo, {
    String? token,
  }) async {
    try {
      final tipoNormalizado = tipo.toUpperCase();
      if (!['UP', 'DOWN'].contains(tipoNormalizado)) {
        throw ArgumentError('Tipo de voto inválido. Use "UP" ou "DOWN".');
      }

      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/pergunta/$perguntaId/votar/',
        body: {'tipo': tipoNormalizado},
        headers: headers,
      );
      
      return data;
    } catch (e) {
      throw Exception('Erro ao votar na pergunta $perguntaId: $e');
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

  /// Cria uma nova resposta
  Future<Resposta> criarResposta({
    required String conteudo,
    required int perguntaId,
    String? token,
  }) async {
    try {
      final payload = {
        'conteudo': conteudo,
        'pergunta': perguntaId,
      };

      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/resposta/',
        body: payload,
        headers: headers,
      );
      
      return Resposta.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar resposta: $e');
    }
  }

  // ==================== NOTIFICAÇÕES ====================

  /// Busca notificações
  Future<List<Notificacao>> buscarNotificacoes({String? token}) async {
    try {
      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.get(
        url: '$_baseUrl/faq/notificacao/',
        headers: headers,
      );
      
      if (data == null || data is! List) return [];
      return data.map((e) => Notificacao.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar notificações: $e');
    }
  }

  // ==================== DENÚNCIAS ====================

  /// Cria uma denúncia
  Future<Denuncia> criarDenuncia({
    required String tipo,
    required String descricao,
    int? perguntaId,
    int? respostaId,
    String? token,
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

      final headers = token != null 
          ? {'Authorization': 'Token $token'} 
          : null;

      final data = await _httpClient.post(
        url: '$_baseUrl/faq/denuncia/',
        body: payload,
        headers: headers,
      );
      
      return Denuncia.fromJson(data);
    } catch (e) {
      throw Exception('Erro ao criar denúncia: $e');
    }
  }
}
