import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class CompletionDialog extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final VoidCallback onPlayAgain;

  const CompletionDialog({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.onPlayAgain,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final percentage = (correctAnswers / totalQuestions * 100).round();
    final resultData = _getResultData(percentage);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius * 1.5),
      ),
      elevation: 10,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.getMaxContentWidth(deviceType),
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius * 1.5),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(cardPadding * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: EdgeInsets.all(spacing.section),
                      decoration: BoxDecoration(
                        color: resultData.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: resultData.color.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        resultData.icon,
                        size: ResponsiveUtils.getIconSize(
                              deviceType,
                              IconSizeType.large,
                            ) +
                            20,
                        color: resultData.color,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: spacing.section),
              Text(
                '¡Trivia Completada!',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.title,
                  ),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5D4037),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing.subsection),
              Text(
                resultData.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.body,
                  ),
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              SizedBox(height: spacing.section),
              Container(
                padding: EdgeInsets.all(cardPadding * 1.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      resultData.color.withOpacity(0.1),
                      resultData.color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: resultData.color.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: percentage),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Text(
                          '$value%',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getFontSize(
                                  deviceType,
                                  FontSize.title,
                                ) +
                                10,
                            fontWeight: FontWeight.bold,
                            color: resultData.color,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: spacing.card * 0.5),
                    Text(
                      'Puntuación',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getFontSize(
                          deviceType,
                          FontSize.caption,
                        ),
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: spacing.subsection * 1.5),
                    _buildDetailRow(
                      'Correctas',
                      '$correctAnswers / $totalQuestions',
                      Icons.check_circle,
                      const Color(0xFF4CAF50),
                      deviceType,
                      spacing,
                      borderRadius,
                    ),
                    SizedBox(height: spacing.subsection),
                    _buildDetailRow(
                      'Incorrectas',
                      '${totalQuestions - correctAnswers} / $totalQuestions',
                      Icons.cancel,
                      const Color(0xFFEF5350),
                      deviceType,
                      spacing,
                      borderRadius,
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.section),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: cardPadding,
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            borderRadius * 0.6,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getFontSize(
                            deviceType,
                            FontSize.body,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.card),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onPlayAgain();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: cardPadding,
                        ),
                        backgroundColor: resultData.color,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            borderRadius * 0.6,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: ResponsiveUtils.getIconSize(
                              deviceType,
                              IconSizeType.small,
                            ),
                          ),
                          SizedBox(width: spacing.card),
                          Text(
                            'Jugar de Nuevo',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.getFontSize(
                                deviceType,
                                FontSize.body,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
    DeviceType deviceType,
    ResponsiveSpacing spacing,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.subsection,
        vertical: spacing.card,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius * 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.card * 0.7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: ResponsiveUtils.getIconSize(
                deviceType,
                IconSizeType.small,
              ),
            ),
          ),
          SizedBox(width: spacing.subsection),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUtils.getFontSize(
                  deviceType,
                  FontSize.body,
                ),
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveUtils.getFontSize(
                deviceType,
                FontSize.subtitle,
              ),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  _ResultData _getResultData(int percentage) {
    if (percentage >= 80) {
      return _ResultData(
        message: '¡Excelente! Eres un experto en la historia de Villahermosa.',
        icon: Icons.emoji_events,
        color: const Color(0xFFFFD700),
      );
    } else if (percentage >= 60) {
      return _ResultData(
        message: '¡Muy bien! Conoces bastante sobre Villahermosa.',
        icon: Icons.thumb_up,
        color: const Color(0xFF4CAF50),
      );
    } else {
      return _ResultData(
        message: '¡Sigue aprendiendo! Hay mucho por descubrir.',
        icon: Icons.school,
        color: const Color(0xFF2196F3),
      );
    }
  }
}

class _ResultData {
  final String message;
  final IconData icon;
  final Color color;

  _ResultData({
    required this.message,
    required this.icon,
    required this.color,
  });
}
