import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Projeto_Viveri/pages/erro/feedback_screen.dart'; 
import 'package:Projeto_Viveri/pages/FAQ/criar_pergunta_page.dart';

class Evento {
  final int id;
  final String nome;
  final String descricao;
  final String data;
  final String horario;
  final String link;
  final String local;
  final String categoria;
  final String? categoriaSecundaria;
  final String faixaEtaria;
  final String faixaEtariaDisplay;
  final String organizador;
  final String situacao;
  final int? reservasCount;
  final int? interessadosCount;
  final double? latitude;
  final double? longitude;

  Evento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.link,
    required this.local,
    required this.categoria,
    this.categoriaSecundaria,
    required this.faixaEtaria,
    required this.faixaEtariaDisplay,
    required this.organizador,
    required this.situacao,
    this.reservasCount,
    this.interessadosCount,
    this.latitude,
    this.longitude,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    final id = json['id_evento'] ?? json['id'] ?? 0;
    final horario = json['horario'] ?? '';
    final data = json['data'] ?? '';

    final categoriaNome = (json['categoria'] is Map)
        ? (json['categoria']['nome'] ?? 'Sem categoria')
        : (json['categoria']?.toString() ?? 'Sem categoria');

    final categoriaSecundariaNome = (json['categoria_secundaria'] is Map)
        ? (json['categoria_secundaria']['nome'])
        : (json['categoria_secundaria']?.toString());

    final localNome = (json['local'] is Map)
        ? (json['local']['nome'] ?? 'Local não definido')
        : (json['local']?.toString() ?? 'Local não definido');

    double? lat;
    double? lng;
    if (json['local'] is Map) {
      final l = json['local'];
      lat = (l['latitude'] != null) ? double.tryParse(l['latitude'].toString()) : null;
      lng = (l['longitude'] != null) ? double.tryParse(l['longitude'].toString()) : null;
    }
    return Evento(
      id: id,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      data: data.toString(),
      horario: horario.toString(),
      link: json['link'] ?? '',
      local: localNome,
      categoria: categoriaNome,
      categoriaSecundaria: categoriaSecundariaNome,
      faixaEtaria: json['faixa_etaria'] ?? 'LIVRE',
      faixaEtariaDisplay: json['faixa_etaria_display'] ?? 'Livre',
      organizador: json['usuario_nome'] ?? 'Organizador não definido',
      situacao: json['situacao_display'] ?? 'Não Iniciado',
      reservasCount: json['reservas_count'] ?? 0,
      interessadosCount: json['interessados_count'] ?? 0,
      latitude: lat,
      longitude: lng,
    );
  }

  String get dataFormatada {
    try {
      final dt = DateTime.parse(data);
      return DateFormat('EEEE, d \'de\' MMMM', 'pt_BR').format(dt);
    } catch (e) {
      return data;
    }
  }

  String get horaFormatada {
    try {
      final parts = horario.split(':');
      if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
      return horario;
    } catch (e) {
      return horario;
    }
  }

  String get categoriaFormatada {
    if (categoriaSecundaria != null && categoriaSecundaria!.isNotEmpty) {
      return '$categoria, $categoriaSecundaria';
    }
    return categoria;
  }

  String get avisoFaixaEtaria {
    switch (faixaEtaria) {
      case 'MAIOR_18':
        return 'Proibida a entrada de menores de 18 anos, mesmo acompanhados dos pais e/ou responsáveis.';
      case 'MAIOR_21':
        return 'Proibida a entrada de menores de 21 anos, mesmo acompanhados dos pais e/ou responsáveis.';
      case 'MAIOR_16':
        return 'Proibida a entrada de menores de 16 anos, mesmo acompanhados dos pais e/ou responsáveis.';
      case 'MAIOR_12':
        return 'Proibida a entrada de menores de 12 anos, mesmo acompanhados dos pais e/ou responsáveis.';
      default:
        return 'Evento aberto para todas as idades';
    }
  }
}

class EventoUnico extends StatefulWidget {
  final int eventoId;

  const EventoUnico({super.key, required this.eventoId});

