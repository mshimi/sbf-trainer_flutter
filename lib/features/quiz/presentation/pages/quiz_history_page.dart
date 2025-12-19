import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../domain/entities/quiz.dart';
import '../cubit/quiz_history_cubit.dart';
import '../cubit/quiz_history_state.dart';

class QuizHistoryPage extends StatefulWidget {
  const QuizHistoryPage({super.key});

  @override
  State<QuizHistoryPage> createState() => _QuizHistoryPageState();
}

class _QuizHistoryPageState extends State<QuizHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<QuizHistoryCubit>().loadInitial();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<QuizHistoryCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(context),
              _buildTabBar(),
              Expanded(
                child: BlocBuilder<QuizHistoryCubit, QuizHistoryState>(
                  builder: (context, state) {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _buildQuizList(state.openQuizzes, state, isOpen: true),
                        _buildQuizList(state.completedQuizzes, state,
                            isOpen: false),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade800,
            Colors.indigo.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
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
                const Text(
                  'Prüfungsverlauf',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Alle deine Prüfungen',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<QuizHistoryCubit, QuizHistoryState>(
            builder: (context, state) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.read<QuizHistoryCubit>().refresh(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: state.status == QuizHistoryStatus.loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: BlocBuilder<QuizHistoryCubit, QuizHistoryState>(
        builder: (context, state) {
          return TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade700, Colors.indigo.shade500],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
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
                    if (state.openQuizzes.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${state.openQuizzes.length}',
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
                    if (state.completedQuizzes.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${state.completedQuizzes.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuizList(List<Quiz> quizzes, QuizHistoryState state,
      {required bool isOpen}) {
    if (state.status == QuizHistoryStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == QuizHistoryStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              'Fehler beim Laden',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              state.errorMessage ?? 'Unbekannter Fehler',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<QuizHistoryCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOpen ? Icons.hourglass_empty_rounded : Icons.history_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              isOpen
                  ? 'Keine offenen Prüfungen'
                  : 'Keine abgeschlossenen Prüfungen',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isOpen
                  ? 'Starte eine neue Prüfung!'
                  : 'Schließe eine Prüfung ab',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<QuizHistoryCubit>().refresh(),
      child: ListView.builder(
        controller: isOpen ? null : _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: quizzes.length + (state.hasReachedEnd ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= quizzes.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final quiz = quizzes[index];
          return _QuizHistoryCard(
            quiz: quiz,
            isOpen: isOpen,
            onResume: isOpen
                ? () {
                    context.push(
                      Routes.quizSession,
                      extra: {'quizId': quiz.id},
                    );
                  }
                : null,
          );
        },
      ),
    );
  }
}

class _QuizHistoryCard extends StatelessWidget {
  final Quiz quiz;
  final bool isOpen;
  final VoidCallback? onResume;

  const _QuizHistoryCard({
    required this.quiz,
    required this.isOpen,
    this.onResume,
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
        return 'Eigenes Quiz';
    }
  }

  IconData _getQuizTypeIcon(QuizType type) {
    switch (type) {
      case QuizType.motor:
        return Icons.directions_boat_rounded;
      case QuizType.sailingOnly:
        return Icons.sailing_rounded;
      case QuizType.combined:
        return Icons.merge_type_rounded;
      case QuizType.custom:
        return Icons.tune_rounded;
    }
  }

  Color _getAccentColor() {
    if (isOpen) {
      return Colors.orange;
    }
    if (quiz.status == QuizStatus.abandoned) {
      return Colors.grey;
    }
    // Check if passed (90% threshold)
    final passed = quiz.earnedPoints >= (quiz.totalPoints * 0.9).ceil();
    return passed ? Colors.green : Colors.red;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mär',
      'Apr',
      'Mai',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Okt',
      'Nov',
      'Dez'
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day}. ${months[date.month - 1]} ${date.year}, $hour:$minute';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();
    final passed = !isOpen &&
        quiz.status == QuizStatus.completed &&
        quiz.earnedPoints >= (quiz.totalPoints * 0.9).ceil();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isOpen ? onResume : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
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
                    // Type icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getQuizTypeIcon(quiz.type),
                        color: accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title and date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _getQuizTypeName(quiz.type),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (quiz.examSheetIndex != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Bogen ${quiz.examSheetIndex! + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(quiz.startedAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOpen
                                ? Icons.play_circle_outline_rounded
                                : quiz.status == QuizStatus.abandoned
                                    ? Icons.cancel_outlined
                                    : passed
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                            size: 16,
                            color: accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOpen
                                ? 'Offen'
                                : quiz.status == QuizStatus.abandoned
                                    ? 'Abgebr.'
                                    : passed
                                        ? 'Best.'
                                        : 'Nicht best.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Stats row
                Row(
                  children: [
                    // Progress/Result
                    Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle_outline_rounded,
                        label: isOpen ? 'Beantwortet' : 'Richtig',
                        value: isOpen
                            ? '${quiz.answeredCount}/${quiz.totalQuestions}'
                            : '${quiz.correctCount}/${quiz.totalQuestions}',
                        color: accentColor,
                      ),
                    ),

                    // Points
                    if (!isOpen)
                      Expanded(
                        child: _StatItem(
                          icon: Icons.star_outline_rounded,
                          label: 'Punkte',
                          value: '${quiz.earnedPoints}/${quiz.totalPoints}',
                          color: Colors.amber.shade700,
                        ),
                      ),

                    // Duration
                    if (!isOpen && quiz.endedAt != null)
                      Expanded(
                        child: _StatItem(
                          icon: Icons.timer_outlined,
                          label: 'Dauer',
                          value: _formatDuration(
                              quiz.endedAt!.difference(quiz.startedAt)),
                          color: Colors.blue.shade600,
                        ),
                      ),

                    // Progress for open quizzes
                    if (isOpen)
                      Expanded(
                        child: _StatItem(
                          icon: Icons.percent_rounded,
                          label: 'Fortschritt',
                          value:
                              '${(quiz.progressPercentage * 100).toInt()}%',
                          color: Colors.blue.shade600,
                        ),
                      ),
                  ],
                ),

                // Continue button for open quizzes
                if (isOpen) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade600,
                          Colors.orange.shade400,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Fortsetzen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
