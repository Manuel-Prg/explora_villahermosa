import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/trivia_question.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class ResponsiveTrivia {
  final double fontSize24;
  final double fontSize20;
  final double fontSize18;
  final double fontSize16;
  final double fontSize14;
  final double fontSize12;
  final double fontSize11;
  final double fontSize10;
  final double paddingH;
  final double paddingV;
  final double iconSize20;
  final double iconSize24;
  final double iconSize28;
  final double borderRadius;
  final double cardPadding;
  final double optionPadding;

  ResponsiveTrivia({
    required this.fontSize24,
    required this.fontSize20,
    required this.fontSize18,
    required this.fontSize16,
    required this.fontSize14,
    required this.fontSize12,
    required this.fontSize11,
    required this.fontSize10,
    required this.paddingH,
    required this.paddingV,
    required this.iconSize20,
    required this.iconSize24,
    required this.iconSize28,
    required this.borderRadius,
    required this.cardPadding,
    required this.optionPadding,
  });
}

class _TriviaScreenState extends State<TriviaScreen> {
  int currentQuestion = 0;
  String? selectedAnswer;
  bool showResult = false;
  int correctAnswers = 0;
  int totalAnswered = 0;
  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    questions = TriviaQuestions.getRandomQuestions(10);
  }

  ResponsiveTrivia _getResponsiveValues() {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isSmall = width < 360;

    return ResponsiveTrivia(
      fontSize24: isSmall ? 20 : 24,
      fontSize20: isSmall ? 18 : 20,
      fontSize18: isSmall ? 16 : 18,
      fontSize16: isSmall ? 14 : 16,
      fontSize14: isSmall ? 12 : 14,
      fontSize12: isSmall ? 11 : 12,
      fontSize11: isSmall ? 10 : 11,
      fontSize10: isSmall ? 9 : 10,
      paddingH: isSmall ? 14 : 20,
      paddingV: isSmall ? 12 : 16,
      iconSize20: isSmall ? 18 : 20,
      iconSize24: isSmall ? 22 : 24,
      iconSize28: isSmall ? 26 : 28,
      borderRadius: isSmall ? 16 : 20,
      cardPadding: isSmall ? 18 : 25,
      optionPadding: isSmall ? 12 : 16,
    );
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showResult = true;
      totalAnswered++;
    });

    final isCorrect = answer == questions[currentQuestion]['correct'];

    if (isCorrect) {
      correctAnswers++;
      Provider.of<AppProvider>(context, listen: false).answerTrivia(true);
    } else {
      Provider.of<AppProvider>(context, listen: false).answerTrivia(false);
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (currentQuestion < questions.length - 1) {
            currentQuestion++;
            selectedAnswer = null;
            showResult = false;
          } else {
            _showCompletionDialog();
          }
        });
      }
    });
  }

  void _showCompletionDialog() {
    final percentage = (correctAnswers / questions.length * 100).round();
    final responsive = _getResponsiveValues();
    String message;
    IconData icon;
    Color color;

    if (percentage >= 80) {
      message = '¡Excelente! Eres un experto en la historia de Villahermosa.';
      icon = Icons.emoji_events;
      color = const Color(0xFFFFD700);
    } else if (percentage >= 60) {
      message = '¡Muy bien! Conoces bastante sobre Villahermosa.';
      icon = Icons.thumb_up;
      color = const Color(0xFF4CAF50);
    } else {
      message = '¡Sigue aprendiendo! Hay mucho por descubrir.';
      icon = Icons.school;
      color = const Color(0xFF2196F3);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.borderRadius),
        ),
        title: Column(
          children: [
            Icon(icon, size: responsive.iconSize28 + 30, color: color),
            SizedBox(height: responsive.paddingV),
            Text(
              '¡Trivia Completada!',
              style: TextStyle(
                fontSize: responsive.fontSize20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: responsive.fontSize14),
              ),
              SizedBox(height: responsive.paddingV * 1.5),
              Container(
                padding: EdgeInsets.all(responsive.cardPadding),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(responsive.borderRadius * 0.7),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Correctas:',
                            style: TextStyle(fontSize: responsive.fontSize14)),
                        Text(
                          '$correctAnswers/${questions.length}',
                          style: TextStyle(
                            fontSize: responsive.fontSize14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.paddingV),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Puntuación:',
                            style: TextStyle(fontSize: responsive.fontSize14)),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: responsive.fontSize14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFB74D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestion = 0;
                selectedAnswer = null;
                showResult = false;
                correctAnswers = 0;
                totalAnswered = 0;
                questions = TriviaQuestions.getRandomQuestions(10);
              });
            },
            child: Text(
              'Jugar de Nuevo',
              style: TextStyle(
                fontSize: responsive.fontSize14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getCurrentProgress() {
    if (questions.isEmpty) return 0.0;
    return (currentQuestion + 1) / questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final question = questions[currentQuestion];
    final responsive = _getResponsiveValues();
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(provider, responsive),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  responsive.paddingH,
                  responsive.paddingH,
                  responsive.paddingH,
                  responsive.paddingV,
                ),
                child: Column(
                  children: [
                    _buildQuestionCard(question, responsive),
                    SizedBox(height: responsive.paddingV * 1.5),
                    _buildProgressSection(responsive),
                    SizedBox(height: responsive.paddingV * 1.5),
                    _buildStatsCard(responsive),
                    SizedBox(
                      height: bottomPadding > 0 ? bottomPadding + 12 : 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider, ResponsiveTrivia responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.paddingV),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(responsive.borderRadius),
          bottomRight: Radius.circular(responsive.borderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trivia Histórica',
                  style: TextStyle(
                    fontSize: responsive.fontSize20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: responsive.paddingV * 0.3),
                Text(
                  'Demuestra tu conocimiento',
                  style: TextStyle(
                    fontSize: responsive.fontSize11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.paddingH),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.paddingH * 0.8,
              vertical: responsive.paddingV * 0.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.stars,
                  color: Colors.white,
                  size: responsive.iconSize20,
                ),
                SizedBox(width: responsive.paddingH * 0.3),
                Text(
                  '${provider.points}',
                  style: TextStyle(
                    fontSize: responsive.fontSize16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    Map<String, dynamic> question,
    ResponsiveTrivia responsive,
  ) {
    return Container(
      padding: EdgeInsets.all(responsive.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        border: Border.all(color: const Color(0xFFFFB74D), width: 3),
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
          Wrap(
            spacing: responsive.paddingH * 0.5,
            runSpacing: responsive.paddingV * 0.5,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.paddingH,
                  vertical: responsive.paddingV * 0.4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4DD0E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Pregunta ${currentQuestion + 1}/${questions.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.fontSize11,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.paddingH * 0.7,
                  vertical: responsive.paddingV * 0.3,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.category,
                      color: Colors.purple.shade400,
                      size: responsive.iconSize20,
                    ),
                    SizedBox(width: responsive.paddingH * 0.3),
                    Text(
                      question['category'],
                      style: TextStyle(
                        fontSize: responsive.fontSize10,
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.paddingV),
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: const Color(0xFFFFB74D),
                size: responsive.iconSize20,
              ),
              SizedBox(width: responsive.paddingH * 0.3),
              Flexible(
                child: Text(
                  '+10 puntos por respuesta correcta',
                  style: TextStyle(
                    fontSize: responsive.fontSize10,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.paddingV * 1.5),
          Text(
            question['question'],
            style: TextStyle(
              fontSize: responsive.fontSize18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.paddingV * 1.5),
          ...List.generate(
            question['options'].length,
            (index) => _buildOptionButton(
              question['options'][index],
              String.fromCharCode(65 + index),
              question['correct'],
              responsive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    String option,
    String letter,
    String correctAnswer,
    ResponsiveTrivia responsive,
  ) {
    final isSelected = selectedAnswer == option;
    final isCorrect = option == correctAnswer;
    final showCorrect = showResult && isCorrect;
    final showIncorrect = showResult && isSelected && !isCorrect;

    Color backgroundColor = Colors.grey.shade100;
    Color textColor = const Color(0xFF5D4037);
    Color borderColor = Colors.grey.shade300;

    if (showCorrect) {
      backgroundColor = const Color(0xFF66BB6A);
      textColor = Colors.white;
      borderColor = const Color(0xFF4CAF50);
    } else if (showIncorrect) {
      backgroundColor = const Color(0xFFEF5350);
      textColor = Colors.white;
      borderColor = const Color(0xFFE53935);
    } else if (isSelected) {
      backgroundColor = const Color(0xFFFFB74D).withOpacity(0.2);
      borderColor = const Color(0xFFFFB74D);
    }

    return Container(
      margin: EdgeInsets.only(bottom: responsive.paddingV * 0.8),
      child: InkWell(
        onTap: selectedAnswer == null ? () => selectAnswer(option) : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(responsive.optionPadding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: showCorrect || showIncorrect
                ? [
                    BoxShadow(
                      color: borderColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: responsive.fontSize20 + 8,
                height: responsive.fontSize20 + 8,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(showCorrect || showIncorrect ? 0.3 : 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: responsive.fontSize16,
                  ),
                ),
              ),
              SizedBox(width: responsive.paddingH),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: responsive.fontSize14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showCorrect)
                Icon(Icons.check_circle,
                    color: Colors.white, size: responsive.iconSize24)
              else if (showIncorrect)
                Icon(Icons.cancel,
                    color: Colors.white, size: responsive.iconSize24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(ResponsiveTrivia responsive) {
    final progress = _getCurrentProgress();

    return Container(
      padding: EdgeInsets.all(responsive.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        border: Border.all(color: const Color(0xFF4DD0E1), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: const Color(0xFF4DD0E1),
                      size: responsive.iconSize20,
                    ),
                    SizedBox(width: responsive.paddingH * 0.5),
                    Flexible(
                      child: Text(
                        'Progreso de la Trivia',
                        style: TextStyle(
                          fontSize: responsive.fontSize14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5D4037),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: responsive.fontSize16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4DD0E1),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.paddingV),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF4DD0E1).withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4DD0E1)),
              minHeight: responsive.paddingV,
            ),
          ),
          SizedBox(height: responsive.paddingV),
          Text(
            '${currentQuestion + 1} de ${questions.length} preguntas completadas',
            style: TextStyle(
              fontSize: responsive.fontSize11,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ResponsiveTrivia responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: _buildStatItem(
              Icons.check_circle_outline,
              'Correctas',
              '$correctAnswers',
              responsive,
            ),
          ),
          Container(
            width: 1,
            height: responsive.fontSize16 + 10,
            color: Colors.white.withOpacity(0.3),
          ),
          Flexible(
            child: _buildStatItem(
              Icons.quiz,
              'Respondidas',
              '$totalAnswered',
              responsive,
            ),
          ),
          Container(
            width: 1,
            height: responsive.fontSize16 + 10,
            color: Colors.white.withOpacity(0.3),
          ),
          Flexible(
            child: _buildStatItem(
              Icons.percent,
              'Precisión',
              totalAnswered > 0
                  ? '${(correctAnswers / totalAnswered * 100).round()}%'
                  : '0%',
              responsive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    ResponsiveTrivia responsive,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: responsive.iconSize24),
        SizedBox(height: responsive.paddingV * 0.3),
        Text(
          value,
          style: TextStyle(
            fontSize: responsive.fontSize16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: responsive.paddingV * 0.2),
        Text(
          label,
          style: TextStyle(
            fontSize: responsive.fontSize10,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
