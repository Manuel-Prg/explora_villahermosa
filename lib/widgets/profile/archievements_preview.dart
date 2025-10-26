// lib/widgets/profile/achievements_preview_widget.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class AchievementsPreviewWidget extends StatelessWidget {
  final DeviceType deviceType;
  final ResponsiveSpacing spacing;

  const AchievementsPreviewWidget({
    super.key,
    required this.deviceType,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(deviceType)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(ResponsiveUtils.getBorderRadius(deviceType)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logros Recientes',
                style: TextStyle(
                  fontSize: bodySize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BadgePreview(
                icon: Icons.explore,
                color: Colors.blue,
                isLocked: false,
              ),
              _BadgePreview(
                icon: Icons.quiz,
                color: Colors.orange,
                isLocked: false,
              ),
              _BadgePreview(
                icon: Icons.star,
                color: Colors.amber,
                isLocked: true,
              ),
              _BadgePreview(
                icon: Icons.pets,
                color: Colors.green,
                isLocked: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgePreview extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isLocked;

  const _BadgePreview({
    required this.icon,
    required this.color,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade200 : color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isLocked ? Colors.grey.shade400 : color,
          width: 2,
        ),
      ),
      child: Icon(
        isLocked ? Icons.lock : icon,
        color: isLocked ? Colors.grey.shade400 : color,
        size: 30,
      ),
    );
  }
}
