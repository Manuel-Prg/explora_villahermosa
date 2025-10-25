// lib/screens/main_navigation.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'trivia_screen.dart';
import 'map_screen.dart';
import 'ar_screen.dart';
import 'pets_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TriviaScreen(),
    const ARScreen(),
    const MapScreen(),
    const PetsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    debugPrint('✅ MainNavigationScreen iniciado correctamente');
    debugPrint('📱 Pantallas cargadas: ${_screens.length}');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 Renderizando MainNavigationScreen');
    debugPrint('📍 CurrentIndex: $_currentIndex');

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE082),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, 'Inicio', 0),
                _buildNavItem(Icons.quiz_rounded, 'Trivia', 1),
                _buildNavItem(Icons.camera_alt_rounded, 'AR', 2),
                _buildNavItem(Icons.map_rounded, 'Mapa', 3),
                _buildNavItem(Icons.pets_rounded, 'Mascotas', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF5D4037)
                    : const Color(0xFF8D6E63),
                size: isSelected ? 28 : 26,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF5D4037)
                    : const Color(0xFF8D6E63),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
