import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'dart:math' as math;

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> with TickerProviderStateMixin {
  // Controladores de animación
  late AnimationController _floatingController;
  late AnimationController _heartController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  // Animaciones
  late Animation<double> _floatingAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  // Estados
  bool showHearts = false;
  bool showSparkles = false;
  bool show3DViewer = false;

  // Lista de mascotas
  final List<Map<String, dynamic>> pets = [
    {
      'id': 'iguana',
      'icon': Icons.park,
      'name': 'Iguana',
      'color': const Color(0xFF8BC34A),
      'emoji': '🦎',
      'model': 'assets/models/iguana.glb',
      'hasModel': true, // ✅ TIENE MODELO
      'animationName': null,
    },
    {
      'id': 'mariposa',
      'icon': Icons.flutter_dash,
      'name': 'Mariposa',
      'color': const Color(0xFFFF9800),
      'emoji': '🦋',
      'model': 'assets/models/mariposa.glb',
      'hasModel': true, // ✅ TIENE MODELO
      'animationName': null,
    },
    {
      'id': 'guacamaya',
      'icon': Icons.air,
      'name': 'Guacamaya',
      'color': const Color(0xFFFF5722),
      'emoji': '🦜',
      'model': 'assets/models/guacamaya.glb',
      'hasModel': true, // ✅ TIENE MODELO
      'animationName': null,
    },
    {
      'id': 'cocodrilo',
      'icon': Icons.water_drop,
      'name': 'Cocodrilo',
      'color': const Color(0xFF4CAF50),
      'emoji': '🐊',
      'hasModel': false,
    },
    {
      'id': 'pejelagarto',
      'icon': Icons.waves,
      'name': 'Pejelagarto',
      'color': const Color(0xFF607D8B),
      'emoji': '🐟',
      'hasModel': false,
    },
    {
      'id': 'jaguar',
      'icon': Icons.nightlight_round,
      'name': 'Jaguar',
      'color': const Color(0xFFFFC107),
      'emoji': '🐆',
      'hasModel': false,
    },
    {
      'id': 'pijije',
      'icon': Icons.air,
      'name': 'Pijije',
      'color': const Color(0xFF00BCD4),
      'emoji': '🦆',
      'hasModel': false,
    },
    {
      'id': 'mono_arana',
      'icon': Icons.park,
      'name': 'Mono Araña',
      'color': const Color(0xFFE65100),
      'emoji': '🐒',
      'hasModel': false,
    },
    {
      'id': 'manati',
      'icon': Icons.scuba_diving,
      'name': 'Manatí',
      'color': const Color(0xFF4FC3F7),
      'emoji': '🦭',
      'hasModel': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
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
                padding:
                    EdgeInsets.fromLTRB(20, 20, 20, isSmallScreen ? 12 : 20),
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
      orElse: () => pets.first,
    );

    final displayHeight = isSmallScreen ? 300.0 : 350.0;
    final hasModel = selectedPet['hasModel'] == true;

    return Stack(
      children: [
        // Vista 3D en pantalla completa
        if (show3DViewer && hasModel)
          SizedBox(
            height: displayHeight,
            child: _build3DViewer(selectedPet),
          ),

        // Vista normal con emoji
        if (!show3DViewer)
          _buildEmojiView(
              selectedPet, displayHeight, isSmallScreen, hasModel, provider),

        // Botón flotante de cerrar (solo en modo 3D)
        if (show3DViewer && hasModel)
          Positioned(
            top: 15,
            right: 15,
            child: _buildCloseButton(),
          ),
      ],
    );
  }

  Widget _buildEmojiView(
    Map<String, dynamic> selectedPet,
    double displayHeight,
    bool isSmallScreen,
    bool hasModel,
    AppProvider provider,
  ) {
    return GestureDetector(
      onTap: () => _handlePetTap(hasModel),
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
            ..._buildDecorativeCircles(),
            if (showSparkles) ..._buildSparkles(),
            if (showHearts) ..._buildFloatingHearts(),
            _buildAnimatedPet(selectedPet, isSmallScreen, hasModel, provider),
            _buildSoundButton(),
            _buildTapIndicator(isSmallScreen, hasModel),
          ],
        ),
      ),
    );
  }

  void _handlePetTap(bool hasModel) {
    if (hasModel) {
      setState(() => show3DViewer = true);
    } else {
      _triggerHappiness();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Tu mascota está feliz! 💕'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<Widget> _buildDecorativeCircles() {
    return [
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
    ];
  }

  Widget _buildAnimatedPet(
    Map<String, dynamic> selectedPet,
    bool isSmallScreen,
    bool hasModel,
    AppProvider provider,
  ) {
    return Center(
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
                    _buildPetCircle(selectedPet, hasModel),
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
                    _buildLevelBadge(selectedPet, provider, isSmallScreen),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetCircle(Map<String, dynamic> selectedPet, bool hasModel) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: selectedPet['color'].withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            selectedPet['emoji'],
            style: const TextStyle(fontSize: 120),
          ),
          if (hasModel)
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
                      color: selectedPet['color'].withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.view_in_ar,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(Map<String, dynamic> selectedPet,
      AppProvider provider, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
    );
  }

  Widget _buildSoundButton() {
    return Positioned(
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
    );
  }

  Widget _buildTapIndicator(bool isSmallScreen, bool hasModel) {
    return Positioned(
      bottom: 15,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                hasModel ? Icons.view_in_ar : Icons.touch_app,
                size: isSmallScreen ? 16 : 18,
                color: Colors.purple.shade400,
              ),
              const SizedBox(width: 6),
              Text(
                hasModel ? 'Toca para ver en 3D' : 'Toca a tu mascota',
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
    );
  }

  Widget _build3DViewer(Map<String, dynamic> pet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: pet['color'].withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            ModelViewer(
              backgroundColor: const Color(0xFF1A1A1A),
              key: Key(pet['id']),
              src: pet['model'],
              alt: pet['name'],

              // Configuración de animaciones
              autoPlay: true,
              animationName:
                  null, // null = reproduce TODAS las animaciones del GLB

              // Configuración de AR
              ar: true,
              arModes: const ['scene-viewer', 'webxr', 'quick-look'],

              // Configuración de cámara
              autoRotate:
                  false, // Desactivar rotación automática para ver mejor la animación
              cameraControls: true,
              disableZoom: false,

              // Configuración de carga
              loading: Loading.eager,
              reveal: Reveal.auto,

              // Configuración visual
              shadowIntensity: 1.0,
              shadowSoftness: 0.8,
              exposure: 1.0,

              // Configuración de interacción
              interactionPrompt: InteractionPrompt.auto,
              interactionPromptThreshold: 3000,

              // Configuración de escala y posición
              cameraOrbit: 'auto auto auto', // Posición automática de cámara
              fieldOfView: 'auto',

              // Habilitar todas las animaciones
              animationCrossfadeDuration: 300,
            ),
            // Indicador de carga
            Center(
              child: CircularProgressIndicator(
                color: pet['color'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => setState(() => show3DViewer = false),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red.shade600,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          Icons.close,
          size: 28,
          color: Colors.white,
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
                  icon: Icon(Icons.restaurant_menu,
                      size: isSmallScreen ? 18 : 20),
                  label: Text('Alimentar',
                      style: TextStyle(fontSize: isSmallScreen ? 13 : 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB74D),
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _playWithPet(provider),
                  icon:
                      Icon(Icons.sports_esports, size: isSmallScreen ? 18 : 20),
                  label: Text('Jugar',
                      style: TextStyle(fontSize: isSmallScreen ? 13 : 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
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
            alignment: WrapAlignment.spaceAround,
            spacing: 12.0,
            runSpacing: 12.0,
            children: pets.map((pet) {
              final isSelected = provider.selectedPet == pet['id'];
              final hasModel = pet['hasModel'] == true;

              return GestureDetector(
                onTap: () {
                  provider.selectPet(pet['id']);
                  _triggerHappiness();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Text('Has seleccionado: ${pet['name']}'),
                          if (hasModel) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.view_in_ar,
                                size: 16, color: Colors.white),
                          ],
                        ],
                      ),
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
                  child: Stack(
                    children: [
                      Column(
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
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isSelected
                                  ? pet['color']
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (hasModel)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: pet['color'],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: pet['color'].withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.view_in_ar,
                              size: 14,
                              color: Colors.white,
                            ),
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
      String title, String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
