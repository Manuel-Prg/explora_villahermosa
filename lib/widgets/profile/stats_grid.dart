import 'package:explora_villahermosa/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class StatsGridWidget extends StatelessWidget {
  final UserProfile profile;
  final DeviceType deviceType;
  final ResponsiveSpacing spacing;

  const StatsGridWidget({
    super.key,
    required this.profile,
    required this.deviceType,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final stats = profile.stats;
    final columns = deviceType == DeviceType.mobile ? 2 : 4;

    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: spacing.card,
      mainAxisSpacing: spacing.card,
      childAspectRatio: 1.2,
      children: [
        _StatCard(
          icon: Icons.place,
          value: stats.placesVisited.toString(),
          label: 'Lugares',
          color: Colors.blue,
          deviceType: deviceType,
        ),
        _StatCard(
          icon: Icons.quiz,
          value: stats.triviasCompleted.toString(),
          label: 'Trivias',
          color: Colors.orange,
          deviceType: deviceType,
        ),
        _StatCard(
          icon: Icons.local_fire_department,
          value: stats.daysStreak.toString(),
          label: 'Días Racha',
          color: Colors.red,
          deviceType: deviceType,
        ),
        _StatCard(
          icon: Icons.pets,
          value: stats.petsOwned.toString(),
          label: 'Mascotas',
          color: Colors.green,
          deviceType: deviceType,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final DeviceType deviceType;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getCardPadding(deviceType)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(deviceType) * 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: deviceType == DeviceType.mobile ? 24 : 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: bodySize * 1.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: captionSize,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
