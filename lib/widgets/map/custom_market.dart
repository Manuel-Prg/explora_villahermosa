import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final Map<String, dynamic> site;
  final bool isVisited;
  final VoidCallback onTap;

  const CustomMarker({
    super.key,
    required this.site,
    required this.isVisited,
    required this.onTap,
  });

  // Obtiene el icono según la categoría
  IconData _getCategoryIcon() {
    final category = site['category'] as String?;
    switch (category) {
      case 'Museo':
        return Icons.museum;
      case 'Parque':
        return Icons.park;
      case 'Religioso':
        return Icons.church;
      case 'Gobierno':
        return Icons.account_balance;
      case 'Cultura':
        return Icons.library_books;
      case 'Plaza':
        return Icons.location_city;
      case 'Educación':
        return Icons.school;
      case 'Histórico':
        return Icons.history_edu;
      case 'Entretenimiento':
        return Icons.theaters;
      case 'Hospedaje':
        return Icons.hotel;
      case 'Financiero':
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }

  // Obtiene el color según el estado y categoría
  Color _getMarkerColor() {
    if (isVisited) {
      return Colors.green.shade700;
    }

    final category = site['category'] as String?;
    switch (category) {
      case 'Museo':
        return Colors.purple.shade700;
      case 'Parque':
        return Colors.lightGreen.shade700;
      case 'Religioso':
        return Colors.indigo.shade700;
      case 'Gobierno':
        return Colors.blue.shade700;
      case 'Cultura':
        return Colors.orange.shade700;
      case 'Plaza':
        return Colors.teal.shade700;
      default:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono principal del marcador
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.location_pin,
                color: _getMarkerColor(),
                size: 45,
                shadows: const [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 5,
                  ),
                ],
              ),
              // Icono de categoría pequeño
              Positioned(
                top: 8,
                child: Icon(
                  _getCategoryIcon(),
                  color: Colors.white,
                  size: 18,
                ),
              ),
              // Badge de visitado
              if (isVisited)
                Positioned(
                  top: 2,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green.shade700,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green.shade700,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 2),

          // Etiqueta con el nombre
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 90),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: _getMarkerColor().withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                site['name'],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: _getMarkerColor(),
                  height: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