  @override
  State<EventoUnico> createState() => _EventoUnicoState();
}

class _EventoUnicoState extends State<EventoUnico> {
  Evento? remoteEvento;
  bool loadingEvento = false;
  bool isFavorito = false;
  late SharedPreferences prefs;
  GoogleMapController? mapController;
  final LatLng _initialPosition = const LatLng(-23.55052, -46.633308);



  @override
  void initState() {
    super.initState();
    _loadFavorito();
    fetchRemoteEvento();
  }

  Future<void> _loadFavorito() async {
    prefs = await SharedPreferences.getInstance();
    isFavorito = prefs.getBool('favorito_${widget.eventoId}') ?? false;
    setState(() {});
  }

  Future<void> _setFavorito(bool v) async {
    await prefs.setBool('favorito_${widget.eventoId}', v);
    setState(() => isFavorito = v);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(v
              ? 'Adicionado aos favoritos'
              : 'Removido dos favoritos')),
    );
  }

  void _shareEvento() {
    final url = remoteEvento?.link ?? '';
    if (url.isNotEmpty) Share.share('${remoteEvento!.nome}\n$url');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> fetchRemoteEvento() async {
    setState(() => loadingEvento = true);
    try {
      final url =
          Uri.parse('http://10.0.2.2:8000/api/eventos/${widget.eventoId}/');
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(resp.body);
        setState(() => remoteEvento = Evento.fromJson(data));
      } else {
        setState(() => remoteEvento = null);
      }
    } catch (e) {
      setState(() => remoteEvento = null);
    } finally {
      setState(() => loadingEvento = false);
    }
  }

  Future<void> _inscrever() async {
    if (remoteEvento == null) return;
    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/reservas/');
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'evento': remoteEvento!.id,
          'quantidade_ingressos': 1,
        }),
      );
      if (resp.statusCode == 201) {
        setState(() {
          remoteEvento = Evento(
            id: remoteEvento!.id,
            nome: remoteEvento!.nome,
            descricao: remoteEvento!.descricao,
            data: remoteEvento!.data,
            horario: remoteEvento!.horario,
            link: remoteEvento!.link,
            local: remoteEvento!.local,
            categoria: remoteEvento!.categoria,
            categoriaSecundaria: remoteEvento!.categoriaSecundaria,
            faixaEtaria: remoteEvento!.faixaEtaria,
            faixaEtariaDisplay: remoteEvento!.faixaEtariaDisplay,
            organizador: remoteEvento!.organizador,
            situacao: remoteEvento!.situacao,
            reservasCount: (remoteEvento?.reservasCount ?? 0) + 1,
            interessadosCount: remoteEvento?.interessadosCount,
            latitude: remoteEvento?.latitude,    // preserved
            longitude: remoteEvento?.longitude,  // preserved
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inscrito com sucesso!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Erro ao se inscrever')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erro na conexão')));
    }
  }

  Widget _buildHeader() {
    final title = remoteEvento?.nome ?? "Evento";
    final address = remoteEvento?.local ?? "Endereço não definido";
    final dateLine = (remoteEvento != null)
        ? remoteEvento!.dataFormatada
        : "Data não definida";
    final timeLine = (remoteEvento != null)
        ? "Horário: ${remoteEvento!.horaFormatada}"
        : "Horário não definido";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            width: 40,
            height: 40,
            color: Colors.white30,
            padding: const EdgeInsets.all(8.0)),
        const SizedBox(width: 12),
        Row(
          children: [
            const SizedBox(width: 8),
            if (remoteEvento != null) ...[
              _TagExemplo(texto: remoteEvento!.categoria),
              const SizedBox(width: 6),
              if (remoteEvento!.categoriaSecundaria != null)
                _TagExemplo(texto: remoteEvento!.categoriaSecundaria!),
            ]
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(address, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                      remoteEvento?.faixaEtariaDisplay ?? "+18",
                      style: const TextStyle(
                          fontSize: 14, color: Colors.white)),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateLine,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black)),
                    Text(timeLine,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black)),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(isFavorito ? Icons.favorite : Icons.favorite_border,
                    color: isFavorito ? Colors.red : null,
                    size: 20),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.share, size: 26),
              onPressed: () => _shareEvento(),
            ),
            IconButton(
              icon: Icon(isFavorito ? Icons.favorite : Icons.favorite_border,
                  color: isFavorito ? Colors.red : null),
              onPressed: () => _setFavorito(!isFavorito),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(top: 12, right: 12),
                  child: const Icon(Icons.arrow_back, size: 26)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF69796A),
        toolbarHeight: 80,
        title: _buildHeader(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _inscrever();
        },
        backgroundColor: Colors.amber[400],
        child: Text(
            (remoteEvento?.organizador.isNotEmpty ?? false)
                ? remoteEvento!.organizador[0].toUpperCase()
                : 'J'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (remoteEvento != null)
                Text(remoteEvento!.avisoFaixaEtaria,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red))
              else
                const Text(
                    "Proibida a entrada de menores de 18 anos, mesmo acompanhados dos pais e/ou responsáveis.",
                    style: TextStyle(fontSize: 16)),
              const Divider(color: Colors.grey, thickness: 1, height: 20),
              if (remoteEvento != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Categorias: ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(remoteEvento!.categoriaFormatada,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 16),
                  ],
                ),
              const Text("Descrição do Evento:",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 5),
              if (loadingEvento)
                const Center(child: CircularProgressIndicator())
              else if (remoteEvento != null)
                Text(remoteEvento!.descricao,
                    style: const TextStyle(fontSize: 16, color: Colors.black))
              else
                const Text("Descrição indisponível.",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              if (remoteEvento?.link != null &&
                  (remoteEvento!.link.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Para mais informações:",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.tryParse(remoteEvento!.link);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        child: Text(remoteEvento!.link,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
              const Divider(color: Colors.grey, thickness: 1, height: 20),
              const Text("Onde vai rolar?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              if (remoteEvento != null)
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        remoteEvento?.latitude ?? _initialPosition.latitude,
                        remoteEvento?.longitude ?? _initialPosition.longitude,
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('evento'),
                        position: LatLng(
                          remoteEvento?.latitude ?? _initialPosition.latitude,
                          remoteEvento?.longitude ?? _initialPosition.longitude,
                        ),
                        infoWindow: InfoWindow(
                          title: remoteEvento!.nome,
                          snippet: remoteEvento!.local,
                        ),
                      ),
                    },
                  ),
                )
              else
                Container(
                  width: 410,
                  height: 130,
                  color: Colors.grey,
                  child: const Center(
                    child: Text("Mapa indisponível",
                        style: TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Positioned(
                          left: 0,
                          child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[400])),
                      Positioned(
                          left: 15,
                          child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[500])),
                      Positioned(
                          left: 30,
                          child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "+ ${remoteEvento?.reservasCount ?? 60} pessoas já assistiram",
                          style: const TextStyle(fontSize: 16)),
                      Text(
                          "+ ${remoteEvento?.interessadosCount ?? 100} pessoas interessadas",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Text("Organizador",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.orange[400],
                        child: Text(
                          (remoteEvento?.organizador.isNotEmpty ?? false)
                              ? remoteEvento!.organizador[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green[600],
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.check,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          remoteEvento?.organizador ??
                              "Organizador não definido",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          // Navegar para perfil do organizador
                        },
                        child: const Text("Ver perfil",
                            style: TextStyle(
                                fontSize: 12, color: Colors.blue)),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _inscrever(),
                      child: Container(
                        width: 250,
                        height: 55,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text("INSCREVER-SE",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.yellow[600],
                            shape: BoxShape.circle),
                        child: const Center(
                            child: Text("!",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.help_outline,
                          size: 20, color: Colors.grey),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const CriarPerguntaPage(),
                          ));
                        },
                        child: const Text("FAQ",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      const Icon(Icons.warning, size: 16, color: Colors.grey),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ));
                        },
                        child: const Text("Algo errado?",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagExemplo extends StatelessWidget {
  final String texto;

  const _TagExemplo({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Text(texto,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}
