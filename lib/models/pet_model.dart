import 'package:flutter/material.dart';

class PetModel {
  final String id;
  final IconData icon;
  final String name;
  final Color color;
  final String emoji;
  final String? model;
  final bool hasModel;
  final String? animationName;

  const PetModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.color,
    required this.emoji,
    this.model,
    this.hasModel = false,
    this.animationName,
  });
}

class PetsData {
  static final List<PetModel> pets = [
    const PetModel(
      id: 'iguana',
      icon: Icons.park,
      name: 'Iguana',
      color: Color(0xFF8BC34A),
      emoji: '🦎',
      model: 'assets/models/iguana.glb',
      hasModel: true,
      animationName: 'AmatureAction',
    ),
    const PetModel(
      id: 'mariposa',
      icon: Icons.flutter_dash,
      name: 'Mariposa',
      color: Color(0xFFFF9800),
      emoji: '🦋',
      model: 'assets/models/mariposa.glb',
      hasModel: true,
      animationName: '*',
    ),
    const PetModel(
      id: 'guacamaya',
      icon: Icons.air,
      name: 'Guacamaya',
      color: Color(0xFFFF5722),
      emoji: '🦜',
      model: 'assets/models/guacamaya.glb',
      hasModel: true,
      animationName: '*',
    ),
    const PetModel(
      id: 'cocodrilo',
      icon: Icons.water_drop,
      name: 'Cocodrilo',
      color: Color(0xFF4CAF50),
      emoji: '🐊',
    ),
    const PetModel(
      id: 'pejelagarto',
      icon: Icons.waves,
      name: 'Pejelagarto',
      color: Color(0xFF607D8B),
      emoji: '🐟',
    ),
    const PetModel(
      id: 'jaguar',
      icon: Icons.nightlight_round,
      name: 'Jaguar',
      color: Color(0xFFFFC107),
      emoji: '🐆',
    ),
    const PetModel(
      id: 'pijije',
      icon: Icons.air,
      name: 'Pijije',
      color: Color(0xFF00BCD4),
      emoji: '🦆',
    ),
    const PetModel(
      id: 'mono_arana',
      icon: Icons.park,
      name: 'Mono Araña',
      color: Color(0xFFE65100),
      emoji: '🐒',
    ),
    const PetModel(
      id: 'manati',
      icon: Icons.scuba_diving,
      name: 'Manatí',
      color: Color(0xFF4FC3F7),
      emoji: '🦭',
    ),
  ];

  static PetModel getPetById(String id) {
    return pets.firstWhere(
      (pet) => pet.id == id,
      orElse: () => pets.first,
    );
  }
}
