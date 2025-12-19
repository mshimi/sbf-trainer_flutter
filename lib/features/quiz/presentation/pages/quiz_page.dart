import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/quiz.dart';
import '../cubit/quiz_session_cubit.dart';
import '../cubit/quiz_session_state.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  String _getQuizTypeName(QuizType type) {
    switch (type) {
      case QuizType.motor:
        return 'Motor';
      case QuizType.sailingOnly:
        return 'Segel';
      case QuizType.combined:
        return 'Kombi';
      case QuizType.custom:
        return 'Eigenes Quiz';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizSessionCubit, QuizSessionState>(
      listener: (context, state) {
        if (state.status == QuizSessionStatus.completed) {
          _showResultDialog(context, state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, state),
                  if (state.status == QuizSessionStatus.loading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.status == QuizSessionStatus.error)
                    Expanded(child: _buildError(context, state))
                  else if (state.currentQuestion != null)
                    Expanded(child: _buildQuestionContent(context, state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, QuizSessionState state) {
    final quiz = state.quiz;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showExitDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz != null
                          ? '${_getQuizTypeName(quiz.type)}${quiz.examSheetIndex != null ? ' - Bogen ${quiz.examSheetIndex! + 1}' : ''}'
                          : 'Quiz',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (quiz != null)
                      Text(
                        'Frage ${state.currentIndex + 1} von ${quiz.totalQuestions}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (quiz != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${quiz.correctCount}/${quiz.answeredCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          if (quiz != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.progress,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, QuizSessionState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Fehler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Unbekannter Fehler',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Zurück'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(BuildContext context, QuizSessionState state) {
    final question = state.currentQuestion!;
    final shuffledAnswerIds = state.shuffledAnswerIds ?? [];

    // Reorder answers according to shuffled IDs
    final orderedAnswers = shuffledAnswerIds
        .map((id) => question.answers.firstWhere(
              (a) => a.id == id,
              orElse: () => question.answers.first,
            ))
        .toList();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Question card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${question.points} ${question.points == 1 ? 'Punkt' : 'Punkte'}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'ID: ${question.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question.questionText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      // Images section
                      if (question.hasImages && question.imageRefs.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ...question.imageRefs.map((imageRef) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/questions/$imageRef',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image_rounded,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Bild nicht gefunden',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Answer options
                ...orderedAnswers.map((answer) {
                  final isSelected = state.selectedAnswerId == answer.id;
                  final hasAnswered = state.hasAnswered;
                  final isCorrect = answer.isCorrect;

                  Color backgroundColor = Colors.white;
                  Color borderColor = Colors.grey.shade300;
                  Color textColor = Colors.grey.shade800;
                  IconData? trailingIcon;

                  if (hasAnswered) {
                    if (isCorrect) {
                      backgroundColor = Colors.green.shade50;
                      borderColor = Colors.green;
                      textColor = Colors.green.shade800;
                      trailingIcon = Icons.check_circle_rounded;
                    } else if (isSelected && !isCorrect) {
                      backgroundColor = Colors.red.shade50;
                      borderColor = Colors.red;
                      textColor = Colors.red.shade800;
                      trailingIcon = Icons.cancel_rounded;
                    }
                  } else if (isSelected) {
                    backgroundColor = Colors.blue.shade50;
                    borderColor = Colors.blue;
                    textColor = Colors.blue.shade800;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: hasAnswered
                            ? null
                            : () => context
                                .read<QuizSessionCubit>()
                                .selectAnswer(answer.id),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: borderColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    answer.id.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  answer.text,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              if (trailingIcon != null)
                                Icon(
                                  trailingIcon,
                                  color: isCorrect ? Colors.green : Colors.red,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Bottom button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.hasAnswered
                    ? () => context.read<QuizSessionCubit>().submitAndNext()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: state.status == QuizSessionStatus.submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        state.isLastQuestion ? 'Abschließen' : 'Weiter',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quiz beenden?'),
        content: const Text(
          'Dein Fortschritt wird gespeichert und du kannst später weitermachen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: const Text('Beenden'),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(BuildContext context, QuizSessionState state) {
    final quiz = state.quiz;
    if (quiz == null) return;

    final passed = quiz.earnedPoints >= (quiz.totalPoints * 0.9).ceil();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(
              passed ? Icons.celebration_rounded : Icons.sentiment_dissatisfied,
              color: passed ? Colors.green : Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(passed ? 'Bestanden!' : 'Nicht bestanden'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: passed ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '${quiz.correctCount}/${quiz.totalQuestions}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: passed ? Colors.green : Colors.orange,
                    ),
                  ),
                  const Text(
                    'Richtige Antworten',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${quiz.earnedPoints}/${quiz.totalPoints} Punkte',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }
}
