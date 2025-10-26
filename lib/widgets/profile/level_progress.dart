// lib/widgets/profile/level_progress_widget.dart
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import '../../models/user_profile_model.dart';

class LevelProgressWidget extends StatelessWidget {
  final UserProfile profile;
  final DeviceType deviceType;
  final ResponsiveSpacing spacing;

  const LevelProgressWidget({
    super.key,
    required this.profile,
    required this.deviceType,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);
    final progress = profile.levelProgress;

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
          _buildHeader(bodySize, captionSize, progress),
          const SizedBox(height: 12),
          _buildProgressBar(progress),
          const SizedBox(height: 8),
          _buildXPText(captionSize),
        ],
      ),
    );
  }

  Widget _buildHeader(double bodySize, double captionSize, double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Progreso al Nivel ${profile.level + 1}',
          style: TextStyle(
            fontSize: bodySize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5D4037),
          ),
        ),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: captionSize,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Stack(
      children: [
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade600,
                  Colors.deepPurple.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildXPText(double captionSize) {
    return Text(
      '${profile.currentXP} / ${profile.xpForNextLevel} XP',
      style: TextStyle(
        fontSize: captionSize,
        color: Colors.grey.shade600,
      ),
    );
  }
}
