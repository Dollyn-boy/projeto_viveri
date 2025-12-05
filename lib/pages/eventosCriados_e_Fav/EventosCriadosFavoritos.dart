import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:viveri/app/data/evento.dart';
import 'package:viveri/app/data/evento.dart';
import 'package:viveri/pages/eventosCriados_e_Fav/controller/Eventscontroller.dart';
import 'package:viveri/pages/eventosCriados_e_Fav/widgets/app_bar.dart';

class EventosCriadosPage extends StatefulWidget {
  const EventosCriadosPage({super.key});

  @override
  State<EventosCriadosPage> createState() => _EventosCriadosPageState();
}

class _EventosCriadosPageState extends State<EventosCriadosPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dados de Exemplo
  final List<EventoCriado> _eventosCriados = [
    EventoCriado(
      id: 1,
      image: 'https://cdn.pixabay.com/photo/2015/11/19/21/10/festa-1052601_1280.jpg',
      nome: 'Festa da Salsicha',
      descricao: 'Uma festa deliciosa!',
      data: DateTime.utc(2024, 04, 01),
      horaInicio: DateTime.utc(0, 0, 0, 15, 30),
      horaFim: DateTime.utc(0, 0, 0, 00, 00),
      link: 'http://example.com',
      local: 'Parque Central',
      usuario: 'Organizador A',
    ),
    
  ];

// EventosCriadosPage State (Página de Abas)

@override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AppController>(context, listen: false).toggleNavBar(true);
    });
  }

  
  // O seu listener permanece o mesmo, controlando a troca entre as abas:
  void _handleTabSelection() {
    if (_tabController.indexIsChanging || _tabController.animation!.value == _tabController.index.toDouble()) {
      final controller = Provider.of<AppController>(context, listen: false);
      
      // Se for a aba 1 (Criados), esconde. Se for 0 (Favoritados), mostra.
      if (_tabController.index == 1) {
        controller.toggleNavBar(false);
      } else {
        controller.toggleNavBar(true);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Método auxiliar para construir os itens da lista
  Widget _buildEventListItem(BuildContext context, EventoCriado evento) {
    final String formattedDate = DateFormat('dd/MM').format(evento.data);
    final String formattedTime = '${DateFormat('HH:mm').format(evento.horaInicio)} - ${DateFormat('HH:mm').format(evento.horaFim)}';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDCECDC),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        // child: InkWell(
        //    onTap: () {
        //      Navigator.push(
        //        context,
        //        MaterialPageRoute(builder: (context) => DetailsEvent(evento: evento)), //TODO colocar a rota de detalhes de eventos
        //      );
        //    },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80, height: 80,
                    color: const Color(0xFF8F9E8B),
                    child: Image.network(
                      evento.image,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(evento.nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(formattedDate, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                      Text(formattedTime, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    const Color corFundoPagina = Color(0xFFD0E0D0);
    

     final controller = Provider.of<AppController>(context); 

    // Construtor a lista de eventos CRIADOS 
    final createdEventsList = ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), 
      itemCount: _eventosCriados.length,
      itemBuilder: (context, index) {
        return _buildEventListItem(context, _eventosCriados[index]);
      },
    );

    //Construtor da lista de FAVORITADOS.
    final favoritosList = ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: controller.eventosFavoritados.length,
      itemBuilder: (context, index) {
        return _buildEventListItem(context, controller.eventosFavoritados[index]);
      },
    );

    return Scaffold(
      backgroundColor: corFundoPagina,
      appBar: AppBarEvento(
        tabController: _tabController,
        onBack: () {
          final controller = Provider.of<AppController>(context, listen: false);
          controller.setIndex(0);
        }
      ),

        body: TabBarView(
        controller: _tabController,
        children: [
          // --- ABA 1: Favoritados ---
          controller.eventosFavoritados.isEmpty
              ? Center(child: Text("Nenhum evento favoritado ainda."))
              : favoritosList,

          // --- ABA 2: Criados ---
          Stack(
            children: [
              createdEventsList,
              
              // Botão "Criar Evento" 
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                //  Resto do Container e Botão 
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4B134),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      //  Navigator.push(
                      //    context,
                      //    //TODO linkar a página de criar evento
                      //    MaterialPageRoute(builder: (context) => const CriarEventoPage()), 
                      //  );
                    },
                    child: const Text(
                      "Criar evento",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}