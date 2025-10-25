// lib/providers/app_provider.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/user_profile_model.dart';

class AppProvider extends ChangeNotifier {
  // 👤 PERFIL DE USUARIO
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

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

  // 🆕 MÉTODOS DE PERFIL DE USUARIO

  /// Inicializar perfil del usuario
  void initializeProfile() {
    if (_userProfile == null) {
      _userProfile = UserProfile.initial();
      debugPrint('👤 Perfil inicial creado');
      notifyListeners();
    }
  }

  /// Actualizar nombre del perfil
  void updateProfileName(String name) {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(name: name);
      debugPrint('👤 Nombre actualizado: $name');
      notifyListeners();
      saveData();
    }
  }

  /// Agregar XP y verificar subida de nivel
  void addXP(int amount) {
    if (_userProfile == null) return;

    final newXP = _userProfile!.currentXP + amount;
    final xpForNextLevel = _calculateXPForLevel(_userProfile!.level + 1);

    if (newXP >= xpForNextLevel) {
      // ¡Subió de nivel!
      final newLevel = _userProfile!.level + 1;
      _userProfile = _userProfile!.copyWith(
        level: newLevel,
        currentXP: newXP,
      );
      _level = newLevel; // Sincronizar con el sistema antiguo
      debugPrint('🎉 ¡Subiste al nivel $newLevel!');
    } else {
      _userProfile = _userProfile!.copyWith(currentXP: newXP);
    }

    notifyListeners();
  }

  /// Calcular XP total necesario para un nivel
  int _calculateXPForLevel(int targetLevel) {
    if (targetLevel <= 1) return 0;
    return (targetLevel - 1) * 100;
  }

  /// Incrementar una estadística específica
  void incrementStat(String statName, [int amount = 1]) {
    if (_userProfile == null) return;

    final newStats = _userProfile!.stats.incrementStat(statName, amount);
    _userProfile = _userProfile!.copyWith(stats: newStats);

    debugPrint('📊 Stat incrementada: $statName +$amount');
    notifyListeners();
  }

  /// Actualizar último login
  void updateLastLogin() {
    if (_userProfile == null) return;

    _userProfile = _userProfile!.copyWith(lastLogin: DateTime.now());
    notifyListeners();
  }

  // 🔄 CARGAR DATOS AL INICIAR
  Future<void> loadData() async {
    debugPrint('🔄 AppProvider: Iniciando carga de datos...');

    try {
      final data = await StorageService.loadAllData();
      debugPrint('📦 AppProvider: Datos recibidos del storage');

      // Cargar perfil de usuario
      final profileData = data['profile'];
      if (profileData != null && profileData is Map<String, dynamic>) {
        _userProfile = UserProfile.fromJson(profileData);
        debugPrint('👤 Perfil cargado: ${_userProfile!.name}');
      } else {
        // Si no hay perfil, crear uno inicial
        initializeProfile();
      }

      _points = data['points'] ?? 100;
      _level = data['level'] ?? 1;

      // Sincronizar nivel con el perfil
      if (_userProfile != null && _userProfile!.level != _level) {
        _userProfile = _userProfile!.copyWith(level: _level);
      }

      // Cargar inventario de forma segura
      final inventoryData = data['inventory'];
      if (inventoryData is Map) {
        _inventory.clear();
        inventoryData.forEach((key, value) {
          if (key is String && value is int) {
            _inventory[key] = value;
          }
        });
      }

      // Si el inventario está vacío, agregar items iniciales
      if (_inventory.isEmpty) {
        _inventory['comida_basica'] = 3;
        _inventory['comida_premium'] = 1;
        _inventory['juguete_pelota'] = 2;
        debugPrint('🎁 AppProvider: Inventario inicial agregado');
      }

      // Cargar lugares visitados
      _visitedPlaces.clear();
      final visitedData = data['visitedPlaces'];
      if (visitedData is List) {
        _visitedPlaces.addAll(visitedData.cast<String>());
      }

      // Cargar trivias completadas
      _completedTrivias.clear();
      final triviasData = data['completedTrivias'];
      if (triviasData is Map) {
        triviasData.forEach((key, value) {
          if (key is String && value is bool) {
            _completedTrivias[key] = value;
          }
        });
      }

      // Cargar datos de mascota
      final petData = data['petData'];
      if (petData is Map<String, dynamic>) {
        _petName = petData['name'] ?? 'Amigo';
        _petLevel = petData['level'] ?? 1;
        _petHunger = petData['hunger'] ?? 80;
        _petHappiness = petData['happiness'] ?? 80;
        _petExperience = petData['experience'] ?? 0;
        _currentPet = petData['selected'] ?? 'iguana';
      }

      // Cargar logros
      final achievementsData = data['achievements'];
      if (achievementsData is List) {
        achievements = achievementsData.cast<Map<String, dynamic>>();
      }

      // Actualizar último login
      updateLastLogin();

      _isLoaded = true;

      debugPrint('✅ AppProvider: Datos cargados correctamente');
      debugPrint('   - Perfil: ${_userProfile?.name}');
      debugPrint('   - Puntos: $_points');
      debugPrint('   - Nivel: $_level');
      debugPrint('   - Inventario: ${_inventory.length} items');
      debugPrint('   - Mascota: $_petName ($_currentPet)');

      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ AppProvider: Error cargando datos: $e');
      debugPrint('Stack trace: $stackTrace');

      // Inicializar con valores por defecto
      initializeProfile();
      _isLoaded = true;
      notifyListeners();
    }
  }

  // 💾 GUARDAR DATOS
  Future<void> saveData() async {
    try {
      await StorageService.saveAllData(
        profile: _userProfile?.toJson(),
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
      debugPrint('💾 AppProvider: Datos guardados');
    } catch (e) {
      debugPrint('❌ AppProvider: Error guardando datos: $e');
    }
  }

  // Agregar puntos
  void addPoints(int amount) {
    _points += amount;
    _userProfile = _userProfile?.copyWith(totalPoints: _points);
    addXP(amount); // Agregar XP al perfil
    _checkLevelUp();
    notifyListeners();
    saveData();
  }

  // Verificar si sube de nivel
  void _checkLevelUp() {
    int newLevel = (_points / 100).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _userProfile = _userProfile?.copyWith(level: newLevel);
    }
  }

  // Marcar lugar como visitado
  void visitPlace(String placeId) {
    if (!_visitedPlaces.contains(placeId)) {
      _visitedPlaces.add(placeId);
      incrementStat('placesVisited'); // 🆕 Actualizar estadística
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
    incrementStat('triviasCompleted'); // 🆕 Actualizar estadística
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
      incrementStat('petsOwned'); // 🆕 Actualizar estadística
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
    incrementStat('petsFed'); // 🆕 Actualizar estadística

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
    incrementStat('itemsPurchased'); // 🆕 Actualizar estadística
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
