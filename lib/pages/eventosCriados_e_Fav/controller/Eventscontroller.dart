import 'package:flutter/material.dart';
import 'package:viveri/app/data/evento.dart';

class AppController extends ChangeNotifier {
  // Índice da BottomNavigationBar

  int _selectedIndex = 1; // Começa em Eventos (índice 1, por exemplo)
  int get selectedIndex => _selectedIndex;

  // Controle de visibilidade da NavBar
  bool _showNavBar = true;
  bool get showNavBar => _showNavBar;
  // Método auxiliar para verificar se um evento já é favorito (útil para o ícone de coração)
  bool isFavorite(EventoCriado evento) {
    return _eventosFavoritados.contains(evento);
  }

  //EXEMPLO DE LISTA DE EVENTOS FAVORITADOS
  final List<EventoCriado> _eventosFavoritados = [];
  
  List<EventoCriado> get eventosFavoritados => _eventosFavoritados;
  void setIndex(int index) {
    _selectedIndex = index;
    // Garante que a barra principal volte a ser visível ao trocar de aba principal.
    _showNavBar = true;
    notifyListeners();
  }

  void toggleNavBar(bool isVisible) {
    if (_showNavBar != isVisible) {
      _showNavBar = isVisible;
      notifyListeners();
    }
  }

  void toggleFavorite(EventoCriado evento) {
    if (_eventosFavoritados.contains(evento)) {
      _eventosFavoritados.remove(evento); // Remove se já estiver na lista
    } else {
      _eventosFavoritados.add(evento); // Adiciona se não estiver
    }
    notifyListeners(); // Avisa os widgets (tela de Favoritados) para atualizar
  }
}
