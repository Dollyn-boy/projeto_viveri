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
  late final faqRepository _repository;
  
  // Lista de perguntas e respostas
  List<dynamic> _perguntas = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Controla qual pergunta está expandida (null = nenhuma)
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    // Inicializa os serviços
    _authService = AuthService();
    _repository = faqRepository(
      httpClient: HttpClient(authService: _authService),
      baseUrl: ApiConstants.baseUrl,
    );
    _inicializarToken();
  }

  // Inicializa o token (temporário para testes)
  Future<void> _inicializarToken() async {
    // Salva o token de teste
    await _authService.saveToken(
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzY0NjM3MzIwLCJpYXQiOjE3NjQ2MzU1MjAsImp0aSI6ImIzNWMzMzc3NGQyNjQ2N2Q4YjViMzg5NjdjYzhjODE3IiwidXNlcl9pZCI6IjEifQ.xki3fbyobfKjYWDmAP9IkukfAxMHqt9gVMLjwmZGGsc"
    ); //
    _carregarPerguntas();
  }

  Future<void> _carregarPerguntas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final perguntas = await _repository.buscarTodasPerguntas();
      
      if (!mounted) return;

      setState(() {
        _perguntas = perguntas.map((p) => {
          'pergunta': p.titulo,
          'resposta': p.conteudo,
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro ao carregar perguntas: $e';
          _isLoading = false;
        });
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
          "Perguntas Frequentes",
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
                        final item = _perguntas[index];
                        final isExpanded = _expandedIndex == index;

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
                                title: Text(
                                  item['pergunta'] ?? 'Pergunta sem título',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4D675A),
                                    fontSize: 16,
                                  ),
                                ),
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
                                },
                              ),
                              if (isExpanded)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: Text(
                                    item['resposta'] ?? 'Resposta não disponível',
                                    style: const TextStyle(
                                      color: Color(0xFF4D675A),
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}