import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class TriviaHeader extends StatelessWidget {
  final int points;

  const TriviaHeader({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.subsection,
        vertical: spacing.card * 1.5,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius * 1.5),
          bottomRight: Radius.circular(borderRadius * 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Icono decorativo
            Container(
              padding: EdgeInsets.all(spacing.card * 0.8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(borderRadius * 0.6),
              ),
              child: Icon(
                Icons.quiz,
                color: Colors.white,
                size: ResponsiveUtils.getIconSize(
                  deviceType,
                  IconSizeType.large,
                ),
              ),
            ),
            SizedBox(width: spacing.subsection),

            // Título y subtítulo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Trivia Histórica',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.heading,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing.card * 0.4),
                  Text(
                    'Demuestra tu conocimiento',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.caption,
                      ),
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: spacing.subsection),

            // Badge de puntos
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.card * 1.2,
                vertical: spacing.card * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars,
                    color: const Color(0xFFFF9800),
                    size: ResponsiveUtils.getIconSize(
                      deviceType,
                      IconSizeType.medium,
                    ),
                  ),
                  SizedBox(width: spacing.card * 0.6),
                  Text(
                    '$points',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.subtitle,
                      ),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
