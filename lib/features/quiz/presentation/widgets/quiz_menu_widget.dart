import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/routing/routes.dart';
import '../../../question/domain/repositories/question_repository.dart';
import '../../domain/entities/quiz.dart';
import 'custom_quiz_dialog.dart';

class QuizMenuWidget extends StatefulWidget {
  const QuizMenuWidget({super.key});

  @override
  State<QuizMenuWidget> createState() => _QuizMenuWidgetState();
}

class _QuizMenuWidgetState extends State<QuizMenuWidget> {
  final QuestionRepository _questionRepository = getIt<QuestionRepository>();

  Future<void> _startRandomQuiz() async {
    // Pick a random quiz type (motor, sailing, combined) and random exam sheet
    final random = Random();
    final quizTypes = [QuizType.motor, QuizType.sailingOnly, QuizType.combined];
    final randomType = quizTypes[random.nextInt(quizTypes.length)];
    final randomExamSheet = random.nextInt(15); // 0-14

    if (!mounted) return;

    context.push(
      Routes.quizSession,
      extra: {
        'quizType': randomType,
        'examSheetIndex': randomExamSheet,
      },
    );
  }

  Future<void> _showCustomQuizDialog() async {
    // Get question counts per category
    final basisfragenCount = await _questionRepository.getQuestionCountByCategories(['basisfragen']);
    final binnenCount = await _questionRepository.getQuestionCountByCategories(['spezifisch_binnen']);
    final segelnCount = await _questionRepository.getQuestionCountByCategories(['spezifisch_segeln']);
    final totalCount = basisfragenCount + binnenCount + segelnCount;

    if (!mounted) return;

    final config = await CustomQuizDialog.show(
      context,
      totalQuestionsAvailable: totalCount,
      categoryQuestionCounts: {
        'basisfragen': basisfragenCount,
        'spezifisch_binnen': binnenCount,
        'spezifisch_segeln': segelnCount,
      },
    );

    if (config != null && mounted) {
      // Get random question IDs based on selection
      final questionIds = await _questionRepository.getRandomQuestionIds(
        count: config.questionCount,
        categoryIds: config.categoryIds,
      );

      if (!mounted) return;

      // Navigate to quiz session with custom questions
      context.push(
        Routes.quizSession,
        extra: {
          'quizType': QuizType.custom,
          'customQuestionIds': questionIds,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.quiz_rounded,
                    color: Colors.orange.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Prüfung starten',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Random Fragebogen Button
          _QuizMenuButton(
            icon: Icons.shuffle_rounded,
            title: 'Zufälliger Fragebogen',
            subtitle: 'Starte einen zufällig ausgewählten Fragebogen',
            gradientColors: [Colors.orange.shade600, Colors.orange.shade400],
            onTap: _startRandomQuiz,
          ),

          const SizedBox(height: 12),

          // Custom Quiz Button
          _QuizMenuButton(
            icon: Icons.tune_rounded,
            title: 'Eigenes Quiz',
            subtitle: 'Erstelle ein individuelles Quiz',
            gradientColors: [Colors.purple.shade600, Colors.purple.shade400],
            onTap: _showCustomQuizDialog,
          ),

          const SizedBox(height: 12),

          // All Quizzes Button
          _QuizMenuButton(
            icon: Icons.list_alt_rounded,
            title: 'Alle Fragebögen',
            subtitle: 'Übersicht aller verfügbaren Fragebögen',
            gradientColors: [Colors.teal.shade600, Colors.teal.shade400],
            onTap: () {
              context.push(Routes.quizzes);
            },
          ),
        ],
      ),
    );
  }
}

class _QuizMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _QuizMenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
