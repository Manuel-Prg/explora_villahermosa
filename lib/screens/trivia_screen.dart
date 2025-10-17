import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/trivia_question.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
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
    // Obtener 10 preguntas aleatorias al iniciar
    questions = TriviaQuestions.getRandomQuestions(10);
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 10),
            const Text(
              '¡Trivia Completada!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Correctas:', style: TextStyle(fontSize: 16)),
                      Text(
                        '$correctAnswers/${questions.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Puntuación:', style: TextStyle(fontSize: 16)),
                      Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFB74D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
                // Obtener nuevas preguntas aleatorias
                questions = TriviaQuestions.getRandomQuestions(10);
              });
            },
            child: const Text(
              'Jugar de Nuevo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    // Responsive padding
    final horizontalPadding = screenWidth < 360 ? 16.0 : 20.0;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(provider, screenWidth),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  horizontalPadding,
                  horizontalPadding,
                  isSmallScreen ? 12 : horizontalPadding,
                ),
                child: Column(
                  children: [
                    _buildQuestionCard(question, screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 12 : 20),
                    _buildProgressSection(screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 12 : 20),
                    _buildStatsCard(screenWidth, isSmallScreen),
                    // Espaciado para botón de accesibilidad
                    SizedBox(
                        height: bottomPadding > 0 ? bottomPadding + 16 : 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider, double screenWidth) {
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
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
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Demuestra tu conocimiento',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11 : 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars,
                    color: Colors.white, size: isSmallScreen ? 18 : 20),
                const SizedBox(width: 6),
                Text(
                  '${provider.points}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
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
    double screenWidth,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Header con número de pregunta y categoría
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
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
                    fontSize: isSmallScreen ? 11 : 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
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
                      size: isSmallScreen ? 14 : 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question['category'],
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 11,
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: const Color(0xFFFFB74D),
                size: isSmallScreen ? 16 : 18,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '+10 puntos por respuesta correcta',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 25),
          Text(
            question['question'],
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 20 : 25),
          ...List.generate(
            question['options'].length,
            (index) => _buildOptionButton(
              question['options'][index],
              String.fromCharCode(65 + index),
              question['correct'],
              isSmallScreen,
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
    bool isSmallScreen,
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
      margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
      child: InkWell(
        onTap: selectedAnswer == null ? () => selectAnswer(option) : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
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
                width: isSmallScreen ? 28 : 32,
                height: isSmallScreen ? 28 : 32,
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
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showCorrect)
                Icon(Icons.check_circle,
                    color: Colors.white, size: isSmallScreen ? 24 : 28)
              else if (showIncorrect)
                Icon(Icons.cancel,
                    color: Colors.white, size: isSmallScreen ? 24 : 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(double screenWidth, bool isSmallScreen) {
    final progress = _getCurrentProgress();

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                      size: isSmallScreen ? 18 : 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Progreso de la Trivia',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
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
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4DD0E1),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 10 : 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF4DD0E1).withOpacity(0.2),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4DD0E1)),
              minHeight: isSmallScreen ? 10 : 12,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Text(
            '${currentQuestion + 1} de ${questions.length} preguntas completadas',
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(double screenWidth, bool isSmallScreen) {
    final isVerySmallScreen = screenWidth < 340;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
              isSmallScreen,
              isVerySmallScreen,
            ),
          ),
          Container(
            width: 1,
            height: isSmallScreen ? 35 : 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Flexible(
            child: _buildStatItem(
              Icons.quiz,
              'Respondidas',
              '$totalAnswered',
              isSmallScreen,
              isVerySmallScreen,
            ),
          ),
          Container(
            width: 1,
            height: isSmallScreen ? 35 : 40,
            color: Colors.white.withOpacity(0.3),
          ),
          Flexible(
            child: _buildStatItem(
              Icons.percent,
              'Precisión',
              totalAnswered > 0
                  ? '${(correctAnswers / totalAnswered * 100).round()}%'
                  : '0%',
              isSmallScreen,
              isVerySmallScreen,
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
    bool isSmallScreen,
    bool isVerySmallScreen,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: isSmallScreen ? 20 : 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isVerySmallScreen ? 9 : (isSmallScreen ? 10 : 11),
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
