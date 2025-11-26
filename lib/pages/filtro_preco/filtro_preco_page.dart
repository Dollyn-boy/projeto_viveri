import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/api_constants.dart';

class FiltroPrecoPage extends StatefulWidget {
  const FiltroPrecoPage({super.key});

  @override
  State<FiltroPrecoPage> createState() => _FiltroPrecoPageState();
}

class _FiltroPrecoPageState extends State<FiltroPrecoPage> {
  String? precoSelecionado;
  bool _mostrarFiltro = true;
  bool _isLoading = false;
  String? _erroMinMax;
  List<dynamic> eventosEncontrados = [];

  final _searchCtrl = TextEditingController();
  final _minPriceCtrl = TextEditingController();
  final _maxPriceCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // Limpa a seleção visual (apenas desmarca)
  void _limparFiltros() {
    setState(() {
      precoSelecionado = null;
      _minPriceCtrl.clear();
      _maxPriceCtrl.clear();
      _erroMinMax = null; // Remove mensagem de erro se houver
    });
  }

  double? _parseMoeda(String text) {
    if (text.isEmpty) return null;
    final limpo = text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim();
    return double.tryParse(limpo);
  }

  Future<void> _executarFiltro() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      eventosEncontrados = [];
    });

    final Uri url = Uri.parse(ApiConstants.eventos);

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        final termo = _searchCtrl.text.trim().toLowerCase();
        final minVal = _parseMoeda(_minPriceCtrl.text);
        final maxVal = _parseMoeda(_maxPriceCtrl.text);

        data = data.where((evento) {
          // 1. Filtro de Texto
          final nome = (evento['nome'] ?? '').toString().toLowerCase();
          final local = (evento['local'] ?? '').toString().toLowerCase();
          final matchTexto = termo.isEmpty || nome.contains(termo) || local.contains(termo);

          // 2. Filtro de Preço
          final preco = double.tryParse((evento['preco'] ?? '0').toString()) ?? 0.0;
          bool matchPreco = true;

          if (precoSelecionado == "Grátis") {
            matchPreco = (preco == 0);
          } else if (precoSelecionado == "Pago") {
            matchPreco = (preco > 0);
          } else {
            // Lógica Faixa de Preço (Se não selecionado, assume true para mostrar tudo na busca por texto)
            if (minVal != null && preco < minVal) matchPreco = false;
            if (maxVal != null && preco > maxVal) matchPreco = false;
          }

          return matchTexto && matchPreco;
        }).toList();

        setState(() {
          eventosEncontrados = data;
          _mostrarFiltro = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data.length} eventos encontrados.")),
        );
      } else {
        throw Exception("Status ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro de conexão ou falha na busca.")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _validarEFiltrar({bool exigirSelecao = false}) {
    
    if (!_mostrarFiltro) {
      _executarFiltro();
      return;
    }

    if (exigirSelecao) {
      final temOpcaoFixa = precoSelecionado != null;
      final temFaixa = _minPriceCtrl.text.isNotEmpty || _maxPriceCtrl.text.isNotEmpty;

      if (!temOpcaoFixa && !temFaixa) {
        setState(() => _erroMinMax = 'Selecione uma opção para filtrar.');
        return;
      }
    }

    final min = _parseMoeda(_minPriceCtrl.text) ?? 0;
    final max = _parseMoeda(_maxPriceCtrl.text);

    if (min < 0 || (max != null && max < 0)) {
      setState(() => _erroMinMax = 'Valores positivos apenas.');
      return;
    }
    if (max != null && min > max) {
      setState(() => _erroMinMax = 'Mínimo maior que Máximo.');
      return;
    }

    if (_formKey.currentState?.validate() ?? true) {
      setState(() => _erroMinMax = null);
      _executarFiltro();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFD9E2D1),
        appBar: AppBar(
          backgroundColor: const Color(0xFF6E7E67),
          elevation: 0,
          centerTitle: true,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Color(0xFFF1C40F),
                  unselectedLabelColor: Color(0xFFC8D5C0),
                  labelColor: Color(0xFFF1C40F),
                  tabs: [Tab(text: "Eventos"), Tab(text: "Locais")],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _searchCtrl,
                            onSubmitted: (_) => _validarEFiltrar(exigirSelecao: false), 
                            decoration: const InputDecoration(
                              hintText: "Buscar...",
                              border: OutlineInputBorder(borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              filled: true,
                              fillColor: Color(0xFFC8D5C0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      InkWell(
                        onTap: () => _validarEFiltrar(exigirSelecao: false),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.search, color: Color(0xFFF1C40F)),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _mostrarFiltro = !_mostrarFiltro),
                        child: const Icon(Icons.filter_list, color: Color(0xFFF1C40F), size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: SingleChildScrollView(
                child: _mostrarFiltro
                    ? Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8D5C0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CABEÇALHO COM TÍTULO E BOTÃO LIMPAR
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Preço", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  // Só mostra o botão se houver algo selecionado
                                  if (precoSelecionado != null || _minPriceCtrl.text.isNotEmpty || _maxPriceCtrl.text.isNotEmpty)
                                    TextButton(
                                      onPressed: _limparFiltros,
                                      child: const Text("Limpar", style: TextStyle(color: Color(0xFF4D675A), fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              _opcao("Grátis"),
                              _opcao("Pago"),
                              const SizedBox(height: 16),
                              _rangePreco(),
                              const SizedBox(height: 24),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4D675A),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                  onPressed: () => _validarEFiltrar(exigirSelecao: true),
                                  child: const Text("FILTRAR", style: TextStyle(color: Color(0xFFF1C40F), fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : _isLoading
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text("Resultados: ${eventosEncontrados.length}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ...eventosEncontrados.map((e) => ListTile(
                                    title: Text(e['nome'] ?? 'Sem nome'),
                                    subtitle: Text("Local: ${e['local'] ?? 'N/A'} - R\$ ${e['preco'] ?? '0.00'}"),
                                  ))
                            ],
                          ),
              ),
            ),
            const Center(child: Text("Conteúdo da Aba Locais")),
          ],
        ),
      ),
    );
  }

  Widget _opcao(String texto) {
    final isSelected = precoSelecionado == texto;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              precoSelecionado = texto;
              _minPriceCtrl.clear();
              _maxPriceCtrl.clear();
              _erroMinMax = null;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            color: isSelected ? const Color(0xFFD9E2D1) : Colors.transparent,
            child: Text(texto, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF4D675A) : Colors.black)),
          ),
        ),
        if (!isSelected) const Divider(),
      ],
    );
  }

  Widget _rangePreco() {
    final isRange = _minPriceCtrl.text.isNotEmpty || _maxPriceCtrl.text.isNotEmpty || precoSelecionado == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Faixa de Preço", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 150, child: _campoPreco(label: "Mínimo (R\$)", controller: _minPriceCtrl)),
            const SizedBox(width: 16),
            SizedBox(width: 150, child: _campoPreco(label: "Máximo (R\$)", controller: _maxPriceCtrl)),
          ],
        ),
        if (_erroMinMax != null) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text(_erroMinMax!, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold))),
        Divider(color: isRange && precoSelecionado == null ? const Color(0xFF4D675A) : null, thickness: isRange && precoSelecionado == null ? 2 : 1),
      ],
    );
  }

  Widget _campoPreco({required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, RealInputFormatter()],
          decoration: const InputDecoration(filled: true, fillColor: Color(0xFFD9E2D1), border: OutlineInputBorder(borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
          onTap: () => setState(() { precoSelecionado = null; _erroMinMax = null; }),
          validator: (value) {
            if ((_parseMoeda(value ?? '') ?? 0) < 0) return 'Inválido';
            return null;
          },
        ),
      ],
    );
  }
}

class RealInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    
    double value = double.parse(newValue.text.replaceAll(RegExp('[^0-9]'), '')) / 100;
    final formatter = value.toStringAsFixed(2).replaceAll('.', ',');
    String newText = "R\$ $formatter";
    
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}