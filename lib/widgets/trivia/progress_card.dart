import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class ProgressCard extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress;

  const ProgressCard({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final percentage = (progress * 100).round();

    return Container(
      padding: EdgeInsets.all(cardPadding * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFF4DD0E1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4DD0E1).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(spacing.card * 0.8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4DD0E1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadius * 0.5),
                    ),
                    child: Icon(
                      Icons.trending_up,
                      color: const Color(0xFF4DD0E1),
                      size: ResponsiveUtils.getIconSize(
                        deviceType,
                        IconSizeType.small,
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.card),
                  Text(
                    'Progreso',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.body,
                      ),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.card * 1.2,
                  vertical: spacing.card * 0.6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(
                      deviceType,
                      FontSize.body,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.subsection),
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius * 0.5),
            child: Stack(
              children: [
                Container(
                  height: spacing.card * 1.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4DD0E1).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(borderRadius * 0.5),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: spacing.card * 1.5,
                  width: MediaQuery.of(context).size.width * progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                    ),
                    borderRadius: BorderRadius.circular(borderRadius * 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4DD0E1).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.card),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: ResponsiveUtils.getIconSize(
                  deviceType,
                  IconSizeType.small,
                ),
                color: Colors.grey.shade600,
              ),
              SizedBox(width: spacing.card * 0.7),
              Flexible(
                child: Text(
                  '${currentQuestion + 1} de $totalQuestions preguntas',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(
                      deviceType,
                      FontSize.caption,
                    ),
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
