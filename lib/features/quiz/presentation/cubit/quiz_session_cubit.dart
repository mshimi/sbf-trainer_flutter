import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../question/domain/entities/question.dart';
import '../../../question/domain/repositories/question_repository.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/usecases/complete_quiz.dart';
import '../../domain/usecases/start_quiz.dart';
import '../../domain/usecases/submit_answer.dart';
import '../../domain/repositories/quiz_repository.dart';
import 'quiz_session_state.dart';

class QuizSessionCubit extends Cubit<QuizSessionState> {
  final StartQuiz _startQuiz;
  final SubmitAnswer _submitAnswer;
  final CompleteQuiz _completeQuiz;
  final QuizRepository _quizRepository;
  final QuestionRepository _questionRepository;

  Map<int, Question> _questionCache = {};

  QuizSessionCubit({
    required StartQuiz startQuiz,
    required SubmitAnswer submitAnswer,
    required CompleteQuiz completeQuiz,
    required QuizRepository quizRepository,
    required QuestionRepository questionRepository,
  })  : _startQuiz = startQuiz,
        _submitAnswer = submitAnswer,
        _completeQuiz = completeQuiz,
        _quizRepository = quizRepository,
        _questionRepository = questionRepository,
        super(const QuizSessionState.initial());

  Future<void> startNewQuiz({
    required QuizType type,
    int? examSheetIndex,
    List<int>? customQuestionIds,
  }) async {
    emit(state.copyWith(status: QuizSessionStatus.loading));

    try {
      final quiz = await _startQuiz(
        type: type,
        examSheetIndex: examSheetIndex,
        customQuestionIds: customQuestionIds,
      );

      // Preload all questions for this quiz
      await _preloadQuestions(quiz);

      // Load the first question
      await _loadQuestion(quiz, 0);
    } catch (e) {
      emit(state.copyWith(
        status: QuizSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> resumeQuiz(String quizId) async {
    emit(state.copyWith(status: QuizSessionStatus.loading));

    try {
      final quiz = await _quizRepository.getQuizById(quizId);
      if (quiz == null) {
        emit(state.copyWith(
          status: QuizSessionStatus.error,
          errorMessage: 'Quiz nicht gefunden',
        ));
        return;
      }

      // Preload all questions for this quiz
      await _preloadQuestions(quiz);

      // Load the current question (resume position)
      await _loadQuestion(quiz, quiz.currentQuestionIndex);
    } catch (e) {
      emit(state.copyWith(
        status: QuizSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _preloadQuestions(Quiz quiz) async {
    final questionIds = quiz.questions.map((q) => q.questionId).toList();

    // Fetch questions in batches
    // final questions = await _questionRepository.getQuestionsPaginated(
    //   limit: 1000,
    //   offset: 0,
    //   );

  // fetch by Ids for better Performance // needs tests
    final questions = await _questionRepository.getQuestionsByIds(
        ids: questionIds
    );

    _questionCache = {
      for (var q in questions)
        if (questionIds.contains(q.id)) q.id: q
    };
  }

  Future<void> _loadQuestion(Quiz quiz, int index) async {
    if (index >= quiz.questions.length) {
      emit(state.copyWith(
        status: QuizSessionStatus.error,
        errorMessage: 'Ungültiger Fragenindex',
      ));
      return;
    }

    final quizQuestion = quiz.questions[index];
    final question = _questionCache[quizQuestion.questionId];

    if (question == null) {
      emit(state.copyWith(
        status: QuizSessionStatus.error,
        errorMessage: 'Frage nicht gefunden',
      ));
      return;
    }

    // Check if this question was already answered
    final alreadyAnswered = quizQuestion.selectedAnswerId != null;

    emit(state.copyWith(
      status: QuizSessionStatus.ready,
      quiz: quiz,
      currentIndex: index,
      currentQuestion: question,
      shuffledAnswerIds: quizQuestion.shuffledAnswerIds,
      selectedAnswerId: alreadyAnswered ? quizQuestion.selectedAnswerId : null,
      wasCorrect: alreadyAnswered ? quizQuestion.wasCorrect : null,
      clearSelection: !alreadyAnswered,
    ));

    // Update current index in database
    await _quizRepository.updateCurrentIndex(quiz.id, index);
  }

  void selectAnswer(String answerId) {
    if (state.hasAnswered) return; // Already answered

    final question = state.currentQuestion;
    if (question == null) return;

    // Find if the selected answer is correct
    final selectedAnswer = question.answers.firstWhere(
      (a) => a.id == answerId,
      orElse: () => question.answers.first,
    );
    final isCorrect = selectedAnswer.isCorrect;

    emit(state.copyWith(
      selectedAnswerId: answerId,
      wasCorrect: isCorrect,
    ));
  }

  Future<void> submitAndNext() async {
    if (!state.hasAnswered || state.quiz == null) return;

    emit(state.copyWith(status: QuizSessionStatus.submitting));

    try {
      final quiz = state.quiz!;
      final quizQuestion = quiz.questions[state.currentIndex];

      // Submit the answer to database
      await _submitAnswer(
        quizId: quiz.id,
        questionId: quizQuestion.questionId,
        selectedAnswerId: state.selectedAnswerId!,
        wasCorrect: state.wasCorrect!,
      );

      // Update question ranking based on correctness
      // Correct: increment by 1, Wrong: reset to 0
      await _questionRepository.updateRanking(
        questionId: quizQuestion.questionId,
        wasCorrect: state.wasCorrect!,
      );

      // Reload the quiz to get updated state
      final updatedQuiz = await _quizRepository.getQuizById(quiz.id);
      if (updatedQuiz == null) {
        emit(state.copyWith(
          status: QuizSessionStatus.error,
          errorMessage: 'Quiz nicht gefunden',
        ));
        return;
      }

      // Check if this was the last question
      if (state.isLastQuestion) {
        // Complete the quiz
        await _completeQuiz(quiz.id);
        emit(state.copyWith(
          status: QuizSessionStatus.completed,
          quiz: updatedQuiz,
        ));
      } else {
        // Move to next question
        await _loadQuestion(updatedQuiz, state.currentIndex + 1);
      }
    } catch (e) {
      emit(state.copyWith(
        status: QuizSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> goToQuestion(int index) async {
    if (state.quiz == null) return;
    if (index < 0 || index >= state.quiz!.totalQuestions) return;

    await _loadQuestion(state.quiz!, index);
  }

  Future<QuizResult?> finishQuiz() async {
    if (state.quiz == null) return null;

    try {
      final result = await _completeQuiz(state.quiz!.id);
      emit(state.copyWith(status: QuizSessionStatus.completed));
      return result;
    } catch (e) {
      emit(state.copyWith(
        status: QuizSessionStatus.error,
        errorMessage: e.toString(),
      ));
      return null;
    }
  }
}
