import 'package:explora_villahermosa/screens/home_screen.dart';
import 'package:explora_villahermosa/screens/main_navegation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';
import '../utils/page_transtition.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadDataAndNavigate();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  Future<void> _loadDataAndNavigate() async {
    try {
      // Cargar datos del usuario
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.loadData();

      // Esperar mínimo 2.5 segundos para mostrar el splash
      await Future.delayed(const Duration(milliseconds: 2500));

      if (!mounted) return;

      // Verificar si es la primera vez
      final isFirstTime = await StorageService.isFirstLaunch();

      if (isFirstTime) {
        // Ir a onboarding
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const OnboardingScreen()),
        );
      } else {
        // Ir directo al home
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const MainNavigationScreen()),
        );
      }
    } catch (e) {
      debugPrint('Error en splash: $e');
      // En caso de error, ir al home de todos modos
      if (mounted) {
        Navigator.pushReplacement(
          context,
          FadePageRoute(page: const HomeScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade700,
              Colors.deepPurple.shade600,
              Colors.blue.shade600,
              Colors.cyan.shade500,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  // Círculos decorativos de fondo
                  _buildBackgroundCircles(),

                  // Contenido principal
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo/Icono
                            _buildLogo(),

                            SizedBox(
                              height: 40 - (_slideAnimation.value * 0.5),
                            ),

                            // Título
                            Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: _buildTitle(),
                            ),

                            const SizedBox(height: 12),

                            // Subtítulo
                            Transform.translate(
                              offset: Offset(0, _slideAnimation.value * 1.5),
                              child: _buildSubtitle(),
                            ),

                            const SizedBox(height: 60),

                            // Loading indicator
                            _buildLoadingIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Versión en la parte inferior
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'v1.0.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Opacity(
            opacity: 0.1,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -100,
          child: Opacity(
            opacity: 0.1,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.explore,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Explora Villahermosa',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.5,
        shadows: [
          Shadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Descubre • Aprende • Juega',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Cargando...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
