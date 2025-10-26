import 'package:explora_villahermosa/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class CategoryProgressWidget extends StatelessWidget {
  final UserProfile profile;
  final DeviceType deviceType;
  final ResponsiveSpacing spacing;

  const CategoryProgressWidget({
    super.key,
    required this.profile,
    required this.deviceType,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final stats = profile.stats;
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

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
          Text(
            'Progreso por Categoría',
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 16),
          _ProgressBar(
            label: 'Exploración',
            progress: stats.explorationProgress,
            color: Colors.blue,
            captionSize: captionSize,
          ),
          const SizedBox(height: 12),
          _ProgressBar(
            label: 'Conocimiento',
            progress: stats.knowledgeProgress,
            color: Colors.orange,
            captionSize: captionSize,
          ),
          const SizedBox(height: 12),
          _ProgressBar(
            label: 'Mascotas',
            progress: stats.petsProgress,
            color: Colors.green,
            captionSize: captionSize,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;
  final double captionSize;

  const _ProgressBar({
    required this.label,
    required this.progress,
    required this.color,
    required this.captionSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: captionSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: captionSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
