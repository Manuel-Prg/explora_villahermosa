import 'package:flutter/material.dart';

class MonumentModel {
  final String id;
  final String name;
  final String? model;
  final IconData icon;
  final Color color;
  final int points;
  final String description;
  final bool hasModel;

  const MonumentModel({
    required this.id,
    required this.name,
    this.model,
    required this.icon,
    required this.color,
    required this.points,
    required this.description,
    this.hasModel = false,
  });
}

class MonumentsData {
  static final List<MonumentModel> monuments = [
    const MonumentModel(
      id: 'cafe',
      name: 'Café el Portal',
      model: 'assets/models/cafe.glb',
      icon: Icons.local_cafe,
      color: Color(0xFF8D6E63),
      points: 50,
      description:
          'Edificio histórico con arquitectura colonial de principios del siglo XX.',
      hasModel: true,
    ),
    const MonumentModel(
      id: 'Palacio',
      name: 'Palacio Municipal',
      model: 'assets/models/Edificio.glb',
      icon: Icons.apartment,
      color: Color(0xFF4CAF50),
      points: 40,
      description: 'Edificio emblemático del centro de Villahermosa.',
      hasModel: true,
    ),
    const MonumentModel(
      id: 'catedral',
      name: 'Catedral del Señor',
      model: 'assets/models/catedral.glb',
      icon: Icons.church,
      color: Color(0xFF2196F3),
      points: 30,
      description: 'Hermosa catedral en el centro de Villahermosa.',
      hasModel: true,
    ),
    const MonumentModel(
      id: 'malecon',
      name: 'Malecón',
      model: 'assets/models/malecon.glb',
      icon: Icons.water,
      color: Color(0xFF00BCD4),
      points: 25,
      description: 'Paseo a orillas del río Grijalva.',
      hasModel: true,
    ),
  ];

  static MonumentModel getMonumentById(String id) {
    return monuments.firstWhere(
      (monument) => monument.id == id,
      orElse: () => monuments.first,
    );
  }
}
