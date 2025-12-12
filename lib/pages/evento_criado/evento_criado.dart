import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
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
  final String faixaEtariaDisplay;
  final String organizador;

  Evento({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.link,
    required this.local,
    required this.categoria,
    required this.faixaEtariaDisplay,
    required this.organizador,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['id_evento'] ?? 0;
    final horario = json['horario'] ?? json['horário'] ?? (json['time'] ?? '');
    final data = json['data'] ?? json['date'] ?? '';

    final localNome = (json['local'] is Map)
        ? (json['local']['nome'] ?? '')
        : (json['local']?.toString() ?? '');

    final categoriaNome = (json['categoria'] is Map)
        ? (json['categoria']['nome'] ?? 'Sem categoria')
        : (json['categoria']?.toString() ?? 'Sem categoria');

    return Evento(
      id: id,
      nome: json['nome'] ?? json['title'] ?? '',
      descricao: json['descricao'] ?? json['description'] ?? '',
      data: data.toString(),
      horario: horario.toString(),
      link: json['link'] ?? '',
      local: localNome,
      categoria: categoriaNome,
      faixaEtariaDisplay: json['faixa_etaria_display'] ?? 'Livre',
      organizador: json['usuario_nome'] ?? 'Organizador não definido',
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
}

class EventoCriado extends StatefulWidget {
  final int eventoId;

  const EventoCriado({super.key, required this.eventoId});

  @override
  State<EventoCriado> createState() => _EventoCriadoState();
}

class _EventoCriadoState extends State<EventoCriado> {
  Evento? remoteEvento;
  bool loadingEvento = false;

  @override
  void initState() {
    super.initState();
    fetchRemoteEvento();
  }

  Future<void> fetchRemoteEvento() async {
    setState(() => loadingEvento = true);

    try {
      final url = Uri.parse(
          'http://10.0.2.2:8000/api/eventos/${widget.eventoId}/');
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

  void _shareEvento() {
    final url = remoteEvento?.link ?? '';
    if (url.isNotEmpty) Share.share('${remoteEvento!.nome}\n$url');
  }

  Widget _buildHeader() {
    final title = remoteEvento?.nome ?? "Evento criado";
    final address = remoteEvento?.local ?? "Endereço indefinido";
    final dateLine = (remoteEvento != null)
        ? remoteEvento!.dataFormatada
        : "Data não informada";
    final timeLine = (remoteEvento != null)
        ? "Horário: ${remoteEvento!.horaFormatada}"
        : "Horário não informado";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: 40,
          color: Colors.white30,
        ),
        const SizedBox(width: 12),
        Row(
          children: const [
            _TagExemplo(texto: "Criado"),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(address, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    remoteEvento?.faixaEtariaDisplay ?? "+18",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
                const Icon(Icons.favorite_border, size: 20),
              ],
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.edit, size: 26),
          onPressed: () {
            // Navegar para edição do evento
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, size: 26),
          onPressed: () => _shareEvento(),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 12, right: 12),
            child: const Icon(Icons.arrow_back, size: 26),
          ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Seu evento foi criado com sucesso!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1),
              const Text("Tipo de evento:",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (remoteEvento != null)
                Text(remoteEvento!.categoria,
                    style: const TextStyle(fontSize: 14))
              else
                const Text("Tipo não definido",
                    style: TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Text(
                "Proibida a entrada de menores de 18 anos, mesmo acompanhados dos pais e/ou responsáveis.",
                style: TextStyle(fontSize: 14, color: Colors.red[700]),
              ),
              const Divider(thickness: 1),
              const Text("Descrição do evento:",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (loadingEvento)
                const Center(child: CircularProgressIndicator())
              else if (remoteEvento != null)
                Text(remoteEvento!.descricao,
                    style: const TextStyle(fontSize: 16))
              else
                const Text("Descrição indisponível.",
                    style: TextStyle(fontSize: 16)),
              if (remoteEvento?.link != null &&
                  (remoteEvento!.link.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
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
              const Divider(thickness: 1),
              const Text("Onde vai rolar?",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                width: 410,
                height: 130,
                color: Colors.grey,
                child: const Center(
                  child: Text("Extensão do maps.com"),
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
                    children: const [
                      Text("+ 60 pessoas já viram",
                          style: TextStyle(fontSize: 16)),
                      Text("+ 100 pessoas interessadas",
                          style: TextStyle(fontSize: 16)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),
              const Text("Organizador",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
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
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
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
                    ],
                  )
                ],
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
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}