// lib/widgets/pets/pet_display.dart
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'dart:math' as math;
import '../../providers/pet_provider.dart';
import '../../models/pet_model.dart';
import '../../utils/responsive_utils.dart';

class PetDisplayWidget extends StatelessWidget {
  final PetProvider provider;
  final DeviceType deviceType;
  final Animation<double> floatingAnimation;
  final Animation<double> rotateAnimation;
  final Animation<double> pulseAnimation;
  final AnimationController heartController;
  final bool showHearts;
  final bool showSparkles;
  final bool show3DViewer;
  final VoidCallback onTriggerHappiness;
  final Function(bool) onToggle3DViewer;

  const PetDisplayWidget({
    super.key,
    required this.provider,
    required this.deviceType,
    required this.floatingAnimation,
    required this.rotateAnimation,
    required this.pulseAnimation,
    required this.heartController,
    required this.showHearts,
    required this.showSparkles,
    required this.show3DViewer,
    required this.onTriggerHappiness,
    required this.onToggle3DViewer,
  });

  @override
  Widget build(BuildContext context) {
    final selectedPet = PetsData.getPetById(provider.selectedPet);
    final displayHeight = _getDisplayHeight();

    return Stack(
      children: [
        if (show3DViewer && selectedPet.hasModel)
          _build3DViewer(selectedPet, displayHeight, context),
        if (!show3DViewer) _buildEmojiView(selectedPet, displayHeight, context),
        if (show3DViewer && selectedPet.hasModel)
          Positioned(
            top: 15,
            right: 15,
            child: _buildCloseButton(),
          ),
      ],
    );
  }

  double _getDisplayHeight() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 320.0;
      case DeviceType.tablet:
        return 420.0;
      case DeviceType.desktop:
        return 480.0;
    }
  }

  Widget _buildEmojiView(
    PetModel selectedPet,
    double displayHeight,
    BuildContext context,
  ) {
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    return GestureDetector(
      onTap: () => _handlePetTap(selectedPet, context),
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
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 5,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            ..._buildDecorativeCircles(),
            if (showSparkles) ..._buildSparkles(),
            if (showHearts) ..._buildFloatingHearts(),
            _buildAnimatedPet(selectedPet),
            _buildSoundButton(),
            _buildTapIndicator(selectedPet),
          ],
        ),
      ),
    );
  }

  void _handlePetTap(PetModel pet, BuildContext context) {
    if (pet.hasModel) {
      onToggle3DViewer(true);
    } else {
      onTriggerHappiness();
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

  Widget _buildAnimatedPet(PetModel selectedPet) {
    final petSize = _getPetCircleSize();
    final emojiSize = _getPetEmojiSize();
    final fontSize = ResponsiveUtils.getFontSize(deviceType, FontSize.heading);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          floatingAnimation,
          rotateAnimation,
          pulseAnimation,
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, floatingAnimation.value),
            child: Transform.rotate(
              angle: rotateAnimation.value,
              child: Transform.scale(
                scale: pulseAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPetCircle(selectedPet, petSize, emojiSize),
                    SizedBox(height: deviceType == DeviceType.mobile ? 15 : 20),
                    Text(
                      provider.petName,
                      style: TextStyle(
                        fontSize: fontSize,
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
                    _buildLevelBadge(selectedPet, captionSize),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _getPetCircleSize() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 180.0;
      case DeviceType.tablet:
        return 240.0;
      case DeviceType.desktop:
        return 280.0;
    }
  }

  double _getPetEmojiSize() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 110.0;
      case DeviceType.tablet:
        return 140.0;
      case DeviceType.desktop:
        return 160.0;
    }
  }

  Widget _buildPetCircle(PetModel pet, double size, double emojiSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: pet.color.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            pet.emoji,
            style: TextStyle(fontSize: emojiSize),
          ),
          if (pet.hasModel)
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: pet.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: pet.color.withOpacity(0.5),
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

  Widget _buildLevelBadge(PetModel pet, double fontSize) {
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
            color: pet.color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'Nivel ${provider.petLevel}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: pet.color,
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
          onPressed: onTriggerHappiness,
        ),
      ),
    );
  }

  Widget _buildTapIndicator(PetModel pet) {
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.small);

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
                pet.hasModel ? Icons.view_in_ar : Icons.touch_app,
                size: iconSize,
                color: Colors.purple.shade400,
              ),
              const SizedBox(width: 6),
              Text(
                pet.hasModel ? 'Toca para ver en 3D' : 'Toca a tu mascota',
                style: TextStyle(
                  fontSize: captionSize,
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

  Widget _build3DViewer(PetModel pet, double height, BuildContext context) {
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: pet.color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            ModelViewer(
              backgroundColor: const Color(0xFF1A1A1A),
              key: Key(pet.id),
              src: pet.model!,
              alt: pet.name,
              autoPlay: true,
              animationName: pet.animationName,
              ar: true,
              arModes: const ['scene-viewer', 'webxr', 'quick-look'],
              autoRotate: true,
              autoRotateDelay: 0,
              cameraControls: true,
              disableZoom: false,
              loading: Loading.eager,
              reveal: Reveal.auto,
              shadowIntensity: 1.0,
              shadowSoftness: 0.8,
              exposure: 1.0,
              interactionPrompt: InteractionPrompt.auto,
              interactionPromptThreshold: 3000,
              cameraOrbit: 'auto auto auto',
              fieldOfView: 'auto',
              animationCrossfadeDuration: 300,
            ),
            Center(
              child: CircularProgressIndicator(
                color: pet.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => onToggle3DViewer(false),
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
          animation: heartController,
          builder: (context, child) {
            final progress = (heartController.value - delay).clamp(0.0, 1.0);
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
          animation: heartController,
          builder: (context, child) {
            final progress = (heartController.value - delay).clamp(0.0, 1.0);
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
}
