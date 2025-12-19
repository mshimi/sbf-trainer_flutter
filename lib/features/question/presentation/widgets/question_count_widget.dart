import 'package:flutter/material.dart';

import '../../../../core/di/di.dart';
import '../../domain/repositories/question_repository.dart';

class QuestionCountWidget extends StatefulWidget {
  const QuestionCountWidget({super.key});

  @override
  State<QuestionCountWidget> createState() => _QuestionCountWidgetState();
}

class _QuestionCountWidgetState extends State<QuestionCountWidget> {
  late Future<(int, int)> _countsFuture;

  @override
  void initState() {
    super.initState();
    final repo = getIt<QuestionRepository>();
    _countsFuture = Future.wait([
      repo.getQuestionCount(),
      repo.getRankingCount(),
    ]).then((results) => (results[0], results[1]));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(int, int)>(
      future: _countsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final (questionCount, rankingCount) = snapshot.data!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Questions in DB: $questionCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Rankings in DB: $rankingCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        );
      },
    );
  }
}
