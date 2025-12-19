import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/routing/routes.dart';
import '../../../question/domain/repositories/question_repository.dart';
import '../../domain/entities/quiz.dart';
import '../widgets/custom_quiz_dialog.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final QuestionRepository _questionRepository = getIt<QuestionRepository>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExamList(QuizType.motor),
                    _buildExamList(QuizType.sailingOnly),
                    _buildExamList(QuizType.combined),
                  ],
                ),
              ),
              _buildCustomQuizButton(),
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
            Colors.blue.shade900,
            Colors.blue.shade700,
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
                  'Alle Fragebögen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '15 Fragebögen pro Kategorie',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade500],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
        ),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Motor'),
          Tab(text: 'Segel'),
          Tab(text: 'Kombi'),
        ],
      ),
    );
  }

  Widget _buildExamList(QuizType type) {
    final int examCount = 15;
    final String questionCountText;
    final Color accentColor;
    final IconData icon;

    switch (type) {
      case QuizType.motor:
        questionCountText = '30 Fragen';
        accentColor = Colors.orange;
        icon = Icons.directions_boat_rounded;
        break;
      case QuizType.sailingOnly:
        questionCountText = '25 Fragen';
        accentColor = Colors.teal;
        icon = Icons.sailing_rounded;
        break;
      case QuizType.combined:
        questionCountText = '37 Fragen';
        accentColor = Colors.purple;
        icon = Icons.merge_type_rounded;
        break;
      case QuizType.custom:
        questionCountText = 'Individuell';
        accentColor = Colors.indigo;
        icon = Icons.tune_rounded;
        break;
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: examCount,
      itemBuilder: (context, index) {
        return _ExamCard(
          examNumber: index + 1,
          questionCount: questionCountText,
          accentColor: accentColor,
          icon: icon,
          onTap: () {
            context.push(
              Routes.quizSession,
              extra: {
                'quizType': type,
                'examSheetIndex': index,
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCustomQuizButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showCustomQuizDialog,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade600, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade600.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Eigenes Quiz starten',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final int examNumber;
  final String questionCount;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onTap;

  const _ExamCard({
    required this.examNumber,
    required this.questionCount,
    required this.accentColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '$examNumber',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                        'Fragebogen $examNumber',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            icon,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            questionCount,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: accentColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
