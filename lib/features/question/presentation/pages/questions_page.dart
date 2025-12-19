import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/routing/routes.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/question_settings_repository.dart';

enum QuestionCategory {
  basisfragen('basisfragen', 'Basis'),
  spezifischBinnen('spezifisch_binnen', 'Binnen'),
  spezifischSegeln('spezifisch_segeln', 'Segeln');

  final String id;
  final String displayName;
  const QuestionCategory(this.id, this.displayName);
}

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final QuestionRepository _repository = getIt<QuestionRepository>();
  final QuestionSettingsRepository _settingsRepository =
      getIt<QuestionSettingsRepository>();
  final ScrollController _scrollController = ScrollController();

  final List<Question> _questions = [];
  final Map<int, int> _rankings = {};
  final Set<QuestionCategory> _selectedCategories = {};

  bool _isLoading = false;
  bool _hasMore = true;
  int _totalCount = 0;
  int _masteryThreshold = 3;

  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    _masteryThreshold = await _settingsRepository.getMasteryThreshold();
    _loadQuestions(reset: true);
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadQuestions();
    }
  }

  List<String>? get _categoryIds {
    if (_selectedCategories.isEmpty) return null;
    return _selectedCategories.map((c) => c.id).toList();
  }

  Future<void> _loadQuestions({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;

    setState(() => _isLoading = true);

    try {
      if (reset) {
        _questions.clear();
        _rankings.clear();
        _hasMore = true;
        _totalCount = await _repository.getQuestionCountByCategories(_categoryIds);
      }

      final newQuestions = await _repository.getQuestionsPaginated(
        limit: _pageSize,
        offset: _questions.length,
        categoryIds: _categoryIds,
      );

      // Fetch rankings for new questions
      if (newQuestions.isNotEmpty) {
        final questionIds = newQuestions.map((q) => q.id).toList();
        final newRankings = await _repository.getRankingsForQuestions(questionIds);
        _rankings.addAll(newRankings);
      }

      setState(() {
        _questions.addAll(newQuestions);
        _hasMore = newQuestions.length == _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading questions: $e');
      setState(() => _isLoading = false);
    }
  }

  void _toggleCategory(QuestionCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
    _loadQuestions(reset: true);
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
              _buildFilterChips(),
              Expanded(
                child: _buildQuestionsList(),
              ),
              if (_questions.isNotEmpty) _buildPaginationInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationInfo() {
    final loadedCount = _questions.length;
    final percentage = _totalCount > 0 ? (loadedCount / _totalCount * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$loadedCount von $_totalCount Fragen geladen',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _totalCount > 0 ? loadedCount / _totalCount : 0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
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
                  'Alle Fragen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$_totalCount Fragen verfügbar',
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

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: QuestionCategory.values.map((category) {
          final isSelected = _selectedCategories.contains(category);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: category != QuestionCategory.values.last ? 8 : 0,
              ),
              child: FilterChip(
                selected: isSelected,
                label: Text(category.displayName),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
                backgroundColor: Colors.white,
                selectedColor: Colors.blue.shade600,
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                ),
                onSelected: (_) => _toggleCategory(category),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuestionsList() {
    if (_questions.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Keine Fragen gefunden',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _questions.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _questions.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final question = _questions[index];
        final timesCorrect = _rankings[question.id] ?? 0;

        return _QuestionCard(
          question: question,
          timesCorrect: timesCorrect,
          masteryThreshold: _masteryThreshold,
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int timesCorrect;
  final int masteryThreshold;

  const _QuestionCard({
    required this.question,
    required this.timesCorrect,
    required this.masteryThreshold,
  });

  bool get _isMastered => timesCorrect >= masteryThreshold;

  Color get _categoryColor {
    switch (question.categoryId) {
      case 'basisfragen':
        return Colors.blue;
      case 'spezifisch_binnen':
        return Colors.orange;
      case 'spezifisch_segeln':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String get _categoryDisplayName {
    switch (question.categoryId) {
      case 'basisfragen':
        return 'Basis';
      case 'spezifisch_binnen':
        return 'Binnen';
      case 'spezifisch_segeln':
        return 'Segeln';
      default:
        return question.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              Routes.questionDetail,
              extra: {
                'question': question,
                'timesCorrect': timesCorrect,
                'masteryThreshold': masteryThreshold,
              },
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _categoryDisplayName,
                        style: TextStyle(
                          color: _categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Frage ${question.id}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (question.hasImages && question.imageRefs.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/questions/${question.imageRefs.first}',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  question.questionText,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_isMastered) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Gemeistert',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.repeat_rounded,
                        size: 16,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$timesCorrect von $masteryThreshold',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(width: 16),
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colors.amber.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${question.points} Punkte',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
