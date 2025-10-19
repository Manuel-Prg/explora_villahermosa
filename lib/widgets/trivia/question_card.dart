import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import 'option_button.dart';

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final int currentQuestion;
  final int totalQuestions;
  final String? selectedAnswer;
  final bool showResult;
  final Function(String) onSelectAnswer;

  const QuestionCard({
    super.key,
    required this.question,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.selectedAnswer,
    required this.showResult,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);

    return Container(
      padding: EdgeInsets.all(cardPadding * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFFFB74D),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB74D).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(deviceType, spacing, borderRadius),
          SizedBox(height: spacing.subsection),
          _buildRewardInfo(deviceType, spacing, borderRadius),
          SizedBox(height: spacing.subsection * 1.5),
          _buildQuestion(deviceType, spacing, borderRadius),
          SizedBox(height: spacing.subsection * 1.5),
          _buildOptions(deviceType, spacing),
        ],
      ),
    );
  }

  Widget _buildHeader(
    DeviceType deviceType,
    ResponsiveSpacing spacing,
    double borderRadius,
  ) {
    return Wrap(
      spacing: spacing.card,
      runSpacing: spacing.card,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.card * 1.2,
            vertical: spacing.card * 0.7,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4DD0E1).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'Pregunta ${currentQuestion + 1}/$totalQuestions',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtils.getFontSize(
                deviceType,
                FontSize.caption,
              ),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.card * 1.1,
            vertical: spacing.card * 0.6,
          ),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.purple.shade200,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.category,
                color: Colors.purple.shade600,
                size: ResponsiveUtils.getIconSize(
                  deviceType,
                  IconSizeType.small,
                ),
              ),
              SizedBox(width: spacing.card * 0.5),
              Text(
                question['category'],
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.caption,
                  ),
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardInfo(
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
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(borderRadius * 0.6),
        border: Border.all(
          color: const Color(0xFFFFB74D).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            color: const Color(0xFFFF9800),
            size: ResponsiveUtils.getIconSize(
              deviceType,
              IconSizeType.small,
            ),
          ),
          SizedBox(width: spacing.card),
          Flexible(
            child: Text(
              '+10 puntos por respuesta correcta',
              style: TextStyle(
                fontSize: ResponsiveUtils.getFontSize(
                  deviceType,
                  FontSize.caption,
                ),
                color: const Color(0xFFE65100),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(
    DeviceType deviceType,
    ResponsiveSpacing spacing,
    double borderRadius,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.subsection),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(borderRadius * 0.6),
      ),
      child: Text(
        question['question'],
        style: TextStyle(
          fontSize: ResponsiveUtils.getFontSize(
            deviceType,
            FontSize.body,
          ),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF5D4037),
          height: 1.5,
          letterSpacing: 0.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptions(DeviceType deviceType, ResponsiveSpacing spacing) {
    return Column(
      children: List.generate(
        question['options'].length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: spacing.card),
          child: OptionButton(
            option: question['options'][index],
            letter: String.fromCharCode(65 + index),
            correctAnswer: question['correct'],
            selectedAnswer: selectedAnswer,
            showResult: showResult,
            onTap: onSelectAnswer,
          ),
        ),
      ),
    );
  }
}
