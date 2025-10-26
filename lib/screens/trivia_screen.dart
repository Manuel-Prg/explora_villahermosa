// lib/screens/trivia_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/game_progress_provider.dart';
import '../data/trivia_question.dart';
import '../utils/responsive_utils.dart';
import '../widgets/trivia/trivia_header.dart';
import '../widgets/trivia/question_card.dart';
import '../widgets/trivia/progress_card.dart';
import '../widgets/trivia/stats_card.dart';
import '../widgets/trivia/completion_dialog.dart';

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
    questions = TriviaQuestions.getRandomQuestions(10);
  }

  void selectAnswer(String answer) {
    if (selectedAnswer != null) return;

    setState(() {
      selectedAnswer = answer;
      showResult = true;
      totalAnswered++;
    });

    final isCorrect = answer == questions[currentQuestion]['correct'];

    // Obtener providers
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final gameProgress =
        Provider.of<GameProgressProvider>(context, listen: false);

    if (isCorrect) {
      correctAnswers++;
      // Dar puntos por respuesta correcta
      userProvider.addPoints(10);
      gameProgress.answerTrivia(true);
    } else {
      gameProgress.answerTrivia(false);
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
    // Dar puntos de bonificación al completar
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final gameProgress =
        Provider.of<GameProgressProvider>(context, listen: false);

    // Bonificación por completar trivia
    final bonusPoints = (correctAnswers * 5);
    userProvider.addPoints(bonusPoints);

    // Marcar trivia como completada
    gameProgress.completeTrivia(
        'trivia_${DateTime.now().millisecondsSinceEpoch}', correctAnswers);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CompletionDialog(
        correctAnswers: correctAnswers,
        totalQuestions: questions.length,
        onPlayAgain: _resetTrivia,
      ),
    );
  }

  void _resetTrivia() {
    setState(() {
      currentQuestion = 0;
      selectedAnswer = null;
      showResult = false;
      correctAnswers = 0;
      totalAnswered = 0;
      questions = TriviaQuestions.getRandomQuestions(10);
    });
  }

  double _getCurrentProgress() {
    if (questions.isEmpty) return 0.0;
    return (currentQuestion + 1) / questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final screenPadding = ResponsiveUtils.getScreenPadding(deviceType);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header mostrando puntos del UserProvider
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return TriviaHeader(points: userProvider.points);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  screenPadding.left,
                  spacing.subsection,
                  screenPadding.right,
                  spacing.subsection,
                ),
                child: Column(
                  children: [
                    QuestionCard(
                      question: question,
                      currentQuestion: currentQuestion,
                      totalQuestions: questions.length,
                      selectedAnswer: selectedAnswer,
                      showResult: showResult,
                      onSelectAnswer: selectAnswer,
                    ),
                    SizedBox(height: spacing.section),
                    ProgressCard(
                      currentQuestion: currentQuestion,
                      totalQuestions: questions.length,
                      progress: _getCurrentProgress(),
                    ),
                    SizedBox(height: spacing.section),
                    StatsCard(
                      correctAnswers: correctAnswers,
                      totalAnswered: totalAnswered,
                    ),
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
}
