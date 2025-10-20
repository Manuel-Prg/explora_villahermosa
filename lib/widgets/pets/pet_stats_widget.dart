import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import '../../utils/responsive_utils.dart';

class PetStatsWidget extends StatelessWidget {
  final AppProvider provider;
  final DeviceType deviceType;
  final VoidCallback onFeedPet;
  final VoidCallback onPlayWithPet;

  const PetStatsWidget({
    super.key,
    required this.provider,
    required this.deviceType,
    required this.onFeedPet,
    required this.onPlayWithPet,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.purple.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatBar(
            label: 'Hambre',
            value: provider.petHunger,
            color: const Color(0xFFFFB74D),
            icon: Icons.restaurant,
            spacing: spacing,
          ),
          SizedBox(height: spacing.subsection),
          _buildStatBar(
            label: 'Experiencia',
            value: provider.petExperience,
            color: const Color(0xFF66BB6A),
            icon: Icons.star,
            spacing: spacing,
          ),
          SizedBox(height: spacing.subsection + 5),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStatBar({
    required String label,
    required int value,
    required Color color,
    required IconData icon,
    required ResponsiveSpacing spacing,
  }) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.small);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: iconSize),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: bodySize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceType == DeviceType.mobile ? 10 : 12,
                vertical: deviceType == DeviceType.mobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$value%',
                style: TextStyle(
                  fontSize: captionSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: deviceType == DeviceType.mobile ? 10 : 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value / 100,
              child: Container(
                height: deviceType == DeviceType.mobile ? 10 : 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final iconSize =
        ResponsiveUtils.getIconSize(deviceType, IconSizeType.small);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onFeedPet,
            icon: Icon(Icons.restaurant_menu, size: iconSize),
            label: Text(
              'Alimentar',
              style: TextStyle(fontSize: bodySize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB74D),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: deviceType == DeviceType.mobile ? 12 : 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPlayWithPet,
            icon: Icon(Icons.sports_esports, size: iconSize),
            label: Text(
              'Jugar',
              style: TextStyle(fontSize: bodySize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: deviceType == DeviceType.mobile ? 12 : 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }
}
