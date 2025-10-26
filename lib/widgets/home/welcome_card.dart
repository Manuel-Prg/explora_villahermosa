// lib/widgets/home/welcome_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../providers/user_provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../utils/responsive_utils.dart';

class WelcomeCard extends StatelessWidget {
  final DeviceType deviceType;
  final AnimationController floatController;

  const WelcomeCard({
    super.key,
    required this.deviceType,
    required this.floatController,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final progressProvider = Provider.of<GameProgressProvider>(context);
    final progressValue = (userProvider.points % 100) / 100;

    return AnimatedBuilder(
      animation: floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(floatController.value * math.pi * 2) * 3),
          child: _buildCard(
              context, userProvider, progressProvider, progressValue),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, UserProvider userProvider,
      GameProgressProvider progressProvider, double progressValue) {
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType) + 6;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1, -1),
          end: Alignment(1, 1),
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8C42),
            Color(0xFFFFAA64),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C42).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLevelInfo(userProvider, progressProvider),
          SizedBox(
              height: deviceType == DeviceType.desktop
                  ? 22
                  : (deviceType == DeviceType.tablet ? 20 : 18)),
          _buildProgressBar(userProvider, progressValue),
        ],
      ),
    );
  }

  Widget _buildLevelInfo(
      UserProvider userProvider, GameProgressProvider progressProvider) {
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.large);
    final levelSize = deviceType == DeviceType.desktop
        ? 26.0
        : (deviceType == DeviceType.tablet ? 24.0 : 22.0);
    final textSize = deviceType == DeviceType.desktop
        ? 16.0
        : (deviceType == DeviceType.tablet ? 15.0 : 14.0);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(iconSize * 0.4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            Icons.emoji_events,
            color: const Color(0xFFFF9800),
            size: iconSize,
          ),
        ),
        SizedBox(
            width: deviceType == DeviceType.desktop
                ? 20
                : (deviceType == DeviceType.tablet ? 18 : 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Nivel ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: levelSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceType == DeviceType.desktop
                          ? 16
                          : (deviceType == DeviceType.tablet ? 14 : 12),
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${userProvider.level}',
                      style: TextStyle(
                        color: const Color(0xFFFF9800),
                        fontSize: levelSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${progressProvider.visitedPlaces.length} lugares visitados 📍',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(UserProvider userProvider, double progressValue) {
    final fontSize = ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final barHeight = deviceType == DeviceType.desktop
        ? 12.0
        : (deviceType == DeviceType.tablet ? 11.0 : 10.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progreso al siguiente nivel',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: fontSize + 1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progressValue * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize + 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progressValue,
                child: Container(
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${userProvider.getPointsForNextLevel()} puntos restantes',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
