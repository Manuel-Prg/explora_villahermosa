import 'package:explora_villahermosa/data/tourist_sites_data.dart';
import 'package:explora_villahermosa/widgets/map/custom_market.dart';
import 'package:explora_villahermosa/widgets/map/map_control.dart';
import 'package:explora_villahermosa/widgets/map/map_stas_overlay.dart';
import 'package:explora_villahermosa/widgets/map/site_details_mdal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/responsive_utils.dart';
import '../widgets/map/map_legend.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  String? _selectedCategory;
  bool _showLegend = false;

  // Método para calcular el centro geográfico de todos los sitios
  LatLng _calculateCenter() {
    final sites = _getFilteredSites();
    if (sites.isEmpty) return const LatLng(17.9890, -92.9190);

    double sumLat = 0;
    double sumLng = 0;

    for (var site in sites) {
      final pos = site['position'] as LatLng;
      sumLat += pos.latitude;
      sumLng += pos.longitude;
    }

    return LatLng(
      sumLat / sites.length,
      sumLng / sites.length,
    );
  }

  // Obtiene sitios filtrados por categoría
  List<Map<String, dynamic>> _getFilteredSites() {
    if (_selectedCategory == null) {
      return TouristSitesData.sites;
    }
    return TouristSitesData.getSitesByCategory(_selectedCategory!);
  }

  // Construye la lista de marcadores
  List<Marker> _buildMarkers(AppProvider provider) {
    return _getFilteredSites().map((site) {
      final isVisited = provider.visitedPlaces.contains(site['id']);

      return Marker(
        width: 100.0,
        height: 80.0,
        point: site['position'],
        child: CustomMarker(
          site: site,
          isVisited: isVisited,
          onTap: () => _showSiteDetails(site),
        ),
      );
    }).toList();
  }

  // Muestra los detalles del sitio turístico
  void _showSiteDetails(Map<String, dynamic> site) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => SiteDetailsModal(
        site: site,
        onVisit: () {
          setState(() {}); // Actualizar el mapa
        },
      ),
    );
  }

  // Filtra por categoría
  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });

    // Animar hacia el centro de los sitios filtrados
    Future.delayed(const Duration(milliseconds: 300), () {
      _mapController.move(_calculateCenter(), 15.5);
    });
  }

  // Centrar en ubicación del usuario (placeholder)
  void _centerOnUser() {
    _mapController.move(const LatLng(17.9890, -92.9190), 16.0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centrado en tu ubicación'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Mostrar todos los sitios
  void _showAllSites() {
    setState(() {
      _selectedCategory = null;
    });
    _mapController.move(_calculateCenter(), 15.5);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _calculateCenter(),
              initialZoom: 15.5,
              minZoom: 13.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.explora_villahermosa.app',
              ),
              MarkerLayer(
                markers: _buildMarkers(provider),
              ),
            ],
          ),

          // Header con degradado
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.all(spacing.subsection),
                  child: Row(
                    children: [
                      // Botón de retroceso
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.black87,
                        ),
                      ),

                      SizedBox(width: spacing.card),

                      // Título
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.subsection,
                            vertical: spacing.card,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.map,
                                color: Colors.orange.shade700,
                                size: ResponsiveUtils.getIconSize(
                                  deviceType,
                                  IconSizeType.medium,
                                ),
                              ),
                              SizedBox(width: spacing.card),
                              Expanded(
                                child: Text(
                                  _selectedCategory ?? 'Mapa Turístico',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.getFontSize(
                                      deviceType,
                                      FontSize.body,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: spacing.card),

                      // Botón de filtro/leyenda
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            _showLegend ? Icons.close : Icons.filter_list,
                          ),
                          onPressed: () {
                            setState(() {
                              _showLegend = !_showLegend;
                            });
                          },
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Leyenda/Filtros (deslizable desde la derecha)
          if (_showLegend)
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: MapLegend(
                selectedCategory: _selectedCategory,
                onCategorySelected: _filterByCategory,
                onClose: () => setState(() => _showLegend = false),
              ),
            ),

          // Controles del mapa (zoom, ubicación)
          Positioned(
            right: spacing.subsection,
            bottom: spacing.section + 80,
            child: MapControls(
              onZoomIn: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              ),
              onZoomOut: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              ),
              onCenterUser: _centerOnUser,
              onShowAll: _showAllSites,
            ),
          ),

          // Estadísticas overlay
          Positioned(
            left: spacing.subsection,
            bottom: spacing.subsection,
            child: MapStatsOverlay(
              totalSites: TouristSitesData.sites.length,
              visitedSites: provider.visitedPlaces.length,
              filteredSites: _getFilteredSites().length,
              showFiltered: _selectedCategory != null,
            ),
          ),
        ],
      ),
    );
  }
}
