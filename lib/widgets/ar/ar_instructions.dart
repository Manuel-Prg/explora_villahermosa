import 'package:flutter/material.dart';
import '../../models/monument_model.dart';
import '../../utils/responsive_utils.dart';

class ARInstructionsWidget extends StatelessWidget {
  final MonumentModel monument;
  final AnimationController pulseController;
  final DeviceType deviceType;

  const ARInstructionsWidget({
    super.key,
    required this.monument,
    required this.pulseController,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.heading);
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    // Ajustar padding para pantallas pequeñas
    final horizontalMargin = deviceType == DeviceType.mobile
        ? (screenHeight < 700 ? cardPadding * 0.8 : cardPadding)
        : cardPadding;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
      ),
      padding: EdgeInsets.all(
        screenHeight < 700 ? cardPadding * 0.8 : cardPadding,
      ),
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.getMaxContentWidth(deviceType),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPulsingIcon(screenHeight),
          SizedBox(
              height: screenHeight < 700 ? spacing.card : spacing.subsection),
          Text(
            monument.name,
            style: TextStyle(
              fontSize: screenHeight < 700 ? titleSize * 0.9 : titleSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.card),
          Text(
            'Toca el botón "Ver 3D" en las tarjetas para visualizar el monumento',
            style: TextStyle(
              fontSize: screenHeight < 700 ? bodySize * 0.9 : bodySize,
              color: const Color(0xFF8D6E63),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (deviceType != DeviceType.mobile && screenHeight >= 700) ...[
            SizedBox(height: spacing.subsection),
            _buildHintBox(bodySize),
          ],
        ],
      ),
    );
  }

  Widget _buildPulsingIcon(double screenHeight) {
    final iconPadding = deviceType == DeviceType.mobile
        ? (screenHeight < 700 ? 12.0 : 16.0)
        : 20.0;
    final iconSize = deviceType == DeviceType.mobile
        ? (screenHeight < 700 ? 35.0 : 40.0)
        : 50.0;

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (pulseController.value * 0.15),
          child: Container(
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  monument.color.withOpacity(0.2),
                  monument.color.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: monument.color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.view_in_ar,
              size: iconSize,
              color: monument.color,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHintBox(double bodySize) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app,
            color: Colors.blue.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Usa los gestos para rotar y acercar',
            style: TextStyle(
              fontSize: bodySize * 0.9,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
