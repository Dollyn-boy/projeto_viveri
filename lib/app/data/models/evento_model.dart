class Evento {
  final int id;
  final String? titulo;

  Evento({required this.id, this.titulo});

  factory Evento.fromJson(dynamic j) {
    if (j == null) throw ArgumentError('EventoRef json null');
    if (j is int) return Evento(id: j);
    final Map<String, dynamic> m = (j as Map).cast<String, dynamic>();
    return Evento(
      id: m['id'] ?? 0,
      titulo: m['titulo'] ?? m['nome'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (titulo != null) 'titulo': titulo,
      };
}