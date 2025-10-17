import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Centro del mapa ajustado a la Plaza de Armas
  final LatLng _initialCenter = const LatLng(17.989, -92.948);

  // LISTA ACTUALIZADA con los lugares de la imagen
  final List<Map<String, dynamic>> touristSites = [
    {
      'id': 'palacio_gobierno',
      'name': 'Palacio de Gobierno',
      'description': 'Sede del poder ejecutivo estatal.',
      'position': const LatLng(17.98790, -92.91951),
      'reward': 30
    },
    {
      'id': 'tribunal_justicia',
      'name': 'Tribunal Superior de Justicia',
      'description': 'Sede del poder judicial.',
      'position': const LatLng(17.987391, -92.919755),
      'reward': 20
    },
    {
      'id': 'casa_azulejos',
      'name': 'Casa de los Azulejos',
      'description': 'Museo de Historia de Tabasco.',
      'position': const LatLng(17.98842, -92.91841),
      'reward': 30
    },
    {
      'id': 'parque_juarez',
      'name': 'Parque Juárez',
      'description': 'Principal parque público del centro.',
      'position': const LatLng(17.99109, -92.91751),
      'reward': 20
    },
    {
      'id': 'iglesia_concepcion',
      'name': 'Iglesia de la Inmaculada Concepción',
      'description': 'Conocida como "La Conchita".',
      'position': const LatLng(17.98630, -92.91974),
      'reward': 25
    },
    {
      'id': 'casa_pellicer',
      'name': 'Casa Carlos Pellicer Cámara',
      'description': 'Casa museo del poeta.',
      'position': const LatLng(17.99031, -92.91909),
      'reward': 25
    },
    {
      'id': 'biblioteca_Manuel_R',
      'name': 'Biblioteca Manuel R. Mora',
      'description': 'Biblioteca pública histórica.',
      'position': const LatLng(17.98735, -92.91919),
      'reward': 30
    },
    {
      'id': 'biblioteca:José_E',
      'name': 'Biblioteca José E. de Cárdenas',
      'description': 'Biblioteca pública histórica.',
      'position': const LatLng(17.98755, -92.91917),
      'reward': 25
    },
    {
      'id': 'centro_cultural',
      'name': 'Centro Cultural Villahermosa',
      'description': 'Espacio para las artes y la cultura.',
      'position': const LatLng(17.99097, -92.91696),
      'reward': 25
    },
    {
      'id': 'ayuntamiento',
      'name': 'Palacio Municipal (Ayuntamiento)',
      'description': 'Oficinas del gobierno de Centro.',
      'position': const LatLng(17.986994, -92.919476),
      'reward': 20
    },
    {
      'id': 'plaza_bicentenario',
      'name': 'Plaza Bicentenario',
      'description': 'Plaza conmemorativa con fuente.',
      'position': const LatLng(17.98831, -92.91942),
      'reward': 15
    },
    {
      'id': 'casa_agua_ujat',
      'name': 'Casa Universitaria del Agua UJAT',
      'description': 'Museo interactivo sobre el agua.',
      'position': const LatLng(17.99051, -92.92016),
      'reward': 40
    },
    {
      'id': 'calle_juarez',
      'name': 'Calle Benito Juárez',
      'description': 'Calle conmemorativa.',
      'position': const LatLng(17.98848, -92.91858),
      'reward': 10
    },
    {
      'id': 'parque_morelos',
      'name': 'Parque Morelos',
      'description': 'Parque con áreas verdes y recreativas.',
      'position': const LatLng(17.988914, -92.922353),
      'reward': 40
    },
    {
      'id': 'instituto_juarez',
      'name': 'Instituto Juárez',
      'description': 'Instituto educativo en el centro.',
      'position': const LatLng(17.98889, -92.92111),
      'reward': 25
    },
    {
      'id': 'parque_pajaritos',
      'name': 'Parque los Pajaritos',
      'description': 'Parque popular en el centro.',
      'position': const LatLng(17.99039, -92.91986),
      'reward': 15
    },
    {
      'id': 'parque_corregidora',
      'name': 'Parque Corregidora',
      'description': 'Parque con jardines y áreas recreativas.',
      'position': const LatLng(17.98823, -92.91891),
      'reward': 25
    },
    {
      'id': 'museo_de_tabasco',
      'name': 'Museo de Tabasco',
      'description': 'Parque museo.',
      'position': const LatLng(17.99077, -92.91730),
      'reward': 30
    },
    {
      'id': 'banco_de_mexico',
      'name': 'Banco de México',
      'description': 'Sede del banco central.',
      'position': const LatLng(17.98855, -92.91833),
      'reward': 25
    },
    {
      'id': 'casa_josefina',
      'name': 'Casa Josefina vicens',
      'description': 'Casa histórica en el centro.',
      'position': const LatLng(17.99415, -92.91463),
      'reward': 15
    },
    {
      'id': 'hotel_one_centro',
      'name': 'Hotel One (Centro)',
      'description': 'Hotel en la zona centro.',
      'position': const LatLng(17.99126, -92.91822),
      'reward': 10
    },
    {
      'id': 'plaza_de_armas',
      'name': 'Plaza de Armas',
      'description': 'El corazón del centro histórico.',
      'position': const LatLng(17.8789, -92.91948),
      'reward': 20
    },
    {
      'id': 'cine_sheba',
      'name': 'Cine Sheba',
      'description': 'Antiguo cine icónico de Villahermosa.',
      'position': const LatLng(17.98795, -92.91752),
      'reward': 10
    },
    {
      'id': 'carcel_y_ayuntamiento',
      'name': 'Cárcel y Ayuntamiento',
      'description': 'Edificios históricos en el centro.',
      'position': const LatLng(17.986844, -92.919186),
      'reward': 15
    },
    {
      'id': 'casa_piedra',
      'name': 'Casa de Piedra',
      'description': 'Casa histórica en el centro.',
      'position': const LatLng(17.98709, -92.91986),
      'reward': 15
    },
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    // Convertimos tus sitios en Marcadores para el mapa
    List<Marker> markers = touristSites.map((site) {
      bool isVisited = provider.visitedPlaces.contains(site['id']);
      return Marker(
        width: 100.0,
        height: 80.0,
        point: site['position'],
        child: GestureDetector(
          onTap: () => _showSiteDetails(site),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_pin,
                color: isVisited ? Colors.green.shade700 : Colors.red.shade700,
                size: 40,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 5)],
              ),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    site['name'],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Turístico'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 16.5, // Aumenté el zoom para ver mejor el centro
        ),
        children: [
          // 1. Capa base del mapa (viene de OpenStreetMap)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.explora_villahermosa.app',
          ),

          // 2. Capa de marcadores (nuestros puntos de interés)
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }

  // Puedes reusar tu función para mostrar detalles, con ligeros ajustes
  void _showSiteDetails(Map<String, dynamic> site) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final isVisited = provider.visitedPlaces.contains(site['id']);

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(site['name'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(site['description']),
            const SizedBox(height: 20),
            if (!isVisited)
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: Text('Marcar como Visitado (+${site['reward']} Puntos)'),
                onPressed: () {
                  provider.addPoints(site['reward']);
                  provider.visitPlace(site['id']);
                  Navigator.pop(context);
                  setState(() {}); // Para redibujar el mapa con el nuevo estado
                },
              )
            else
              const Text('¡Ya has visitado este lugar!',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
