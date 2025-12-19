import 'package:flutter/material.dart';

class QuestionCategory {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final int questionCount;

  const QuestionCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.questionCount,
  });
}

class CustomQuizConfig {
  final int questionCount;
  final List<String> categoryIds;

  const CustomQuizConfig({
    required this.questionCount,
    required this.categoryIds,
  });
}

class CustomQuizDialog extends StatefulWidget {
  final int totalQuestionsAvailable;
  final Map<String, int> categoryQuestionCounts;

  const CustomQuizDialog({
    super.key,
    required this.totalQuestionsAvailable,
    required this.categoryQuestionCounts,
  });

  static Future<CustomQuizConfig?> show(
    BuildContext context, {
    required int totalQuestionsAvailable,
    required Map<String, int> categoryQuestionCounts,
  }) {
    return showDialog<CustomQuizConfig>(
      context: context,
      builder: (context) => CustomQuizDialog(
        totalQuestionsAvailable: totalQuestionsAvailable,
        categoryQuestionCounts: categoryQuestionCounts,
      ),
    );
  }

  @override
  State<CustomQuizDialog> createState() => _CustomQuizDialogState();
}

class _CustomQuizDialogState extends State<CustomQuizDialog> {
  late int _questionCount;
  final Set<String> _selectedCategories = {};

  static const List<QuestionCategory> _categories = [
    QuestionCategory(
      id: 'basisfragen',
      name: 'Basisfragen',
      color: Colors.blue,
      icon: Icons.anchor_rounded,
      questionCount: 72,
    ),
    QuestionCategory(
      id: 'spezifisch_binnen',
      name: 'Motor/Binnen',
      color: Colors.orange,
      icon: Icons.directions_boat_rounded,
      questionCount: 181,
    ),
    QuestionCategory(
      id: 'spezifisch_segeln',
      name: 'Segeln',
      color: Colors.teal,
      icon: Icons.sailing_rounded,
      questionCount: 47,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _questionCount = 20;
    // Select all categories by default
    _selectedCategories.addAll(_categories.map((c) => c.id));
  }

  int get _availableQuestions {
    if (_selectedCategories.isEmpty) return 0;
    return _selectedCategories.fold(0, (sum, id) {
      return sum + (widget.categoryQuestionCounts[id] ?? 0);
    });
  }

  int get _maxQuestions {
    final available = _availableQuestions;
    return available > 100 ? 100 : available;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildContent(),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade700, Colors.purple.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eigenes Quiz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Passe dein Quiz an',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories section
          const Text(
            'Kategorien',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...(_categories.map((category) => _buildCategoryTile(category))),

          const SizedBox(height: 20),

          // Question count section
          Row(
            children: [
              const Text(
                'Anzahl Fragen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_questionCount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.purple.shade400,
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: Colors.purple.shade600,
              overlayColor: Colors.purple.shade100.withValues(alpha: 0.3),
              trackHeight: 6,
            ),
            child: Slider(
              value: _questionCount.toDouble(),
              min: 5,
              max: _maxQuestions.toDouble(),
              divisions: (_maxQuestions - 5) > 0 ? (_maxQuestions - 5) ~/ 5 : 1,
              onChanged: _selectedCategories.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        _questionCount = value.round();
                      });
                    },
            ),
          ),

          // Quick select buttons
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [10, 20, 30, 50].map((count) {
              final isSelected = _questionCount == count;
              final isDisabled = count > _maxQuestions;
              return _QuickSelectButton(
                count: count,
                isSelected: isSelected,
                isDisabled: isDisabled,
                onTap: isDisabled
                    ? null
                    : () => setState(() => _questionCount = count),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Info text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$_availableQuestions Fragen in ausgewählten Kategorien verfügbar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(QuestionCategory category) {
    final isSelected = _selectedCategories.contains(category.id);
    final questionCount = widget.categoryQuestionCounts[category.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedCategories.remove(category.id);
              } else {
                _selectedCategories.add(category.id);
              }
              // Adjust question count if needed
              if (_questionCount > _maxQuestions) {
                _questionCount = _maxQuestions > 5 ? _maxQuestions : 5;
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color.withValues(alpha: 0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? category.color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? category.color.withValues(alpha: 0.2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: isSelected ? category.color : Colors.grey.shade500,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? category.color : Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        '$questionCount Fragen',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedCategories.add(category.id);
                      } else {
                        _selectedCategories.remove(category.id);
                      }
                      if (_questionCount > _maxQuestions) {
                        _questionCount = _maxQuestions > 5 ? _maxQuestions : 5;
                      }
                    });
                  },
                  activeColor: category.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    final canStart = _selectedCategories.isNotEmpty && _questionCount >= 5;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Text(
                'Abbrechen',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canStart
                  ? () {
                      Navigator.of(context).pop(CustomQuizConfig(
                        questionCount: _questionCount,
                        categoryIds: _selectedCategories.toList(),
                      ));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.purple.shade600,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow_rounded, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Quiz starten',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: canStart ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickSelectButton extends StatelessWidget {
  final int count;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const _QuickSelectButton({
    required this.count,
    required this.isSelected,
    required this.isDisabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.purple.shade100
                : isDisabled
                    ? Colors.grey.shade100
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.purple.shade400, width: 2)
                : null,
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.purple.shade700
                  : isDisabled
                      ? Colors.grey.shade400
                      : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
