import 'dart:convert';

import 'package:flutter/services.dart';

import '../../question/data/dtos/question_dto.dart';
import '../../question/data/mapper/question_mapper.dart';
import '../../question/domain/repositories/question_repository.dart';
import '../../question/domain/repositories/question_settings_repository.dart';
import '../domain/app_initializer.dart';

class AppInitializerImpl implements AppInitializer {
  final QuestionRepository _questionRepository;
  final QuestionMapper _questionMapper;
  final QuestionSettingsRepository _questionSettingsRepository;

  AppInitializerImpl(
    this._questionRepository,
    this._questionMapper,
    this._questionSettingsRepository,
  );

  @override
  Future<bool> isInitialized() async {
    return _questionRepository.hasQuestions();
  }

  @override
  Future<void> initialize() async {
    final jsonString = await rootBundle.loadString('assets/data/questions.json');
    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final questionsJson = jsonData['questions'] as List<dynamic>;

    final questionDtos = questionsJson
        .map((q) => QuestionDto.fromJson(q as Map<String, dynamic>))
        .toList();

    final questions = questionDtos.map(_questionMapper.fromDto).toList();

    await _questionRepository.seedQuestions(questions);
    await _questionSettingsRepository.initializeDefaultSettings();
  }
}
