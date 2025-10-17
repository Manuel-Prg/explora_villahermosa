import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dart:math' as math;

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _heartController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  bool showHearts = false;
  bool showSparkles = false;

  final List<Map<String, dynamic>> pets = [
    {
      'id': 'iguana',
      'icon': Icons.park,
      'name': 'Iguana',
      'color': const Color(0xFF8BC34A), // Verde claro
      'emoji': '🦎',
    },
    {
      'id': 'hicotea',
      'icon': Icons.water,
      'name': 'Hicotea',
      'color': const Color(0xFF795548), // Café
      'emoji': '🐢',
    },
    {
      'id': 'coati',
      'icon': Icons.forest,
      'name': 'Coatí',
      'color': const Color(0xFFFF9800), // Naranja
      'emoji': '🦝', // Emoji de mapache (el más parecido)
    },
    {
      'id': 'cocodrilo',
      'icon': Icons.water_drop,
      'name': 'Cocodrilo',
      'color': const Color(0xFF4CAF50), // Verde oscuro
      'emoji': '🐊',
    },
    {
      'id': 'pejelagarto',
      'icon': Icons.waves,
      'name': 'Pejelagarto',
      'color': const Color(0xFF607D8B), // Gris azulado
      'emoji': '🐟',
    },
    {
      'id': 'jaguar',
      'icon': Icons.nightlight_round,
      'name': 'Jaguar',
      'color': const Color(0xFFFFC107), // Ámbar/Dorado
      'emoji': '🐆',
    },
    {
      'id': 'pijije',
      'icon': Icons.air,
      'name': 'Pijije',
      'color': const Color(0xFF00BCD4), // Cyan
      'emoji': '🦆',
    },
    {
      'id': 'mono_arana',
      'icon': Icons.park,
      'name': 'Mono Araña',
      'color': const Color(0xFFE65100), // Naranja oscuro
      'emoji': '🐒',
    },
    {
      'id': 'manati',
      'icon': Icons.scuba_diving,
      'name': 'Manatí',
      'color': const Color(0xFF4FC3F7), // Azul claro
      'emoji': '🦭', // Emoji de foca (el más parecido)
    },
  ];

  @override
  void initState() {
    super.initState();

    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotateAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.elasticOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _heartController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerHappiness() {
    setState(() {
      showHearts = true;
      showSparkles = true;
    });
    _heartController.forward(from: 0);
    _rotateController.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          showHearts = false;
          showSparkles = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(provider, screenWidth),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  isSmallScreen ? 12 : 20,
                ),
                child: Column(
                  children: [
                    _buildPetDisplay(provider, screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    _buildStatsCard(provider, screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    _buildPetSelector(provider, screenWidth, isSmallScreen),
                    SizedBox(
                        height: bottomPadding > 0 ? bottomPadding + 16 : 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider, double screenWidth) {
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.blue.shade400],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tu Mascota',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.stars,
                  color: Colors.amber.shade300,
                  size: isSmallScreen ? 18 : 20,
                ),
                const SizedBox(width: 5),
                Text(
                  '${provider.points}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetDisplay(
      AppProvider provider, double screenWidth, bool isSmallScreen) {
    final selectedPet = pets.firstWhere(
      (pet) => pet['id'] == provider.selectedPet,
      orElse: () => pets.first, // <--- AÑADE ESTO
    );

    final displayHeight = isSmallScreen ? 300.0 : 350.0;

    return GestureDetector(
      onTap: () {
        _triggerHappiness();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Tu mascota está feliz! 💕'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        height: displayHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade300,
              Colors.blue.shade300,
              Colors.cyan.shade300,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),

            // Sparkles
            if (showSparkles) ..._buildSparkles(),

            // Floating hearts animation
            if (showHearts) ..._buildFloatingHearts(),

            // Pet with emoji and animations
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _floatingAnimation,
                  _rotateAnimation,
                  _pulseAnimation,
                ]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated pet container
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        selectedPet['color'].withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Emoji grande
                                  Text(
                                    selectedPet['emoji'],
                                    style: const TextStyle(fontSize: 120),
                                  ),
                                  // Ícono decorativo pequeño
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: selectedPet['color'],
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: selectedPet['color']
                                                .withOpacity(0.5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        selectedPet['icon'],
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 15 : 20),
                            Text(
                              provider.petName,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars,
                                    color: selectedPet['color'],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Nivel ${provider.petLevel}',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: selectedPet['color'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Sound button
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.volume_up, color: Color(0xFFFFB74D)),
                  onPressed: _triggerHappiness,
                ),
              ),
            ),

            // Tap indicator
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: isSmallScreen ? 16 : 18,
                        color: Colors.purple.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Toca a tu mascota',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingHearts() {
    return List.generate(5, (index) {
      final delay = index * 0.2;
      final leftPosition = 50.0 + (index * 50.0);
      return Positioned(
        left: leftPosition,
        bottom: 100,
        child: AnimatedBuilder(
          animation: _heartController,
          builder: (context, child) {
            final progress = (_heartController.value - delay).clamp(0.0, 1.0);
            return Transform.translate(
              offset: Offset(
                math.sin(progress * math.pi * 2) * 20,
                -progress * 150,
              ),
              child: Opacity(
                opacity: 1 - progress,
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink.shade300,
                  size: 30,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  List<Widget> _buildSparkles() {
    final random = math.Random();
    return List.generate(8, (index) {
      final delay = index * 0.15;
      return Positioned(
        left: random.nextDouble() * 300,
        top: random.nextDouble() * 300,
        child: AnimatedBuilder(
          animation: _heartController,
          builder: (context, child) {
            final progress = (_heartController.value - delay).clamp(0.0, 1.0);
            return Transform.scale(
              scale: 1 - progress,
              child: Opacity(
                opacity: 1 - progress,
                child: Icon(
                  Icons.star,
                  color: Colors.yellow.shade300,
                  size: 20,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildStatsCard(
      AppProvider provider, double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.purple.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatBar(
            label: 'Hambre',
            value: provider.petHunger,
            color: const Color(0xFFFFB74D),
            icon: Icons.restaurant,
            isSmallScreen: isSmallScreen,
          ),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildStatBar(
            label: 'Experiencia',
            value: provider.petExperience,
            color: const Color(0xFF66BB6A),
            icon: Icons.star,
            isSmallScreen: isSmallScreen,
          ),
          SizedBox(height: isSmallScreen ? 20 : 25),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _feedPet(provider),
                  icon: Icon(
                    Icons.restaurant_menu,
                    size: isSmallScreen ? 18 : 20,
                  ),
                  label: Text(
                    'Alimentar',
                    style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB74D),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _playWithPet(provider),
                  icon: Icon(
                    Icons.sports_esports,
                    size: isSmallScreen ? 18 : 20,
                  ),
                  label: Text(
                    'Jugar',
                    style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar({
    required String label,
    required int value,
    required Color color,
    required IconData icon,
    required bool isSmallScreen,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: isSmallScreen ? 18 : 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : 12,
                vertical: isSmallScreen ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$value%',
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: isSmallScreen ? 10 : 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value / 100,
              child: Container(
                height: isSmallScreen ? 10 : 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.3), blurRadius: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPetSelector(
      AppProvider provider, double screenWidth, bool isSmallScreen) {
    final cardSize = screenWidth < 360 ? 80.0 : 90.0;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.purple.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona tu mascota',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 15),
          Wrap(
            alignment: WrapAlignment.spaceAround, // Alinea las tarjetas
            spacing: 12.0, // Espacio horizontal entre tarjetas
            runSpacing: 12.0, // Espacio vertical entre filas
            children: pets.map((pet) {
              final isSelected = provider.selectedPet == pet['id'];
              return GestureDetector(
                onTap: () {
                  provider.selectPet(pet['id']);
                  _triggerHappiness();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Has seleccionado: ${pet['name']}'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: pet['color'],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: cardSize,
                  height: cardSize,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? pet['color'].withOpacity(0.2)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? pet['color'] : Colors.grey.shade300,
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: pet['color'].withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pet['emoji'],
                        style: TextStyle(fontSize: isSmallScreen ? 32 : 40),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        pet['name'],
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color:
                              isSelected ? pet['color'] : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _feedPet(AppProvider provider) {
    if (provider.points >= 10) {
      provider.feedPet(20);
      _triggerHappiness();
      _showSuccessDialog(
        '¡Mascota alimentada!',
        'Tu mascota está feliz y llena. -10 monedas',
        Icons.restaurant,
        const Color(0xFFFFB74D),
      );
    } else {
      _showErrorDialog(
          'No tienes suficientes monedas para alimentar a tu mascota.');
    }
  }

  void _playWithPet(AppProvider provider) {
    provider.updatePetExperience(10);
    provider.decreasePetHunger();
    _triggerHappiness();
    _showSuccessDialog(
      '¡Jugaste con tu mascota!',
      'Ganaste +10 de experiencia. ¡Tu mascota está feliz!',
      Icons.sports_esports,
      const Color(0xFF66BB6A),
    );
  }

  void _showSuccessDialog(
    String title,
    String message,
    IconData icon,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 50, color: color),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8D6E63),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Icon(Icons.error_outline, size: 50, color: Colors.red),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
