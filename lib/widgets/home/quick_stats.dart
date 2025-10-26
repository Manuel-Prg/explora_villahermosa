// lib/widgets/home/quick_stats.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/responsive_utils.dart';

class QuickStats extends StatelessWidget {
  final DeviceType deviceType;

  const QuickStats({
    super.key,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<GameProgressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.emoji_events_rounded,
            label: 'Logros',
            value:
                '${progressProvider.achievements.where((a) => a['unlocked'] == true).length}/${progressProvider.achievements.length}',
            color: const Color(0xFF9C27B0),
            gradient: const LinearGradient(
              colors: [Color(0xFFAB47BC), Color(0xFF9C27B0)],
            ),
            deviceType: deviceType,
          ),
        ),
        SizedBox(width: spacing.card),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            label: 'Racha',
            value: '${userProvider.level} días',
            color: const Color(0xFFFF5722),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6F42), Color(0xFFFF5722)],
            ),
            deviceType: deviceType,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Gradient gradient;
  final DeviceType deviceType;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.gradient,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType) + 2;
    final iconSize = deviceType == DeviceType.desktop
        ? 34.0
        : (deviceType == DeviceType.tablet ? 32.0 : 30.0);
    final labelSize = ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final valueSize = deviceType == DeviceType.desktop
        ? 22.0
        : (deviceType == DeviceType.tablet ? 20.0 : 18.0);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: iconSize),
          SizedBox(
              height: deviceType == DeviceType.desktop
                  ? 12
                  : (deviceType == DeviceType.tablet ? 10 : 10)),
          Text(
            label,
            style: TextStyle(
              fontSize: labelSize + 1,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
