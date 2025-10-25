// lib/providers/pet_provider.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class PetProvider extends ChangeNotifier {
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

  String _currentPet = 'iguana';
  String get currentPet => _currentPet;
  String get selectedPet => _currentPet;

  String _petName = 'Amigo';
  String get petName => _petName;

  int _petLevel = 1;
  int get petLevel => _petLevel;

  int _petHunger = 80;
  int get petHunger => _petHunger;

  int _petHappiness = 80;
  int get petHappiness => _petHappiness;

  int _petExperience = 0;
  int get petExperience => _petExperience;

  void selectPet(String petId) {
    if (_unlockedPets.contains(petId)) {
      _currentPet = petId;
      notifyListeners();
      _saveData();
    }
  }

  void unlockPet(String petId) {
    if (!_unlockedPets.contains(petId)) {
      _unlockedPets.add(petId);
      debugPrint('🐾 Mascota desbloqueada: $petId');
      notifyListeners();
      _saveData();
    }
  }

  bool isPetUnlocked(String petId) => _unlockedPets.contains(petId);

  void feedPet(String foodType) {
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

    debugPrint(
        '🍖 Mascota alimentada: hambre +$hungerRestore, felicidad +$happinessBonus');
    notifyListeners();
    _saveData();
  }

  void playWithPet({String? toyType}) {
    int expGain = 10;
    int happinessGain = 10;
    int hungerLoss = 15;

    if (toyType != null) {
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

    debugPrint(
        '🎾 Jugando con mascota: exp +$expGain, felicidad +$happinessGain');
    notifyListeners();
    _saveData();
  }

  void updatePetExperience(int amount) {
    _petExperience = (_petExperience + amount).clamp(0, 100);
    if (_petExperience >= 100) {
      _petLevel++;
      _petExperience = 0;
      debugPrint('🎉 ¡Mascota subió al nivel $_petLevel!');
    }
    notifyListeners();
  }

  void decreasePetHunger() {
    _petHunger = (_petHunger - 15).clamp(0, 100);
    notifyListeners();
  }

  void setPetName(String name) {
    _petName = name;
    debugPrint('🐾 Nombre de mascota cambiado a: $name');
    notifyListeners();
    _saveData();
  }

  void giveMedicine(String medicineType) {
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
    debugPrint('💊 Medicina aplicada: $medicineType');
    notifyListeners();
    _saveData();
  }

  Future<void> loadData() async {
    debugPrint('🔄 PetProvider: Cargando datos...');
    try {
      final petData = await StorageService.loadPetData();

      _petName = petData['name'] ?? 'Amigo';
      _petLevel = petData['level'] ?? 1;
      _petHunger = petData['hunger'] ?? 80;
      _petHappiness = petData['happiness'] ?? 80;
      _petExperience = petData['experience'] ?? 0;
      _currentPet = petData['selected'] ?? 'iguana';

      debugPrint('✅ PetProvider: Datos cargados - $_petName ($_currentPet)');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ PetProvider: Error: $e');
    }
  }

  Future<void> _saveData() async {
    await StorageService.savePetData({
      'name': _petName,
      'level': _petLevel,
      'hunger': _petHunger,
      'happiness': _petHappiness,
      'experience': _petExperience,
      'selected': _currentPet,
    });
  }
}
