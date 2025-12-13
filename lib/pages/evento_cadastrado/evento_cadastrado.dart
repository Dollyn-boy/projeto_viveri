import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:viveri/app/data/models/event_model.dart';
import 'package:viveri/app/services/event_service.dart';

// Use isto se você for usar Google Map nativo
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsPage extends StatefulWidget {
  final int eventId;

  const EventDetailsPage({super.key, required this.eventId});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Future<EventModel> _eventFuture;

  final Color bgLight = const Color(0xFFDCE6DD);
  final Color bgDark = const Color(0xFF6A7B6E);
  final Color textDark = const Color(0xFF2C332E);
  final Color badgeColor = const Color(0xFFB85C5C);
  final Color safeColor = const Color(0xFF5CB85C);

  @override
  void initState() {
    super.initState();
    _eventFuture = EventService().fetchEventDetails(widget.eventId);
  }

  // TODO: arrumar com a parte
  String _getStaticMapUrl(double lat, double lng) {
    const String apiKey = "YOUR_STREET_MAPS_API_KEY";
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=15&size=600x400&markers=color:red%7C$lat,$lng&key=$apiKey";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgLight,

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          color: bgLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/faq'),
                icon: const Icon(Icons.help_outline, color: Colors.white),
                label: const Text(
                  "FAQ - Dúvidas Frequentes",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgDark,
                  padding: EdgeInsets.symmetric(vertical: height * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.012),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReportDialog(context),
                icon: Icon(Icons.warning_amber_rounded, color: badgeColor),
                label: Text(
                  "Algo deu errado",
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: badgeColor),
                  padding: EdgeInsets.symmetric(vertical: height * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: FutureBuilder<EventModel>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6A7B6E)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(width * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "Erro ao carregar evento:\nCertifique-se de que o servidor Django está rodando.\n\nErro: ${snapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Evento não encontrado"));
          }

          return _buildPageContent(context, snapshot.data!, width, height);
        },
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Reportar Problema", style: TextStyle(color: textDark)),
        content: const Text(
          "Você encontrou um erro nas informações deste evento?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Obrigado! O problema foi reportado."),
                  backgroundColor: bgDark,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: badgeColor),
            child: const Text(
              "Reportar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    EventModel event,
    double width,
    double height,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: height * 0.20,
                width: double.infinity,
                color: bgDark,
                padding: EdgeInsets.only(
                  top: height * 0.06,
                  left: width * 0.04,
                  right: width * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFFF0B948),
                        size: width * 0.06,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Icon(
                      Icons.share,
                      color: Color(0xFFF0B948),
                      size: width * 0.06,
                    ),
                  ],
                ),
              ),

              // Card superior
              Container(
                margin: EdgeInsets.only(top: height * 0.12),
                decoration: BoxDecoration(
                  color: bgLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Row(
                    children: [
                      // FOTO DO EVENTO RESPONSIVA
                      Container(
                        width: width * 0.25,
                        height: width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                          image: event.photoUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(event.photoUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: event.photoUrl.isEmpty
                            ? Icon(
                                Icons.image,
                                size: width * 0.10,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      SizedBox(width: width * 0.04),

                      // INFORMAÇÕES DO EVENTO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            Text(
                              event.locationName,
                              style: TextStyle(
                                color: textDark.withOpacity(0.7),
                                fontSize: width * 0.03,
                              ),
                            ),
                            SizedBox(height: height * 0.01),

                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: event.ageRating.contains("18")
                                        ? badgeColor
                                        : safeColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    event.ageRating,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * 0.025,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                Text(
                                  "${event.date.day}/${event.date.month}/${event.date.year}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                    fontSize: width * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TAGS
                if (event.tags.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: event.tags
                          .map(
                            (tag) => Padding(
                              padding: EdgeInsets.only(right: width * 0.02),
                              child: _buildTag(tag, width),
                            ),
                          )
                          .toList(),
                    ),
                  )
                else
                  const Text("Sem tags", style: TextStyle(color: Colors.grey)),

                SizedBox(height: height * 0.03),

                _buildInfoText(
                  "Comprado:",
                  "${event.totalSold} ingresso(s)",
                  width,
                ),
                _buildInfoText("Tipo:", event.typeEvent, width),

                SizedBox(height: height * 0.02),

                Text(
                  event.ageRating.contains("18")
                      ? "Proibida a entrada de menores de 18 anos."
                      : "Classificação Indicativa: ${event.ageRating}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textDark,
                    fontSize: width * 0.035,
                  ),
                ),

                Divider(height: height * 0.04),

                Text(
                  "Descrição do evento:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: width * 0.034,
                    height: 1.3,
                    color: textDark,
                  ),
                ),

                SizedBox(height: height * 0.03),

                Text(
                  "Local do Evento",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                  ),
                ),
                SizedBox(height: height * 0.015),

                SizedBox(
                  height: height * 0.28,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (event.latitude != null && event.longitude != null)
                        ? (kIsWeb ||
                                  defaultTargetPlatform ==
                                      TargetPlatform.android ||
                                  defaultTargetPlatform == TargetPlatform.iOS)
                              ? GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      event.latitude!,
                                      event.longitude!,
                                    ),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId(
                                        'event_location',
                                      ),
                                      position: LatLng(
                                        event.latitude!,
                                        event.longitude!,
                                      ),
                                      infoWindow: InfoWindow(
                                        title: event.locationName,
                                      ),
                                    ),
                                  },
                                )
                              : Image.network(
                                  _getStaticMapUrl(
                                    event.latitude!,
                                    event.longitude!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text(
                                "Mapa indisponível (sem coordenadas)",
                              ),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                // ORGANIZADOR
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Organizador",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.045,
                        ),
                      ),
                      SizedBox(height: height * 0.015),

                      // foto organizador
                      Container(
                        width: width * 0.22,
                        height: width * 0.22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange[300],
                          image: event.organizerPhotoUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(event.organizerPhotoUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: event.organizerPhotoUrl.isEmpty
                            ? Icon(
                                Icons.person,
                                size: width * 0.12,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      SizedBox(height: height * 0.01),

                      Text(
                        event.organizerName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.045,
                        ),
                      ),
                      Text(
                        "ID: ${event.organizerId}",
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.01,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6A7B6E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: width * 0.03),
      ),
    );
  }

  Widget _buildInfoText(String label, String value, double width) {
    return Padding(
      padding: EdgeInsets.only(bottom: width * 0.01),
      child: Row(
        children: [
          Text(
            "$label ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width * 0.036,
            ),
          ),
          Text(value, style: TextStyle(fontSize: width * 0.036)),
        ],
      ),
    );
  }
}
