// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;

  int _points = 100;
  int get points => _points;

  int _level = 1;
  int get level => _level;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  void initializeProfile() {
    if (_userProfile == null) {
      _userProfile = UserProfile.initial();
      debugPrint('👤 Perfil inicial creado');
      notifyListeners();
    }
  }

  void updateProfileName(String name) {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(name: name);
      debugPrint('👤 Nombre actualizado: $name');
      notifyListeners();
      saveData();
    }
  }

  void updateProfilePreferences(UserProfile newProfile) {
    _userProfile = newProfile;
    debugPrint('⚙️ Preferencias actualizadas');
    notifyListeners();
    saveData();
  }

  void addPoints(int amount) {
    _points += amount;
    _userProfile = _userProfile?.copyWith(totalPoints: _points);
    addXP(amount);
    _checkLevelUp();
    notifyListeners();
    saveData();
  }

  void addXP(int amount) {
    if (_userProfile == null) return;

    final newXP = _userProfile!.currentXP + amount;
    final xpForNextLevel = _calculateXPForLevel(_userProfile!.level + 1);

    if (newXP >= xpForNextLevel) {
      final newLevel = _userProfile!.level + 1;
      _userProfile = _userProfile!.copyWith(level: newLevel, currentXP: newXP);
      _level = newLevel;
      debugPrint('🎉 ¡Subiste al nivel $newLevel!');
    } else {
      _userProfile = _userProfile!.copyWith(currentXP: newXP);
    }
    notifyListeners();
  }

  int _calculateXPForLevel(int targetLevel) {
    if (targetLevel <= 1) return 0;
    return (targetLevel - 1) * 100;
  }

  void _checkLevelUp() {
    int newLevel = (_points / 100).floor() + 1;
    if (newLevel > _level) {
      _level = newLevel;
      _userProfile = _userProfile?.copyWith(level: newLevel);
    }
  }

  void incrementStat(String statName, [int amount = 1]) {
    if (_userProfile == null) return;
    final newStats = _userProfile!.stats.incrementStat(statName, amount);
    _userProfile = _userProfile!.copyWith(stats: newStats);
    debugPrint('📊 Stat incrementada: $statName +$amount');
    notifyListeners();
  }

  void updateLastLogin() {
    if (_userProfile == null) return;
    _userProfile = _userProfile!.copyWith(lastLogin: DateTime.now());
    notifyListeners();
  }

  int getPointsForNextLevel() {
    return (_level * 100) - _points;
  }

  Future<void> loadData() async {
    debugPrint('🔄 UserProvider: Cargando datos...');
    try {
      final data = await StorageService.loadUserData();

      final profileData = data['profile'];
      if (profileData != null && profileData is Map<String, dynamic>) {
        _userProfile = UserProfile.fromJson(profileData);
        debugPrint('👤 Perfil cargado: ${_userProfile!.name}');
      } else {
        initializeProfile();
      }

      _points = data['points'] ?? 100;
      _level = data['level'] ?? 1;

      if (_userProfile != null && _userProfile!.level != _level) {
        _userProfile = _userProfile!.copyWith(level: _level);
      }

      updateLastLogin();
      _isLoaded = true;
      debugPrint('✅ UserProvider: Datos cargados');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ UserProvider: Error: $e');
      initializeProfile();
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> saveData() async {
    try {
      await StorageService.saveUserData(
        profile: _userProfile?.toJson(),
        points: _points,
        level: _level,
      );
      debugPrint('💾 UserProvider: Datos guardados');
    } catch (e) {
      debugPrint('❌ UserProvider: Error guardando: $e');
    }
  }
}
