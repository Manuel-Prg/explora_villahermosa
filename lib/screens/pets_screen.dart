import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/pets/pet_display_widget.dart';
import '../widgets/pets/pet_stats_widget.dart';
import '../widgets/pets/pet_selector.dart';
import '../widgets/pets/pets_header_widget.dart';
import '../utils/responsive_utils.dart';

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

  void triggerHappiness() {
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

  void toggle3DViewer(bool value) {
    setState(() => show3DViewer = value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceType = ResponsiveUtils.getDeviceType(screenWidth);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PetsHeaderWidget(provider: provider),
            Expanded(
              child: _buildResponsiveLayout(
                provider,
                deviceType,
                spacing,
                screenWidth,
                screenHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(
    AppProvider provider,
    DeviceType deviceType,
    ResponsiveSpacing spacing,
    double screenWidth,
    double screenHeight,
  ) {
    // Tablet en horizontal: layout de 2 columnas
    if (deviceType == DeviceType.tablet && screenWidth > screenHeight) {
      return _buildTwoColumnLayout(provider, deviceType, spacing);
    }

    // Tablet vertical, desktop o móvil: layout de 1 columna con max width
    return _buildSingleColumnLayout(provider, deviceType, spacing);
  }

  Widget _buildTwoColumnLayout(
    AppProvider provider,
    DeviceType deviceType,
    ResponsiveSpacing spacing,
  ) {
    final padding = ResponsiveUtils.getScreenPadding(deviceType);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda: Display de mascota
        Expanded(
          flex: 5,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: padding.left,
              top: padding.top,
              bottom: padding.bottom,
              right: spacing.card,
            ),
            child: PetDisplayWidget(
              provider: provider,
              deviceType: deviceType,
              floatingAnimation: _floatingAnimation,
              rotateAnimation: _rotateAnimation,
              pulseAnimation: _pulseAnimation,
              heartController: _heartController,
              showHearts: showHearts,
              showSparkles: showSparkles,
              show3DViewer: show3DViewer,
              onTriggerHappiness: triggerHappiness,
              onToggle3DViewer: toggle3DViewer,
            ),
          ),
        ),

        // Columna derecha: Stats y selector
        Expanded(
          flex: 4,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              right: padding.right,
              top: padding.top,
              bottom: padding.bottom,
              left: spacing.card,
            ),
            child: Column(
              children: [
                PetStatsWidget(
                  provider: provider,
                  deviceType: deviceType,
                  onFeedPet: () => _feedPet(provider),
                  onPlayWithPet: () => _playWithPet(provider),
                ),
                SizedBox(height: spacing.section),
                PetSelectorWidget(
                  provider: provider,
                  deviceType: deviceType,
                  onPetSelected: (petId, petName, petColor, hasModel) {
                    provider.selectPet(petId);
                    triggerHappiness();
                    _showPetSelectedSnackbar(petName, petColor, hasModel);
                  },
                ),
                SizedBox(height: spacing.section),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleColumnLayout(
    AppProvider provider,
    DeviceType deviceType,
    ResponsiveSpacing spacing,
  ) {
    final padding = ResponsiveUtils.getScreenPadding(deviceType);
    final maxWidth = ResponsiveUtils.getMaxContentWidth(deviceType);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            top: padding.top,
            bottom: bottomPadding > 0 ? bottomPadding + 20 : padding.bottom,
          ),
          child: Column(
            children: [
              PetDisplayWidget(
                provider: provider,
                deviceType: deviceType,
                floatingAnimation: _floatingAnimation,
                rotateAnimation: _rotateAnimation,
                pulseAnimation: _pulseAnimation,
                heartController: _heartController,
                showHearts: showHearts,
                showSparkles: showSparkles,
                show3DViewer: show3DViewer,
                onTriggerHappiness: triggerHappiness,
                onToggle3DViewer: toggle3DViewer,
              ),
              SizedBox(height: spacing.section),
              PetStatsWidget(
                provider: provider,
                deviceType: deviceType,
                onFeedPet: () => _feedPet(provider),
                onPlayWithPet: () => _playWithPet(provider),
              ),
              SizedBox(height: spacing.section),
              PetSelectorWidget(
                provider: provider,
                deviceType: deviceType,
                onPetSelected: (petId, petName, petColor, hasModel) {
                  provider.selectPet(petId);
                  triggerHappiness();
                  _showPetSelectedSnackbar(petName, petColor, hasModel);
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _feedPet(AppProvider provider) {
    if (provider.points >= 10) {
      provider.feedPet(20);
      triggerHappiness();
      _showSuccessDialog(
        '¡Mascota alimentada!',
        'Tu mascota está feliz y llena. -10 monedas',
        Icons.restaurant,
        const Color(0xFFFFB74D),
      );
    } else {
      _showErrorDialog(
        'No tienes suficientes monedas para alimentar a tu mascota.',
      );
    }
  }

  void _playWithPet(AppProvider provider) {
    provider.updatePetExperience(10);
    provider.decreasePetHunger();
    triggerHappiness();
    _showSuccessDialog(
      '¡Jugaste con tu mascota!',
      'Ganaste +10 de experiencia. ¡Tu mascota está feliz!',
      Icons.sports_esports,
      const Color(0xFF66BB6A),
    );
  }

  void _showPetSelectedSnackbar(
    String petName,
    Color petColor,
    bool hasModel,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('Has seleccionado: $petName'),
            if (hasModel) ...[
              const SizedBox(width: 8),
              const Icon(Icons.view_in_ar, size: 16, color: Colors.white),
            ],
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: petColor,
        behavior: SnackBarBehavior.floating,
      ),
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
