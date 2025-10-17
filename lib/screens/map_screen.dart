import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  // Coordenadas de Villahermosa, Tabasco
  final LatLng _center = const LatLng(17.9892, -92.9475);

  final Set<Marker> _markers = {};
  String? selectedSite;

  final List<Map<String, dynamic>> touristSites = [
    {
      'id': 'casa_azulejos',
      'name': 'Casa de los Azulejos',
      'description': 'Edificio histórico de 1890',
      'position': const LatLng(17.9892, -92.9475),
      'visited': false,
      'reward': 50,
    },
    {
      'id': 'catedral',
      'name': 'Catedral del Señor',
      'description': 'Templo principal de la ciudad',
      'position': const LatLng(17.9896, -92.9450),
      'visited': false,
      'reward': 50,
    },
    {
      'id': 'palacio',
      'name': 'Palacio de Gobierno',
      'description': 'Sede del poder ejecutivo',
      'position': const LatLng(17.9900, -92.9485),
      'visited': false,
      'reward': 50,
    },
    {
      'id': 'parque_museo',
      'name': 'Parque Museo La Venta',
      'description': 'Parque arqueológico olmeca',
      'position': const LatLng(18.0050, -92.9520),
      'visited': false,
      'reward': 100,
    },
    {
      'id': 'malecón',
      'name': 'Malecón Carlos A. Madrazo',
      'description': 'Paseo junto al río Grijalva',
      'position': const LatLng(17.9885, -92.9430),
      'visited': false,
      'reward': 30,
    },
  ];

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    for (var site in touristSites) {
      _markers.add(
        Marker(
          markerId: MarkerId(site['id']),
          position: site['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            site['visited']
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: site['name'],
            snippet: site['description'],
          ),
          onTap: () => _onMarkerTapped(site),
        ),
      );
    }
  }

  void _onMarkerTapped(Map<String, dynamic> site) {
    setState(() {
      selectedSite = site['id'];
    });
    _showSiteDetails(site);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 14.0),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),

          // Header
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader(provider)),

          // Legend
          Positioned(bottom: 20, left: 20, child: _buildLegend()),

          // Zoom Controls
          Positioned(bottom: 20, right: 20, child: _buildZoomControls()),
        ],
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 15,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF66BB6A).withOpacity(0.95),
            const Color(0xFF4CAF50).withOpacity(0.95),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mapa Turístico',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber.shade300),
                  const SizedBox(width: 5),
                  Text(
                    '${provider.points}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 18),
                const SizedBox(width: 5),
                Text(
                  'Sitios visitados: ${provider.sitesVisited}/20',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Leyenda',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem(Colors.red, 'No visitado'),
          _buildLegendItem(Colors.green, 'Visitado'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: 'zoom_in',
          mini: true,
          backgroundColor: Colors.white,
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          },
          child: const Icon(Icons.add, color: Color(0xFF4CAF50)),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'zoom_out',
          mini: true,
          backgroundColor: Colors.white,
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
          child: const Icon(Icons.remove, color: Color(0xFF4CAF50)),
        ),
      ],
    );
  }

  void _showSiteDetails(Map<String, dynamic> site) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    site['visited'] ? Icons.check_circle : Icons.location_on,
                    size: 40,
                    color: site['visited']
                        ? const Color(0xFF66BB6A)
                        : const Color(0xFFEF5350),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                      Text(
                        site['visited'] ? '¡Ya visitado!' : 'Por visitar',
                        style: TextStyle(
                          fontSize: 14,
                          color: site['visited']
                              ? const Color(0xFF66BB6A)
                              : const Color(0xFF8D6E63),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              site['description'],
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF5D4037),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE082).withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFFFE082),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber.shade700),
                  const SizedBox(width: 10),
                  Text(
                    'Recompensa: ${site['reward']} monedas',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToSite(site);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Cómo llegar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                if (!site['visited']) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _markAsVisited(site);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Marcar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSite(Map<String, dynamic> site) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: site['position'], zoom: 17.0),
      ),
    );
  }

  void _markAsVisited(Map<String, dynamic> site) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.visitSite(site['id']);

    setState(() {
      site['visited'] = true;
      _markers.removeWhere((m) => m.markerId.value == site['id']);
      _markers.add(
        Marker(
          markerId: MarkerId(site['id']),
          position: site['position'],
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: site['name'],
            snippet: site['description'],
          ),
          onTap: () => _onMarkerTapped(site),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Sitio visitado! +${site['reward']} monedas'),
        backgroundColor: const Color(0xFF66BB6A),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
