import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class PetInfoCard extends StatelessWidget {
  final int points;
  final int visitedPlaces;

  const PetInfoCard({
    super.key,
    required this.points,
    required this.visitedPlaces,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    return Container(
      padding: EdgeInsets.all(spacing.subsection),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.stars,
            label: 'Puntos',
            value: points.toString(),
            color: Colors.amber.shade600,
            deviceType: deviceType,
            spacing: spacing,
          ),
          Container(
            width: 2,
            height: ResponsiveUtils.getIconSize(
              deviceType,
              IconSizeType.large,
            ),
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            icon: Icons.place,
            label: 'Lugares',
            value: visitedPlaces.toString(),
            color: Colors.green.shade600,
            deviceType: deviceType,
            spacing: spacing,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required DeviceType deviceType,
    required ResponsiveSpacing spacing,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(spacing.card),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: ResponsiveUtils.getIconSize(
              deviceType,
              IconSizeType.large,
            ),
          ),
        ),
        SizedBox(height: spacing.card),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(
              deviceType,
              FontSize.heading,
            ),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: spacing.card * 0.5),
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(
              deviceType,
              FontSize.caption,
            ),
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
