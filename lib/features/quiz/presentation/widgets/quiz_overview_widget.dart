import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../domain/entities/quiz.dart';
import '../cubit/quiz_overview_cubit.dart';
import '../cubit/quiz_overview_state.dart';

class QuizOverviewWidget extends StatefulWidget {
  const QuizOverviewWidget({super.key});

  @override
  State<QuizOverviewWidget> createState() => _QuizOverviewWidgetState();
}

class _QuizOverviewWidgetState extends State<QuizOverviewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<QuizOverviewCubit>().startWatching();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizOverviewCubit, QuizOverviewState>(
      builder: (context, state) {
        if (state.status == QuizOverviewStatus.loading &&
            !state.hasQuizzes) {
          return const _LoadingCard();
        }

        if (state.status == QuizOverviewStatus.error && !state.hasQuizzes) {
          return _ErrorCard(message: state.errorMessage ?? 'Fehler');
        }

        return _QuizTabCard(
          tabController: _tabController,
          openQuizzes: state.openQuizzes,
          completedQuizzes: state.completedQuizzes,
        );
      },
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Fehler: $message',
        style: TextStyle(color: Colors.red.shade900),
      ),
    );
  }
}

class _QuizTabCard extends StatelessWidget {
  final TabController tabController;
  final List<Quiz> openQuizzes;
  final List<Quiz> completedQuizzes;

  const _QuizTabCard({
    required this.tabController,
    required this.openQuizzes,
    required this.completedQuizzes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with tabs
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: Colors.indigo.shade700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Meine Prüfungen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push(Routes.quizHistory),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Alle'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigo.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Tab bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.indigo.shade700,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              padding: const EdgeInsets.all(4),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Offen'),
                      if (openQuizzes.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${openQuizzes.length}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Beendet'),
                      if (completedQuizzes.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${completedQuizzes.length}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab content
          SizedBox(
            height: _calculateTabHeight(openQuizzes, completedQuizzes),
            child: TabBarView(
              controller: tabController,
              children: [
                _buildQuizList(context, openQuizzes, isOpen: true),
                _buildQuizList(context, completedQuizzes, isOpen: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTabHeight(List<Quiz> open, List<Quiz> completed) {
    final maxItems = open.length > completed.length ? open.length : completed.length;
    if (maxItems == 0) return 100;
    // Each item is about 70 height + 16 padding top/bottom
    return (maxItems * 70.0) + 32;
  }

  Widget _buildQuizList(BuildContext context, List<Quiz> quizzes,
      {required bool isOpen}) {
    if (quizzes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isOpen ? Icons.hourglass_empty_rounded : Icons.history_rounded,
                size: 32,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                isOpen ? 'Keine offenen Prüfungen' : 'Keine beendeten Prüfungen',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return _QuizListItem(
          quiz: quiz,
          isOpen: isOpen,
        );
      },
    );
  }
}

class _QuizListItem extends StatelessWidget {
  final Quiz quiz;
  final bool isOpen;

  const _QuizListItem({
    required this.quiz,
    required this.isOpen,
  });

  String _getQuizTypeName(QuizType type) {
    switch (type) {
      case QuizType.motor:
        return 'Motor';
      case QuizType.sailingOnly:
        return 'Segel';
      case QuizType.combined:
        return 'Kombi';
      case QuizType.custom:
        return 'Eigenes';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Gerade eben';
    } else if (diff.inHours < 1) {
      return 'Vor ${diff.inMinutes} Min.';
    } else if (diff.inDays < 1) {
      return 'Vor ${diff.inHours} Std.';
    } else if (diff.inDays < 7) {
      return 'Vor ${diff.inDays} Tag${diff.inDays > 1 ? 'en' : ''}';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  Color _getStatusColor() {
    if (isOpen) {
      return Colors.orange;
    }
    switch (quiz.status) {
      case QuizStatus.completed:
        return quiz.earnedPoints >= (quiz.totalPoints * 0.9).ceil()
            ? Colors.green
            : Colors.red;
      case QuizStatus.abandoned:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    if (isOpen) {
      return Icons.play_circle_outline_rounded;
    }
    switch (quiz.status) {
      case QuizStatus.completed:
        return quiz.earnedPoints >= (quiz.totalPoints * 0.9).ceil()
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;
      case QuizStatus.abandoned:
        return Icons.remove_circle_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isOpen
            ? () {
                context.push(
                  Routes.quizSession,
                  extra: {'quizId': quiz.id},
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Status icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Quiz info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _getQuizTypeName(quiz.type),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (quiz.examSheetIndex != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            '#${quiz.examSheetIndex! + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(quiz.startedAt),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress/Result
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isOpen) ...[
                    Text(
                      '${quiz.answeredCount}/${quiz.totalQuestions}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    Text(
                      'Fragen',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ] else ...[
                    Text(
                      '${quiz.correctCount}/${quiz.totalQuestions}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      'Richtig',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),

              if (isOpen) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.orange.shade400,
                  size: 24,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
