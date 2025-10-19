// lib/models/place_model.dart
import 'package:flutter/material.dart';

class PlaceModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String emoji;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.emoji,
  });

  static List<PlaceModel> getTouristPlaces() {
    return [
      const PlaceModel(
        id: 'parque_venta',
        name: 'Parque La Venta',
        icon: Icons.park,
        color: Color(0xFF4CAF50),
        emoji: '🌳',
      ),
      const PlaceModel(
        id: 'yumka',
        name: 'Yumká',
        icon: Icons.nature,
        color: Color(0xFF8BC34A),
        emoji: '🦁',
      ),
      const PlaceModel(
        id: 'casa_agua',
        name: 'Casa Universitaria del Agua',
        icon: Icons.water_drop,
        color: Color(0xFF03A9F4),
        emoji: '💧',
      ),
      const PlaceModel(
        id: 'museo_venta',
        name: 'Museo La Venta',
        icon: Icons.museum,
        color: Color(0xFF009688),
        emoji: '🗿',
      ),
      const PlaceModel(
        id: 'laguna_ilusiones',
        name: 'Laguna Ilusiones',
        icon: Icons.water,
        color: Color(0xFF00BCD4),
        emoji: '💧',
      ),
    ];
  }
}
