import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class StatsCard extends StatelessWidget {
  final int correctAnswers;
  final int totalAnswered;

  const StatsCard({
    super.key,
    required this.correctAnswers,
    required this.totalAnswered,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final accuracy =
        totalAnswered > 0 ? (correctAnswers / totalAnswered * 100).round() : 0;

    return Container(
      padding: EdgeInsets.all(cardPadding * 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.white,
                size: ResponsiveUtils.getIconSize(
                  deviceType,
                  IconSizeType.small,
                ),
              ),
              SizedBox(width: spacing.card),
              Text(
                'Estadísticas',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.body,
                  ),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.subsection),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatItem(
                    Icons.check_circle,
                    'Correctas',
                    '$correctAnswers',
                    deviceType,
                    spacing,
                    borderRadius,
                  ),
                ),
                _buildDivider(spacing),
                Expanded(
                  child: _buildStatItem(
                    Icons.quiz,
                    'Respondidas',
                    '$totalAnswered',
                    deviceType,
                    spacing,
                    borderRadius,
                  ),
                ),
                _buildDivider(spacing),
                Expanded(
                  child: _buildStatItem(
                    Icons.percent,
                    'Precisión',
                    '$accuracy%',
                    deviceType,
                    spacing,
                    borderRadius,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ResponsiveSpacing spacing) {
    return Container(
      width: 1.5,
      margin: EdgeInsets.symmetric(vertical: spacing.card),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    DeviceType deviceType,
    ResponsiveSpacing spacing,
    double borderRadius,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(spacing.card),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius * 0.5),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: ResponsiveUtils.getIconSize(
              deviceType,
              IconSizeType.medium,
            ),
          ),
        ),
        SizedBox(height: spacing.card),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(
              deviceType,
              FontSize.subtitle,
            ),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
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
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
