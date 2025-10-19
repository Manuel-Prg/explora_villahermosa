import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class OptionButton extends StatelessWidget {
  final String option;
  final String letter;
  final String correctAnswer;
  final String? selectedAnswer;
  final bool showResult;
  final Function(String) onTap;

  const OptionButton({
    super.key,
    required this.option,
    required this.letter,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    final isSelected = selectedAnswer == option;
    final isCorrect = option == correctAnswer;
    final showCorrect = showResult && isCorrect;
    final showIncorrect = showResult && isSelected && !isCorrect;

    Color backgroundColor = Colors.grey.shade50;
    Color textColor = const Color(0xFF5D4037);
    Color borderColor = Colors.grey.shade300;
    Color letterBgColor = Colors.white;
    IconData? icon;

    if (showCorrect) {
      backgroundColor = const Color(0xFF66BB6A);
      textColor = Colors.white;
      borderColor = const Color(0xFF4CAF50);
      letterBgColor = Colors.white.withOpacity(0.3);
      icon = Icons.check_circle;
    } else if (showIncorrect) {
      backgroundColor = const Color(0xFFEF5350);
      textColor = Colors.white;
      borderColor = const Color(0xFFE53935);
      letterBgColor = Colors.white.withOpacity(0.3);
      icon = Icons.cancel;
    } else if (isSelected) {
      backgroundColor = const Color(0xFFFFE0B2);
      borderColor = const Color(0xFFFFB74D);
      textColor = const Color(0xFFE65100);
    }

    return InkWell(
      onTap: selectedAnswer == null ? () => onTap(option) : null,
      borderRadius: BorderRadius.circular(borderRadius * 0.6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius * 0.6),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: showCorrect || showIncorrect
              ? [
                  BoxShadow(
                    color: borderColor.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 3,
                    offset: const Offset(0, 4),
                  ),
                ]
              : isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFFB74D).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: ResponsiveUtils.getIconSize(
                    deviceType,
                    IconSizeType.medium,
                  ) +
                  8,
              height: ResponsiveUtils.getIconSize(
                    deviceType,
                    IconSizeType.medium,
                  ) +
                  8,
              decoration: BoxDecoration(
                color: letterBgColor,
                borderRadius: BorderRadius.circular(borderRadius * 0.4),
                border: Border.all(
                  color: showCorrect || showIncorrect
                      ? Colors.white.withOpacity(0.5)
                      : borderColor,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.body,
                  ),
                ),
              ),
            ),
            SizedBox(width: spacing.subsection),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.body,
                  ),
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: spacing.card),
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: ResponsiveUtils.getIconSize(
                    deviceType,
                    IconSizeType.medium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
