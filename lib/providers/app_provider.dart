import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // Puntos acumulados por el usuario
  int _points = 100;
  int get points => _points;

  // Nivel del usuario
  int _level = 1;
  int get level => _level;

  // Logros del usuario
  List<Map<String, dynamic>> achievements = [];
  List<Map<String, dynamic>> get userAchievements => achievements;

  // Lugares visitados
  final List<String> _visitedPlaces = [];
  List<String> get visitedPlaces => _visitedPlaces;

  // Trivias completadas
  final Map<String, bool> _completedTrivias = {};
  Map<String, bool> get completedTrivias => _completedTrivias;

  // Mascotas desbloqueadas
  final List<String> _unlockedPets = [
    'iguana',
    'hicotea',
    'coati',
    'cocodrilo',
    'pejelagarto',
    'jaguar',
    'pijije',
    'mono_arana',
    'manati',
  ]; // <-- VALORES NUEVOS
  List<String> get unlockedPets => _unlockedPets;

// Mascota actual seleccionada
  String _currentPet = 'iguana';
  String get currentPet => _currentPet;
  String get selectedPet => _currentPet;

  // Estadísticas de la mascota
  String _petName = 'Amigo';
  String get petName => _petName;

  int _petLevel = 1;
  int get petLevel => _petLevel;

  int _petHunger = 80;
  int get petHunger => _petHunger;

  int _petExperience = 0;
  int get petExperience => _petExperience;

  // Estadísticas adicionales
  int get triviaProgress => _completedTrivias.length;
  int get sitesVisited => _visitedPlaces.length;

  // Agregar puntos
  void addPoints(int amount) {
    _points += amount;
    _checkLevelUp();
    notifyListeners();
  }

  // Verificar si sube de nivel
  void _checkLevelUp() {
    int newLevel = (_points / 100).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
    }
  }

  // Marcar lugar como visitado
  void visitPlace(String placeId) {
    if (!_visitedPlaces.contains(placeId)) {
      _visitedPlaces.add(placeId);
      addPoints(10); // Bonus por visitar un lugar nuevo
    }
    notifyListeners();
  }

  // Visitar sitio (alias para compatibilidad)
  void visitSite(String site) {
    visitPlace(site);
  }

  // Completar trivia
  void completeTrivia(String triviaId, int score) {
    _completedTrivias[triviaId] = true;
    addPoints(score);
    notifyListeners();
  }

  // Responder trivia (alias para compatibilidad)
  void answerTrivia(bool isCorrect) {
    if (isCorrect) {
      addPoints(10);
    }
  }

  // Desbloquear mascota
  void unlockPet(String petId) {
    if (!_unlockedPets.contains(petId)) {
      _unlockedPets.add(petId);
      notifyListeners();
    }
  }

  // Seleccionar mascota actual
  void selectPet(String petId) {
    if (_unlockedPets.contains(petId)) {
      _currentPet = petId;
      notifyListeners();
    }
  }

  // Verificar si una mascota está desbloqueada
  bool isPetUnlocked(String petId) {
    return _unlockedPets.contains(petId);
  }

  // Obtener puntos necesarios para el siguiente nivel
  int getPointsForNextLevel() {
    return (_level * 100) - _points;
  }

  // Alimentar mascota
  void feedPet(int amount) {
    if (_points >= 10) {
      _points -= 10;
      _petHunger = (_petHunger + amount).clamp(0, 100);
      notifyListeners();
    }
  }

  // Actualizar experiencia de la mascota
  void updatePetExperience(int amount) {
    _petExperience = (_petExperience + amount).clamp(0, 100);

    // Si llega a 100, sube de nivel
    if (_petExperience >= 100) {
      _petLevel++;
      _petExperience = 0;
    }

    notifyListeners();
  }

  // Disminuir hambre de la mascota
  void decreasePetHunger() {
    _petHunger = (_petHunger - 15).clamp(0, 100);
    notifyListeners();
  }

  // Cambiar nombre de la mascota
  void setPetName(String name) {
    _petName = name;
    notifyListeners();
  }
}
