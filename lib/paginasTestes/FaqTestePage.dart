import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../app/data/http/http_client.dart';
import '../app/data/repository/faq_repository.dart';
import '../app/services/auth_service.dart';

class FaqTestePage extends StatefulWidget {
  const FaqTestePage({super.key});

  @override
  State<FaqTestePage> createState() => _FaqTestePageState();
}

class _FaqTestePageState extends State<FaqTestePage> {
  // Services e Repository
  late final AuthService _authService;
  late final FaqRepository _repository;
  
  // Lista de perguntas e respostas
  List<dynamic> _perguntas = [];
  Map<int, List<dynamic>> _respostasPorPergunta = {};
  bool _isLoading = true;
  String? _errorMessage;

  // Controla qual pergunta está expandida (null = nenhuma)
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    // Inicializa os serviços
    _authService = AuthService();
    _repository = FaqRepository(
      httpClient: HttpClient(authService: _authService),
      baseUrl: ApiConstants.baseUrl,
    );
    
    _inicializarToken();
  }

  // Inicializa o token (temporário para testes)
  Future<void> _inicializarToken() async {
    // Salva o token de teste
    await _authService.saveToken(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzY0ODk2NDk1LCJpYXQiOjE3NjQ4OTQ2OTUsImp0aSI6ImE0MjdkOTQ2N2ZhMDQyZDM5N2YyM2IyNmM4NzEwYzRjIiwidXNlcl9pZCI6IjEifQ.yllwrPTCG7EbpRzSToJUyEdbY4PS43BSY5Dn2qnn7iU"
    ); //
    await _authService.saveRefreshToken(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc2NDk4MTA5NSwiaWF0IjoxNzY0ODk0Njk1LCJqdGkiOiI5YjU0MzZjMmEwODE0ZDRiYTU4ZTk0NmQ4ZWU2ZTY5OSIsInVzZXJfaWQiOiIxIn0.MzOxblttdMZ1x_w_NEeTtM35ixKl8416tTH77cVNwls"
    );
    _carregarPerguntas();
  }

  Future<void> _carregarPerguntas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('🔵 Iniciando requisição...');
      final perguntas = await _repository.buscarPerguntasPorEvento(1); // Evento ID 1
      
      print('✅ Recebeu ${perguntas.length} perguntas');
      
      if (!mounted) return;

      setState(() {
        _perguntas = perguntas;
        _isLoading = false;
      });
      
      print('📋 Lista final tem ${_perguntas.length} perguntas');
    } catch (e) {
      print('❌ Erro ao carregar: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar perguntas: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _carregarRespostas(int perguntaId) async {
    try {
      print('🔵 Buscando respostas para pergunta ID: $perguntaId');
      final respostas = await _repository.buscarRespostas(perguntaId: perguntaId);
      print('✅ Recebeu ${respostas.length} respostas');
      for (var r in respostas) {
        print('  - Resposta ID ${r.id}: pergunta=${r.pergunta}, txt="${r.txt}"');
      }
      setState(() {
        _respostasPorPergunta[perguntaId] = respostas;
      });
    } catch (e) {
      print('❌ Erro ao carregar respostas: $e');
    }
  }

  void _mostrarDialogCriarPergunta() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Pergunta'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Digite sua pergunta',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              
              Navigator.pop(context);
              
              try {
                await _repository.criarPergunta(
                  txt: controller.text.trim(),
                  eventoId: 1,
                );
                _carregarPerguntas();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pergunta criada com sucesso!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao criar pergunta: $e')),
                  );
                }
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogResponder(int perguntaId) {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Digite sua resposta',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              
              Navigator.pop(context);
              
              try {
                await _repository.criarResposta(
                  txt: controller.text.trim(),
                  perguntaId: perguntaId,
                );
                _carregarRespostas(perguntaId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resposta enviada com sucesso!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao enviar resposta: $e')),
                  );
                }
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  Future<void> _votar(int perguntaId, String tipo) async {
    try {
      await _repository.votarPergunta(perguntaId, tipo);
      
      // Recarrega as perguntas para atualizar a contagem de votos
      _carregarPerguntas();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voto ${tipo == 'UP' ? '👍' : '👎'} registrado!'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao votar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E2D1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6E7E67),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "FAQ - Evento #1",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF4D675A),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF1C40F)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFF1C40F)),
            onPressed: _carregarPerguntas,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogCriarPergunta,
        backgroundColor: const Color(0xFF4D675A),
        icon: const Icon(Icons.add, color: Color(0xFFF1C40F)),
        label: const Text(
          'Nova Pergunta',
          style: TextStyle(color: Color(0xFFF1C40F)),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4D675A),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFF4D675A),
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4D675A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4D675A),
                        ),
                        onPressed: _carregarPerguntas,
                        child: const Text(
                          'Tentar novamente',
                          style: TextStyle(color: Color(0xFFF1C40F)),
                        ),
                      ),
                    ],
                  ),
                )
              : _perguntas.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhuma pergunta disponível",
                        style: TextStyle(fontSize: 16, color: Color(0xFF4D675A)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _perguntas.length,
                      itemBuilder: (context, index) {
                        final pergunta = _perguntas[index];
                        final isExpanded = _expandedIndex == index;
                        final respostas = _respostasPorPergunta[pergunta.id] ?? [];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: const Color(0xFFC8D5C0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pergunta.txt,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4D675A),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    // Botões de votação
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_upward),
                                          color: const Color(0xFF4D675A),
                                          iconSize: 20,
                                          onPressed: () => _votar(pergunta.id, 'UP'),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        Text(
                                          '${pergunta.totalVotes}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4D675A),
                                            fontSize: 14,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.arrow_downward),
                                          color: const Color(0xFF4D675A),
                                          iconSize: 20,
                                          onPressed: () => _votar(pergunta.id, 'DOWN'),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: const SizedBox.shrink(),
                                trailing: Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: const Color(0xFF4D675A),
                                ),
                                onTap: () {
                                  setState(() {
                                    _expandedIndex = isExpanded ? null : index;
                                  });
                                  if (!isExpanded && respostas.isEmpty) {
                                    _carregarRespostas(pergunta.id);
                                  }
                                },
                              ),
                              if (isExpanded) ...[
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Respostas:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF4D675A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () => _mostrarDialogResponder(pergunta.id),
                                            icon: const Icon(Icons.add_comment, size: 16),
                                            label: const Text('Responder'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(0xFF4D675A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      if (respostas.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            'Nenhuma resposta ainda',
                                            style: TextStyle(
                                              color: Color(0xFF6E7E67),
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        )
                                      else
                                        ...respostas.map((resposta) => Container(
                                          margin: const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD9E2D1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            resposta.txt,
                                            style: const TextStyle(
                                              color: Color(0xFF4D675A),
                                              fontSize: 14,
                                              height: 1.5,
                                            ),
                                          ),
                                        )),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}