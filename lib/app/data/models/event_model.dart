class EventModel {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String link;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final int organizerId;
  final String organizerName;
  final String organizerPhotoUrl;
  final String ageRating;
  final String photoUrl;
  final List<String> tags;
  final int totalSold;
  final String typeEvent;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.link,
    required this.locationName,
    this.latitude,
    this.longitude,
    required this.organizerId,
    required this.organizerName,
    required this.organizerPhotoUrl,
    required this.ageRating,
    required this.photoUrl,
    required this.tags,
    required this.totalSold,
    required this.typeEvent,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final eventData = json['evento'];
    final localData = json['local'];
    final userData = json['usuario'];

    return EventModel(
      id: eventData['id'],
      title: eventData['nome'] ?? 'Sem TÃ­tulo',
      description: eventData['descricao'] ?? '',
      date: DateTime.tryParse(eventData['data']) ?? DateTime.now(),
      link: eventData['link'] ?? '',

      locationName: localData['nome'] ?? 'Local desconhecido',
      latitude: localData['latitude'] != null
          ? double.tryParse(localData['latitude'].toString())
          : null,
      longitude: localData['longitude'] != null
          ? double.tryParse(localData['longitude'].toString())
          : null,

      organizerId: userData['id'],
      organizerName: userData['nome'] ?? 'Organizador',
      organizerPhotoUrl: userData['foto'] ?? '',
      ageRating: eventData['faixa_etaria'] ?? 'Livre',
      photoUrl: eventData['foto'] ?? '',
      tags: List<String>.from(eventData['tags'] ?? []),
      totalSold: eventData['total_ingressos_vendidos'] ?? 0,
      typeEvent: eventData['tipo'] ?? "livre",
    );
  }
}
