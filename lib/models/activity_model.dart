// lib/models/activity_model.dart
import 'package:flutter/material.dart';

class ActivityModel {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final String emoji;

  const ActivityModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.emoji,
  });

  static List<ActivityModel> getActivities() {
    return [
      const ActivityModel(
        name: 'Trivia',
        icon: Icons.quiz,
        color: Color(0xFFE91E63),
        description: 'Demuestra tus conocimientos',
        emoji: '🤔',
      ),
      const ActivityModel(
        name: 'Realidad Aumentada',
        icon: Icons.view_in_ar,
        color: Color(0xFF9C27B0),
        description: 'Experiencia inmersiva',
        emoji: '📱',
      ),
      const ActivityModel(
        name: 'Mascotas',
        icon: Icons.pets,
        color: Color(0xFF3F51B5),
        description: 'Colecciónalas todas',
        emoji: '🐾',
      ),
      const ActivityModel(
        name: 'Logros',
        icon: Icons.emoji_events,
        color: Color(0xFFFF9800),
        description: 'Desbloquea premios',
        emoji: '🏅',
      ),
    ];
  }
}
