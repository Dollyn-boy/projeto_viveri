import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viveri/pages/eventosCriados_e_Fav/controller/Eventscontroller.dart'; // Importe seu controller
import 'package:viveri/pages/eventosCriados_e_Fav/EventosCriadosFavoritos.dart';

class MainEventsPage extends StatelessWidget {
  const MainEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AppController>(context);

    final List<Widget> pages = [
      const Center(child: Text("Home")),  //índice 0
      const EventosCriadosPage(),         // índice 1
      const Center(child: Text("Ingressos")), //índice 2
      const Center(child: Text("Perfil")),    //índice 3
    ];

    return Scaffold(
      // O IndexedStack preserva o estado das páginas quando você troca de aba
      body: IndexedStack(
        index: controller.selectedIndex,
        children: pages,
      ),
      //se showNavBar for false, a barra some (height: 0)
      bottomNavigationBar: controller.showNavBar
          ? BottomNavigationBar(
              currentIndex: controller.selectedIndex,
              onTap: controller.setIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFFF4B134),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Eventos'),
                BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Ingressos'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
              ],
            )
          : null, // Remove a barra se for null
    );
  }
}