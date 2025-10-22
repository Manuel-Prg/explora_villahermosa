import 'package:flutter/material.dart';
import '../services/storage_service.dart';

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
    'mariposa',
    'guacamaya',
    'cocodrilo',
    'pejelagarto',
    'jaguar',
    'pijije',
    'mono_arana',
    'manati',
  ];
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

  int _petHappiness = 80;
  int get petHappiness => _petHappiness;

  // Inventario del usuario
  final Map<String, int> _inventory = {
    'comida_basica': 3,
    'comida_premium': 1,
    'juguete_pelota': 2,
  };
  Map<String, int> get inventory => _inventory;

  // Flag para saber si los datos ya se cargaron
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  // Estadísticas adicionales
  int get triviaProgress => _completedTrivias.length;
  int get sitesVisited => _visitedPlaces.length;

  // 🔄 CARGAR DATOS AL INICIAR
  Future<void> loadData() async {
    try {
      final data = await StorageService.loadAllData();

      _points = data['points'] ?? 100;
      _level = data['level'] ?? 1;

      final inventory = data['inventory'] as Map<String, int>;
      _inventory.clear();
      _inventory.addAll(inventory);

      _visitedPlaces.clear();
      _visitedPlaces.addAll(data['visitedPlaces'] ?? []);

      final trivias = data['completedTrivias'] as Map<String, bool>;
      _completedTrivias.clear();
      _completedTrivias.addAll(trivias);

      final petData = data['petData'] as Map<String, dynamic>;
      _petName = petData['name'] ?? 'Amigo';
      _petLevel = petData['level'] ?? 1;
      _petHunger = petData['hunger'] ?? 80;
      _petHappiness = petData['happiness'] ?? 80;
      _petExperience = petData['experience'] ?? 0;
      _currentPet = petData['selected'] ?? 'iguana';

      achievements = data['achievements'] ?? [];

      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando datos: $e');
      _isLoaded = true;
      notifyListeners();
    }
  }

  // 💾 GUARDAR DATOS
  Future<void> saveData() async {
    try {
      await StorageService.saveAllData(
        points: _points,
        level: _level,
        inventory: _inventory,
        visitedPlaces: _visitedPlaces,
        completedTrivias: _completedTrivias,
        petData: {
          'name': _petName,
          'level': _petLevel,
          'hunger': _petHunger,
          'happiness': _petHappiness,
          'experience': _petExperience,
          'selected': _currentPet,
        },
        achievements: achievements,
      );
    } catch (e) {
      debugPrint('Error guardando datos: $e');
    }
  }

  // Agregar puntos
  void addPoints(int amount) {
    _points += amount;
    _checkLevelUp();
    notifyListeners();
    saveData(); // Auto-guardar
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
      addPoints(10);
    }
    notifyListeners();
    saveData();
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
    saveData();
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
      saveData();
    }
  }

  // Seleccionar mascota actual
  void selectPet(String petId) {
    if (_unlockedPets.contains(petId)) {
      _currentPet = petId;
      notifyListeners();
      saveData();
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
  void feedPet(String foodType) {
    if (!hasItem(foodType)) return;

    useItem(foodType);

    int hungerRestore = 0;
    int happinessBonus = 0;

    switch (foodType) {
      case 'comida_basica':
        hungerRestore = 20;
        happinessBonus = 5;
        break;
      case 'comida_premium':
        hungerRestore = 40;
        happinessBonus = 15;
        break;
      case 'comida_deluxe':
        hungerRestore = 60;
        happinessBonus = 25;
        break;
    }

    _petHunger = (_petHunger + hungerRestore).clamp(0, 100);
    _petHappiness = (_petHappiness + happinessBonus).clamp(0, 100);

    notifyListeners();
    saveData();
  }

  // Jugar con mascota
  void playWithPet({String? toyType}) {
    int expGain = 10;
    int happinessGain = 10;
    int hungerLoss = 15;

    if (toyType != null && hasItem(toyType)) {
      useItem(toyType);

      switch (toyType) {
        case 'juguete_pelota':
          expGain = 15;
          happinessGain = 20;
          hungerLoss = 10;
          break;
        case 'juguete_cuerda':
          expGain = 20;
          happinessGain = 25;
          hungerLoss = 12;
          break;
        case 'juguete_premium':
          expGain = 30;
          happinessGain = 35;
          hungerLoss = 8;
          break;
      }
    }

    updatePetExperience(expGain);
    _petHappiness = (_petHappiness + happinessGain).clamp(0, 100);
    _petHunger = (_petHunger - hungerLoss).clamp(0, 100);

    notifyListeners();
    saveData();
  }

  // Actualizar experiencia de la mascota
  void updatePetExperience(int amount) {
    _petExperience = (_petExperience + amount).clamp(0, 100);

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
    saveData();
  }

  // Comprar item
  bool buyItem(String itemId, int price) {
    if (_points < price) return false;

    _points -= price;
    addItemToInventory(itemId, 1);
    notifyListeners();
    saveData();
    return true;
  }

  // Agregar item al inventario
  void addItemToInventory(String itemId, int quantity) {
    _inventory[itemId] = (_inventory[itemId] ?? 0) + quantity;
    notifyListeners();
  }

  // Usar item del inventario
  void useItem(String itemId) {
    if (_inventory[itemId] != null && _inventory[itemId]! > 0) {
      _inventory[itemId] = _inventory[itemId]! - 1;
      if (_inventory[itemId] == 0) {
        _inventory.remove(itemId);
      }
      notifyListeners();
    }
  }

  // Verificar si tiene un item
  bool hasItem(String itemId) {
    return (_inventory[itemId] ?? 0) > 0;
  }

  // Obtener cantidad de un item
  int getItemCount(String itemId) {
    return _inventory[itemId] ?? 0;
  }

  // Dar medicina
  void giveMedicine(String medicineType) {
    if (!hasItem(medicineType)) return;

    useItem(medicineType);

    switch (medicineType) {
      case 'medicina_basica':
        _petHappiness = (_petHappiness + 10).clamp(0, 100);
        break;
      case 'vitamina':
        _petExperience = (_petExperience + 20).clamp(0, 100);
        break;
      case 'pocion_energia':
        _petHunger = 100;
        _petHappiness = 100;
        break;
    }

    notifyListeners();
    saveData();
  }
}
