import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  // Keys para almacenar datos
  static const String _pointsKey = 'user_points';
  static const String _levelKey = 'user_level';
  static const String _inventoryKey = 'user_inventory';
  static const String _visitedPlacesKey = 'visited_places';
  static const String _completedTriviasKey = 'completed_trivias';
  static const String _petDataKey = 'pet_data';
  static const String _achievementsKey = 'achievements';
  static const String _firstLaunchKey = 'first_launch';

  // Verificar si es la primera vez que se abre la app
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  // Marcar como no primera vez
  static Future<void> setNotFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  // Guardar todos los datos del usuario
  static Future<void> saveAllData({
    required int points,
    required int level,
    required Map<String, int> inventory,
    required List<String> visitedPlaces,
    required Map<String, bool> completedTrivias,
    required Map<String, dynamic> petData,
    required List<Map<String, dynamic>> achievements,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setInt(_pointsKey, points),
      prefs.setInt(_levelKey, level),
      prefs.setString(_inventoryKey, jsonEncode(inventory)),
      prefs.setStringList(_visitedPlacesKey, visitedPlaces),
      prefs.setString(_completedTriviasKey, jsonEncode(completedTrivias)),
      prefs.setString(_petDataKey, jsonEncode(petData)),
      prefs.setString(_achievementsKey, jsonEncode(achievements)),
    ]);
  }

  // Cargar todos los datos del usuario
  static Future<Map<String, dynamic>> loadAllData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'points': prefs.getInt(_pointsKey) ?? 100,
      'level': prefs.getInt(_levelKey) ?? 1,
      'inventory': _parseInventory(prefs.getString(_inventoryKey)),
      'visitedPlaces': prefs.getStringList(_visitedPlacesKey) ?? [],
      'completedTrivias':
          _parseCompletedTrivias(prefs.getString(_completedTriviasKey)),
      'petData': _parsePetData(prefs.getString(_petDataKey)),
      'achievements': _parseAchievements(prefs.getString(_achievementsKey)),
    };
  }

  // Parsers privados
  static Map<String, int> _parseInventory(String? json) {
    if (json == null || json.isEmpty) {
      return {
        'comida_basica': 3,
        'comida_premium': 1,
        'juguete_pelota': 2,
      };
    }
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as int));
    } catch (e) {
      return {
        'comida_basica': 3,
        'comida_premium': 1,
        'juguete_pelota': 2,
      };
    }
  }

  static Map<String, bool> _parseCompletedTrivias(String? json) {
    if (json == null || json.isEmpty) return {};
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      return {};
    }
  }

  static Map<String, dynamic> _parsePetData(String? json) {
    if (json == null || json.isEmpty) {
      return {
        'name': 'Amigo',
        'level': 1,
        'hunger': 80,
        'happiness': 80,
        'experience': 0,
        'selected': 'iguana',
      };
    }
    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      return {
        'name': 'Amigo',
        'level': 1,
        'hunger': 80,
        'happiness': 80,
        'experience': 0,
        'selected': 'iguana',
      };
    }
  }

  static List<Map<String, dynamic>> _parseAchievements(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      final decoded = jsonDecode(json) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Limpiar todos los datos (para testing o reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Guardar datos individuales (para optimización)
  static Future<void> savePoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points);
  }

  static Future<void> saveInventory(Map<String, int> inventory) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_inventoryKey, jsonEncode(inventory));
  }

  static Future<void> savePetData(Map<String, dynamic> petData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_petDataKey, jsonEncode(petData));
  }
}
