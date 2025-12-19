import 'package:rxdart/rxdart.dart';

import '../entities/mastery_stats.dart';
import '../repositories/question_repository.dart';
import '../repositories/question_settings_repository.dart';

class GetMasteryStats {
  final QuestionRepository _questionRepository;
  final QuestionSettingsRepository _settingsRepository;

  GetMasteryStats(this._questionRepository, this._settingsRepository);

  /// One-time fetch
  Future<MasteryStats> call() async {
    final threshold = await _settingsRepository.getMasteryThreshold();
    final totalQuestions = await _questionRepository.getQuestionCount();
    final masteredQuestions =
        await _questionRepository.getMasteredQuestionCount(threshold);

    return MasteryStats(
      totalQuestions: totalQuestions,
      masteredQuestions: masteredQuestions,
    );
  }

  /// Watch for changes
  Stream<MasteryStats> watch() async* {
    final threshold = await _settingsRepository.getMasteryThreshold();

    yield* Rx.combineLatest2(
      _questionRepository.watchQuestionCount(),
      _questionRepository.watchMasteredQuestionCount(threshold),
      (int total, int mastered) => MasteryStats(
        totalQuestions: total,
        masteredQuestions: mastered,
      ),
    );
  }
}
