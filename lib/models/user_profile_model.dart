// lib/models/user_profile_model.dart
class UserProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final int level;
  final int totalPoints;
  final int currentXP;
  final DateTime createdAt;
  final DateTime lastLogin;
  final UserStats stats;
  final UserPreferences preferences;

  UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl = '',
    required this.level,
    required this.totalPoints,
    required this.currentXP,
    required this.createdAt,
    required this.lastLogin,
    required this.stats,
    required this.preferences,
  });

  /// XP necesario para subir al siguiente nivel
  int get xpForNextLevel => _calculateXPForLevel(level + 1);

  /// Progreso hacia el siguiente nivel (0.0 - 1.0)
  double get levelProgress {
    final xpForCurrent = _calculateXPForLevel(level);
    final xpForNext = _calculateXPForLevel(level + 1);
    final xpInLevel = currentXP - xpForCurrent;
    final xpNeeded = xpForNext - xpForCurrent;
    return (xpInLevel / xpNeeded).clamp(0.0, 1.0);
  }

  /// Calcular XP total necesario para un nivel
  int _calculateXPForLevel(int targetLevel) {
    if (targetLevel <= 1) return 0;
    // Fórmula: nivel * 100 (100, 200, 300, etc.)
    return (targetLevel - 1) * 100;
  }

  /// Crear perfil inicial por defecto
  factory UserProfile.initial() {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Explorador',
      level: 1,
      totalPoints: 100,
      currentXP: 0,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      stats: UserStats.initial(),
      preferences: UserPreferences.initial(),
    );
  }

  /// Crear desde JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Explorador',
      avatarUrl: json['avatarUrl'] ?? '',
      level: json['level'] ?? 1,
      totalPoints: json['totalPoints'] ?? 100,
      currentXP: json['currentXP'] ?? 0,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin:
          DateTime.parse(json['lastLogin'] ?? DateTime.now().toIso8601String()),
      stats: UserStats.fromJson(json['stats'] ?? {}),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'level': level,
      'totalPoints': totalPoints,
      'currentXP': currentXP,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'stats': stats.toJson(),
      'preferences': preferences.toJson(),
    };
  }

  /// Copiar con modificaciones
  UserProfile copyWith({
    String? name,
    String? avatarUrl,
    int? level,
    int? totalPoints,
    int? currentXP,
    DateTime? lastLogin,
    UserStats? stats,
    UserPreferences? preferences,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      totalPoints: totalPoints ?? this.totalPoints,
      currentXP: currentXP ?? this.currentXP,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      stats: stats ?? this.stats,
      preferences: preferences ?? this.preferences,
    );
  }
}

/// Estadísticas del usuario
class UserStats {
  final int placesVisited;
  final int triviasCompleted;
  final int daysStreak;
  final int petsOwned;
  final int itemsPurchased;
  final int petsFed;
  final int achievementsUnlocked;

  UserStats({
    required this.placesVisited,
    required this.triviasCompleted,
    required this.daysStreak,
    required this.petsOwned,
    required this.itemsPurchased,
    required this.petsFed,
    required this.achievementsUnlocked,
  });

  /// Progreso de exploración (basado en lugares visitados)
  double get explorationProgress {
    const maxPlaces = 50; // Total de lugares en el juego
    return (placesVisited / maxPlaces).clamp(0.0, 1.0);
  }

  /// Progreso de conocimiento (basado en trivias)
  double get knowledgeProgress {
    const maxTrivias = 100; // Total de trivias disponibles
    return (triviasCompleted / maxTrivias).clamp(0.0, 1.0);
  }

  /// Progreso de mascotas (basado en mascotas desbloqueadas)
  double get petsProgress {
    const maxPets = 9; // Total de mascotas disponibles
    return (petsOwned / maxPets).clamp(0.0, 1.0);
  }

  /// Crear stats iniciales
  factory UserStats.initial() {
    return UserStats(
      placesVisited: 0,
      triviasCompleted: 0,
      daysStreak: 0,
      petsOwned: 1, // Empieza con una mascota (iguana)
      itemsPurchased: 0,
      petsFed: 0,
      achievementsUnlocked: 0,
    );
  }

  /// Crear desde JSON
  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      placesVisited: json['placesVisited'] ?? 0,
      triviasCompleted: json['triviasCompleted'] ?? 0,
      daysStreak: json['daysStreak'] ?? 0,
      petsOwned: json['petsOwned'] ?? 1,
      itemsPurchased: json['itemsPurchased'] ?? 0,
      petsFed: json['petsFed'] ?? 0,
      achievementsUnlocked: json['achievementsUnlocked'] ?? 0,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'placesVisited': placesVisited,
      'triviasCompleted': triviasCompleted,
      'daysStreak': daysStreak,
      'petsOwned': petsOwned,
      'itemsPurchased': itemsPurchased,
      'petsFed': petsFed,
      'achievementsUnlocked': achievementsUnlocked,
    };
  }

  /// Copiar con modificaciones
  UserStats copyWith({
    int? placesVisited,
    int? triviasCompleted,
    int? daysStreak,
    int? petsOwned,
    int? itemsPurchased,
    int? petsFed,
    int? achievementsUnlocked,
  }) {
    return UserStats(
      placesVisited: placesVisited ?? this.placesVisited,
      triviasCompleted: triviasCompleted ?? this.triviasCompleted,
      daysStreak: daysStreak ?? this.daysStreak,
      petsOwned: petsOwned ?? this.petsOwned,
      itemsPurchased: itemsPurchased ?? this.itemsPurchased,
      petsFed: petsFed ?? this.petsFed,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
    );
  }

  /// Incrementar una estadística específica
  UserStats incrementStat(String statName, [int amount = 1]) {
    switch (statName) {
      case 'placesVisited':
        return copyWith(placesVisited: placesVisited + amount);
      case 'triviasCompleted':
        return copyWith(triviasCompleted: triviasCompleted + amount);
      case 'daysStreak':
        return copyWith(daysStreak: daysStreak + amount);
      case 'petsOwned':
        return copyWith(petsOwned: petsOwned + amount);
      case 'itemsPurchased':
        return copyWith(itemsPurchased: itemsPurchased + amount);
      case 'petsFed':
        return copyWith(petsFed: petsFed + amount);
      case 'achievementsUnlocked':
        return copyWith(achievementsUnlocked: achievementsUnlocked + amount);
      default:
        return this;
    }
  }
}

/// Preferencias del usuario
class UserPreferences {
  final bool soundEnabled;
  final bool musicEnabled;
  final bool notificationsEnabled;
  final bool arEnabled;
  final String language;

  UserPreferences({
    required this.soundEnabled,
    required this.musicEnabled,
    required this.notificationsEnabled,
    required this.arEnabled,
    required this.language,
  });

  /// Crear preferencias iniciales
  factory UserPreferences.initial() {
    return UserPreferences(
      soundEnabled: true,
      musicEnabled: true,
      notificationsEnabled: true,
      arEnabled: true,
      language: 'es',
    );
  }

  /// Crear desde JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      soundEnabled: json['soundEnabled'] ?? true,
      musicEnabled: json['musicEnabled'] ?? true,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      arEnabled: json['arEnabled'] ?? true,
      language: json['language'] ?? 'es',
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'notificationsEnabled': notificationsEnabled,
      'arEnabled': arEnabled,
      'language': language,
    };
  }

  /// Copiar con modificaciones
  UserPreferences copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? notificationsEnabled,
    bool? arEnabled,
    String? language,
  }) {
    return UserPreferences(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      arEnabled: arEnabled ?? this.arEnabled,
      language: language ?? this.language,
    );
  }
}
