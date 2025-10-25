// lib/providers/game_progress_provider.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class GameProgressProvider extends ChangeNotifier {
  final List<String> _visitedPlaces = [];
  List<String> get visitedPlaces => _visitedPlaces;

  final Map<String, bool> _completedTrivias = {};
  Map<String, bool> get completedTrivias => _completedTrivias;

  List<Map<String, dynamic>> _achievements = [];
  List<Map<String, dynamic>> get achievements => _achievements;
  List<Map<String, dynamic>> get userAchievements => _achievements;

  int get placesVisitedCount => _visitedPlaces.length;
  int get triviasCompletedCount => _completedTrivias.length;
  int get sitesVisited => _visitedPlaces.length;
  int get triviaProgress => _completedTrivias.length;

  void visitPlace(String placeId) {
    if (!_visitedPlaces.contains(placeId)) {
      _visitedPlaces.add(placeId);
      debugPrint('📍 Lugar visitado: $placeId');
      notifyListeners();
      _saveData();
    }
  }

  void visitSite(String site) {
    visitPlace(site);
  }

  void completeTrivia(String triviaId, int score) {
    _completedTrivias[triviaId] = true;
    debugPrint('🎯 Trivia completada: $triviaId ($score pts)');
    notifyListeners();
    _saveData();
  }

  void answerTrivia(bool isCorrect) {
    // Lógica manejada por completeTrivia
  }

  bool isTriviaCompleted(String triviaId) {
    return _completedTrivias[triviaId] ?? false;
  }

  bool isPlaceVisited(String placeId) {
    return _visitedPlaces.contains(placeId);
  }

  Future<void> loadData() async {
    debugPrint('🔄 GameProgressProvider: Cargando datos...');
    try {
      final data = await StorageService.loadGameProgressData();

      final visitedData = data['visitedPlaces'];
      if (visitedData is List) {
        _visitedPlaces.clear();
        _visitedPlaces.addAll(visitedData.cast<String>());
      }

      final triviasData = data['completedTrivias'];
      if (triviasData is Map) {
        _completedTrivias.clear();
        triviasData.forEach((key, value) {
          if (key is String && value is bool) {
            _completedTrivias[key] = value;
          }
        });
      }

      final achievementsData = data['achievements'];
      if (achievementsData is List) {
        _achievements = achievementsData.cast<Map<String, dynamic>>();
      }

      debugPrint(
          '✅ GameProgressProvider: ${_visitedPlaces.length} lugares, ${_completedTrivias.length} trivias');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ GameProgressProvider: Error: $e');
    }
  }

  Future<void> _saveData() async {
    await StorageService.saveGameProgressData(
      visitedPlaces: _visitedPlaces,
      completedTrivias: _completedTrivias,
      achievements: _achievements,
    );
  }
}
