

class EventoCriado {
  final int id;
  final String image;
  final String nome;
  final String descricao;
  final DateTime data;
  final DateTime horaInicio;
  final DateTime horaFim;
  final String link;
  final String local;
  final String usuario; 
  // final Map<String, dynamic> usuario; //para linkar à API
  // final Map<String, dynamic> local; //para linkar à API
  
  EventoCriado ({
    required this.id,
    required this.image,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.link,
    required this.local,
    required this.usuario
  });
}



