import 'package:flutter/material.dart';

class PetAvatar extends StatefulWidget {
  final String petName;
  final double size;

  const PetAvatar({
    super.key,
    required this.petName,
    required this.size,
  });

  @override
  State<PetAvatar> createState() => _PetAvatarState();
}

class _PetAvatarState extends State<PetAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: _buildPetContainer(),
          ),
        );
      },
    );
  }

  Widget _buildPetContainer() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: -5,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: widget.size * 0.015, // Borde proporcional
        ),
      ),
      child: ClipOval(
        child: Stack(
          children: [
            // Imagen de la mascota
            Center(
              child: Image.asset(
                _getPetImage(widget.petName),
                width: widget.size * 0.7, // 70% del tamaño del contenedor
                height: widget.size * 0.7,
                fit: BoxFit.contain,
              ),
            ),

            // Badge de configuración (opcional)
            Positioned(
              right: widget.size * 0.05,
              bottom: widget.size * 0.05,
              child: Container(
                padding: EdgeInsets.all(widget.size * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.settings,
                  color: Colors.grey.shade600,
                  size: widget.size * 0.08, // Icono proporcional
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPetImage(String petName) {
    // Mapeo de nombres de mascotas a sus imágenes
    final petImages = {
      'Amigo': 'assets/images/iguana.png',
      'Luna': 'assets/images/luna.png',
      'Max': 'assets/images/max.png',
      'Nala': 'assets/images/nala.png',
    };

    return petImages[petName] ?? 'assets/images/iguana.png';
  }
}
