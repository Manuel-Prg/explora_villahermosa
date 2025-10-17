import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  int currentQuestion = 0;
  String? selectedAnswer;
  bool showResult = false;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '¿En qué año fue fundada Villahermosa?',
      'options': ['1564', '1596', '1598', '1619'],
      'correct': '1564',
    },
    {
      'question': '¿Cuál es el nombre del río principal de Villahermosa?',
      'options': ['Grijalva', 'Usumacinta', 'Carrizal', 'Puxcatán'],
      'correct': 'Grijalva',
    },
    {
      'question': '¿Qué cultura prehispánica habitó la región?',
      'options': ['Maya', 'Olmeca', 'Azteca', 'Zapoteca'],
      'correct': 'Olmeca',
    },
  ];

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showResult = true;
    });

    final isCorrect = answer == questions[currentQuestion]['correct'];
    Provider.of<AppProvider>(context, listen: false).answerTrivia(isCorrect);

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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('¡Felicidades!'),
        content: const Text('Has completado todas las preguntas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestion = 0;
                selectedAnswer = null;
                showResult = false;
              });
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final question = questions[currentQuestion];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(provider),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildQuestionCard(question),
                    const SizedBox(height: 20),
                    _buildProgressSection(provider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB74D),
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
          Text(
            'Trivia Historica',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.amber.shade700),
              const SizedBox(width: 5),
              Text(
                '${provider.points}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB74D), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              const Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Color(0xFFFFB74D),
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '+10 monedas por respuesta correcta',
                    style: TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            question['question'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          ...List.generate(
            question['options'].length,
            (index) => _buildOptionButton(
              question['options'][index],
              String.fromCharCode(65 + index),
              question['correct'],
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
  ) {
    final isSelected = selectedAnswer == option;
    final isCorrect = option == correctAnswer;
    final showCorrect = showResult && isCorrect;
    final showIncorrect = showResult && isSelected && !isCorrect;

    Color backgroundColor = const Color(0xFFE0E0E0);
    Color textColor = const Color(0xFF5D4037);

    if (showCorrect) {
      backgroundColor = const Color(0xFF66BB6A);
      textColor = Colors.white;
    } else if (showIncorrect) {
      backgroundColor = const Color(0xFFEF5350);
      textColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: selectedAnswer == null ? () => selectAnswer(option) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: showCorrect
                  ? const Color(0xFF66BB6A)
                  : showIncorrect
                      ? const Color(0xFFEF5350)
                      : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showCorrect)
                const Icon(Icons.check_circle, color: Colors.white)
              else if (showIncorrect)
                const Icon(Icons.cancel, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFB74D), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progreso',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              Text(
                '${provider.triviaProgress}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: provider.triviaProgress / 100,
            backgroundColor: const Color(0xFFFFB74D).withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4DD0E1)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
