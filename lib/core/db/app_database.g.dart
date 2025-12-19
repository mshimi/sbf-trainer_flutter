// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasImagesMeta = const VerificationMeta(
    'hasImages',
  );
  @override
  late final GeneratedColumn<bool> hasImages = GeneratedColumn<bool>(
    'has_images',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_images" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _imageRefsJsonMeta = const VerificationMeta(
    'imageRefsJson',
  );
  @override
  late final GeneratedColumn<String> imageRefsJson = GeneratedColumn<String>(
    'image_refs_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    questionText,
    points,
    hasImages,
    imageRefsJson,
    answersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('has_images')) {
      context.handle(
        _hasImagesMeta,
        hasImages.isAcceptableOrUnknown(data['has_images']!, _hasImagesMeta),
      );
    }
    if (data.containsKey('image_refs_json')) {
      context.handle(
        _imageRefsJsonMeta,
        imageRefsJson.isAcceptableOrUnknown(
          data['image_refs_json']!,
          _imageRefsJsonMeta,
        ),
      );
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      hasImages: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_images'],
      )!,
      imageRefsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_refs_json'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final String categoryId;
  final String questionText;
  final int points;
  final bool hasImages;
  final String imageRefsJson;
  final String answersJson;
  const Question({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.points,
    required this.hasImages,
    required this.imageRefsJson,
    required this.answersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['question_text'] = Variable<String>(questionText);
    map['points'] = Variable<int>(points);
    map['has_images'] = Variable<bool>(hasImages);
    map['image_refs_json'] = Variable<String>(imageRefsJson);
    map['answers_json'] = Variable<String>(answersJson);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      questionText: Value(questionText),
      points: Value(points),
      hasImages: Value(hasImages),
      imageRefsJson: Value(imageRefsJson),
      answersJson: Value(answersJson),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      questionText: serializer.fromJson<String>(json['questionText']),
      points: serializer.fromJson<int>(json['points']),
      hasImages: serializer.fromJson<bool>(json['hasImages']),
      imageRefsJson: serializer.fromJson<String>(json['imageRefsJson']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'questionText': serializer.toJson<String>(questionText),
      'points': serializer.toJson<int>(points),
      'hasImages': serializer.toJson<bool>(hasImages),
      'imageRefsJson': serializer.toJson<String>(imageRefsJson),
      'answersJson': serializer.toJson<String>(answersJson),
    };
  }

  Question copyWith({
    int? id,
    String? categoryId,
    String? questionText,
    int? points,
    bool? hasImages,
    String? imageRefsJson,
    String? answersJson,
  }) => Question(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    questionText: questionText ?? this.questionText,
    points: points ?? this.points,
    hasImages: hasImages ?? this.hasImages,
    imageRefsJson: imageRefsJson ?? this.imageRefsJson,
    answersJson: answersJson ?? this.answersJson,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      points: data.points.present ? data.points.value : this.points,
      hasImages: data.hasImages.present ? data.hasImages.value : this.hasImages,
      imageRefsJson: data.imageRefsJson.present
          ? data.imageRefsJson.value
          : this.imageRefsJson,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('questionText: $questionText, ')
          ..write('points: $points, ')
          ..write('hasImages: $hasImages, ')
          ..write('imageRefsJson: $imageRefsJson, ')
          ..write('answersJson: $answersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    questionText,
    points,
    hasImages,
    imageRefsJson,
    answersJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.questionText == this.questionText &&
          other.points == this.points &&
          other.hasImages == this.hasImages &&
          other.imageRefsJson == this.imageRefsJson &&
          other.answersJson == this.answersJson);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<String> categoryId;
  final Value<String> questionText;
  final Value<int> points;
  final Value<bool> hasImages;
  final Value<String> imageRefsJson;
  final Value<String> answersJson;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.questionText = const Value.absent(),
    this.points = const Value.absent(),
    this.hasImages = const Value.absent(),
    this.imageRefsJson = const Value.absent(),
    this.answersJson = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required String categoryId,
    required String questionText,
    required int points,
    this.hasImages = const Value.absent(),
    this.imageRefsJson = const Value.absent(),
    this.answersJson = const Value.absent(),
  }) : categoryId = Value(categoryId),
       questionText = Value(questionText),
       points = Value(points);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<String>? categoryId,
    Expression<String>? questionText,
    Expression<int>? points,
    Expression<bool>? hasImages,
    Expression<String>? imageRefsJson,
    Expression<String>? answersJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (questionText != null) 'question_text': questionText,
      if (points != null) 'points': points,
      if (hasImages != null) 'has_images': hasImages,
      if (imageRefsJson != null) 'image_refs_json': imageRefsJson,
      if (answersJson != null) 'answers_json': answersJson,
    });
  }

  QuestionsCompanion copyWith({
    Value<int>? id,
    Value<String>? categoryId,
    Value<String>? questionText,
    Value<int>? points,
    Value<bool>? hasImages,
    Value<String>? imageRefsJson,
    Value<String>? answersJson,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      questionText: questionText ?? this.questionText,
      points: points ?? this.points,
      hasImages: hasImages ?? this.hasImages,
      imageRefsJson: imageRefsJson ?? this.imageRefsJson,
      answersJson: answersJson ?? this.answersJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (hasImages.present) {
      map['has_images'] = Variable<bool>(hasImages.value);
    }
    if (imageRefsJson.present) {
      map['image_refs_json'] = Variable<String>(imageRefsJson.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('questionText: $questionText, ')
          ..write('points: $points, ')
          ..write('hasImages: $hasImages, ')
          ..write('imageRefsJson: $imageRefsJson, ')
          ..write('answersJson: $answersJson')
          ..write(')'))
        .toString();
  }
}

class $QuestionRankingsTable extends QuestionRankings
    with TableInfo<$QuestionRankingsTable, QuestionRanking> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionRankingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _timesCorrectMeta = const VerificationMeta(
    'timesCorrect',
  );
  @override
  late final GeneratedColumn<int> timesCorrect = GeneratedColumn<int>(
    'times_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [questionId, timesCorrect];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_rankings';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionRanking> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    }
    if (data.containsKey('times_correct')) {
      context.handle(
        _timesCorrectMeta,
        timesCorrect.isAcceptableOrUnknown(
          data['times_correct']!,
          _timesCorrectMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  QuestionRanking map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionRanking(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      )!,
      timesCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_correct'],
      )!,
    );
  }

  @override
  $QuestionRankingsTable createAlias(String alias) {
    return $QuestionRankingsTable(attachedDatabase, alias);
  }
}

class QuestionRanking extends DataClass implements Insertable<QuestionRanking> {
  final int questionId;
  final int timesCorrect;
  const QuestionRanking({required this.questionId, required this.timesCorrect});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<int>(questionId);
    map['times_correct'] = Variable<int>(timesCorrect);
    return map;
  }

  QuestionRankingsCompanion toCompanion(bool nullToAbsent) {
    return QuestionRankingsCompanion(
      questionId: Value(questionId),
      timesCorrect: Value(timesCorrect),
    );
  }

  factory QuestionRanking.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionRanking(
      questionId: serializer.fromJson<int>(json['questionId']),
      timesCorrect: serializer.fromJson<int>(json['timesCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<int>(questionId),
      'timesCorrect': serializer.toJson<int>(timesCorrect),
    };
  }

  QuestionRanking copyWith({int? questionId, int? timesCorrect}) =>
      QuestionRanking(
        questionId: questionId ?? this.questionId,
        timesCorrect: timesCorrect ?? this.timesCorrect,
      );
  QuestionRanking copyWithCompanion(QuestionRankingsCompanion data) {
    return QuestionRanking(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      timesCorrect: data.timesCorrect.present
          ? data.timesCorrect.value
          : this.timesCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionRanking(')
          ..write('questionId: $questionId, ')
          ..write('timesCorrect: $timesCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questionId, timesCorrect);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionRanking &&
          other.questionId == this.questionId &&
          other.timesCorrect == this.timesCorrect);
}

class QuestionRankingsCompanion extends UpdateCompanion<QuestionRanking> {
  final Value<int> questionId;
  final Value<int> timesCorrect;
  const QuestionRankingsCompanion({
    this.questionId = const Value.absent(),
    this.timesCorrect = const Value.absent(),
  });
  QuestionRankingsCompanion.insert({
    this.questionId = const Value.absent(),
    this.timesCorrect = const Value.absent(),
  });
  static Insertable<QuestionRanking> custom({
    Expression<int>? questionId,
    Expression<int>? timesCorrect,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (timesCorrect != null) 'times_correct': timesCorrect,
    });
  }

  QuestionRankingsCompanion copyWith({
    Value<int>? questionId,
    Value<int>? timesCorrect,
  }) {
    return QuestionRankingsCompanion(
      questionId: questionId ?? this.questionId,
      timesCorrect: timesCorrect ?? this.timesCorrect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (timesCorrect.present) {
      map['times_correct'] = Variable<int>(timesCorrect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionRankingsCompanion(')
          ..write('questionId: $questionId, ')
          ..write('timesCorrect: $timesCorrect')
          ..write(')'))
        .toString();
  }
}

class $QuestionSettingsTable extends QuestionSettings
    with TableInfo<$QuestionSettingsTable, QuestionSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  QuestionSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $QuestionSettingsTable createAlias(String alias) {
    return $QuestionSettingsTable(attachedDatabase, alias);
  }
}

class QuestionSetting extends DataClass implements Insertable<QuestionSetting> {
  final String key;
  final int value;
  const QuestionSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<int>(value);
    return map;
  }

  QuestionSettingsCompanion toCompanion(bool nullToAbsent) {
    return QuestionSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory QuestionSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<int>(value),
    };
  }

  QuestionSetting copyWith({String? key, int? value}) =>
      QuestionSetting(key: key ?? this.key, value: value ?? this.value);
  QuestionSetting copyWithCompanion(QuestionSettingsCompanion data) {
    return QuestionSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class QuestionSettingsCompanion extends UpdateCompanion<QuestionSetting> {
  final Value<String> key;
  final Value<int> value;
  final Value<int> rowid;
  const QuestionSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionSettingsCompanion.insert({
    required String key,
    required int value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<QuestionSetting> custom({
    Expression<String>? key,
    Expression<int>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionSettingsCompanion copyWith({
    Value<String>? key,
    Value<int>? value,
    Value<int>? rowid,
  }) {
    return QuestionSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizzesTable extends Quizzes with TableInfo<$QuizzesTable, Quizze> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizzesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizTypeMeta = const VerificationMeta(
    'quizType',
  );
  @override
  late final GeneratedColumn<String> quizType = GeneratedColumn<String>(
    'quiz_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examSheetIndexMeta = const VerificationMeta(
    'examSheetIndex',
  );
  @override
  late final GeneratedColumn<int> examSheetIndex = GeneratedColumn<int>(
    'exam_sheet_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('in_progress'),
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswersMeta = const VerificationMeta(
    'correctAnswers',
  );
  @override
  late final GeneratedColumn<int> correctAnswers = GeneratedColumn<int>(
    'correct_answers',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPointsMeta = const VerificationMeta(
    'totalPoints',
  );
  @override
  late final GeneratedColumn<int> totalPoints = GeneratedColumn<int>(
    'total_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _earnedPointsMeta = const VerificationMeta(
    'earnedPoints',
  );
  @override
  late final GeneratedColumn<int> earnedPoints = GeneratedColumn<int>(
    'earned_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  @override
  late final GeneratedColumn<bool> passed = GeneratedColumn<bool>(
    'passed',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _currentQuestionIndexMeta =
      const VerificationMeta('currentQuestionIndex');
  @override
  late final GeneratedColumn<int> currentQuestionIndex = GeneratedColumn<int>(
    'current_question_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quizType,
    examSheetIndex,
    startedAt,
    endedAt,
    status,
    totalQuestions,
    correctAnswers,
    totalPoints,
    earnedPoints,
    passed,
    currentQuestionIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quizzes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quizze> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quiz_type')) {
      context.handle(
        _quizTypeMeta,
        quizType.isAcceptableOrUnknown(data['quiz_type']!, _quizTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_quizTypeMeta);
    }
    if (data.containsKey('exam_sheet_index')) {
      context.handle(
        _examSheetIndexMeta,
        examSheetIndex.isAcceptableOrUnknown(
          data['exam_sheet_index']!,
          _examSheetIndexMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('correct_answers')) {
      context.handle(
        _correctAnswersMeta,
        correctAnswers.isAcceptableOrUnknown(
          data['correct_answers']!,
          _correctAnswersMeta,
        ),
      );
    }
    if (data.containsKey('total_points')) {
      context.handle(
        _totalPointsMeta,
        totalPoints.isAcceptableOrUnknown(
          data['total_points']!,
          _totalPointsMeta,
        ),
      );
    }
    if (data.containsKey('earned_points')) {
      context.handle(
        _earnedPointsMeta,
        earnedPoints.isAcceptableOrUnknown(
          data['earned_points']!,
          _earnedPointsMeta,
        ),
      );
    }
    if (data.containsKey('passed')) {
      context.handle(
        _passedMeta,
        passed.isAcceptableOrUnknown(data['passed']!, _passedMeta),
      );
    }
    if (data.containsKey('current_question_index')) {
      context.handle(
        _currentQuestionIndexMeta,
        currentQuestionIndex.isAcceptableOrUnknown(
          data['current_question_index']!,
          _currentQuestionIndexMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quizze map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quizze(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quizType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_type'],
      )!,
      examSheetIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_sheet_index'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      correctAnswers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answers'],
      )!,
      totalPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_points'],
      )!,
      earnedPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earned_points'],
      )!,
      passed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}passed'],
      ),
      currentQuestionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_question_index'],
      )!,
    );
  }

  @override
  $QuizzesTable createAlias(String alias) {
    return $QuizzesTable(attachedDatabase, alias);
  }
}

class Quizze extends DataClass implements Insertable<Quizze> {
  final String id;
  final String quizType;
  final int? examSheetIndex;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final int totalQuestions;
  final int correctAnswers;
  final int totalPoints;
  final int earnedPoints;
  final bool? passed;
  final int currentQuestionIndex;
  const Quizze({
    required this.id,
    required this.quizType,
    this.examSheetIndex,
    required this.startedAt,
    this.endedAt,
    required this.status,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalPoints,
    required this.earnedPoints,
    this.passed,
    required this.currentQuestionIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quiz_type'] = Variable<String>(quizType);
    if (!nullToAbsent || examSheetIndex != null) {
      map['exam_sheet_index'] = Variable<int>(examSheetIndex);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['correct_answers'] = Variable<int>(correctAnswers);
    map['total_points'] = Variable<int>(totalPoints);
    map['earned_points'] = Variable<int>(earnedPoints);
    if (!nullToAbsent || passed != null) {
      map['passed'] = Variable<bool>(passed);
    }
    map['current_question_index'] = Variable<int>(currentQuestionIndex);
    return map;
  }

  QuizzesCompanion toCompanion(bool nullToAbsent) {
    return QuizzesCompanion(
      id: Value(id),
      quizType: Value(quizType),
      examSheetIndex: examSheetIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(examSheetIndex),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      totalQuestions: Value(totalQuestions),
      correctAnswers: Value(correctAnswers),
      totalPoints: Value(totalPoints),
      earnedPoints: Value(earnedPoints),
      passed: passed == null && nullToAbsent
          ? const Value.absent()
          : Value(passed),
      currentQuestionIndex: Value(currentQuestionIndex),
    );
  }

  factory Quizze.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quizze(
      id: serializer.fromJson<String>(json['id']),
      quizType: serializer.fromJson<String>(json['quizType']),
      examSheetIndex: serializer.fromJson<int?>(json['examSheetIndex']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      correctAnswers: serializer.fromJson<int>(json['correctAnswers']),
      totalPoints: serializer.fromJson<int>(json['totalPoints']),
      earnedPoints: serializer.fromJson<int>(json['earnedPoints']),
      passed: serializer.fromJson<bool?>(json['passed']),
      currentQuestionIndex: serializer.fromJson<int>(
        json['currentQuestionIndex'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quizType': serializer.toJson<String>(quizType),
      'examSheetIndex': serializer.toJson<int?>(examSheetIndex),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'correctAnswers': serializer.toJson<int>(correctAnswers),
      'totalPoints': serializer.toJson<int>(totalPoints),
      'earnedPoints': serializer.toJson<int>(earnedPoints),
      'passed': serializer.toJson<bool?>(passed),
      'currentQuestionIndex': serializer.toJson<int>(currentQuestionIndex),
    };
  }

  Quizze copyWith({
    String? id,
    String? quizType,
    Value<int?> examSheetIndex = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    int? totalQuestions,
    int? correctAnswers,
    int? totalPoints,
    int? earnedPoints,
    Value<bool?> passed = const Value.absent(),
    int? currentQuestionIndex,
  }) => Quizze(
    id: id ?? this.id,
    quizType: quizType ?? this.quizType,
    examSheetIndex: examSheetIndex.present
        ? examSheetIndex.value
        : this.examSheetIndex,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    correctAnswers: correctAnswers ?? this.correctAnswers,
    totalPoints: totalPoints ?? this.totalPoints,
    earnedPoints: earnedPoints ?? this.earnedPoints,
    passed: passed.present ? passed.value : this.passed,
    currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
  );
  Quizze copyWithCompanion(QuizzesCompanion data) {
    return Quizze(
      id: data.id.present ? data.id.value : this.id,
      quizType: data.quizType.present ? data.quizType.value : this.quizType,
      examSheetIndex: data.examSheetIndex.present
          ? data.examSheetIndex.value
          : this.examSheetIndex,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      correctAnswers: data.correctAnswers.present
          ? data.correctAnswers.value
          : this.correctAnswers,
      totalPoints: data.totalPoints.present
          ? data.totalPoints.value
          : this.totalPoints,
      earnedPoints: data.earnedPoints.present
          ? data.earnedPoints.value
          : this.earnedPoints,
      passed: data.passed.present ? data.passed.value : this.passed,
      currentQuestionIndex: data.currentQuestionIndex.present
          ? data.currentQuestionIndex.value
          : this.currentQuestionIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quizze(')
          ..write('id: $id, ')
          ..write('quizType: $quizType, ')
          ..write('examSheetIndex: $examSheetIndex, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('earnedPoints: $earnedPoints, ')
          ..write('passed: $passed, ')
          ..write('currentQuestionIndex: $currentQuestionIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quizType,
    examSheetIndex,
    startedAt,
    endedAt,
    status,
    totalQuestions,
    correctAnswers,
    totalPoints,
    earnedPoints,
    passed,
    currentQuestionIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quizze &&
          other.id == this.id &&
          other.quizType == this.quizType &&
          other.examSheetIndex == this.examSheetIndex &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.totalQuestions == this.totalQuestions &&
          other.correctAnswers == this.correctAnswers &&
          other.totalPoints == this.totalPoints &&
          other.earnedPoints == this.earnedPoints &&
          other.passed == this.passed &&
          other.currentQuestionIndex == this.currentQuestionIndex);
}

class QuizzesCompanion extends UpdateCompanion<Quizze> {
  final Value<String> id;
  final Value<String> quizType;
  final Value<int?> examSheetIndex;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<int> totalQuestions;
  final Value<int> correctAnswers;
  final Value<int> totalPoints;
  final Value<int> earnedPoints;
  final Value<bool?> passed;
  final Value<int> currentQuestionIndex;
  final Value<int> rowid;
  const QuizzesCompanion({
    this.id = const Value.absent(),
    this.quizType = const Value.absent(),
    this.examSheetIndex = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.correctAnswers = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.earnedPoints = const Value.absent(),
    this.passed = const Value.absent(),
    this.currentQuestionIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizzesCompanion.insert({
    required String id,
    required String quizType,
    this.examSheetIndex = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    required int totalQuestions,
    this.correctAnswers = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.earnedPoints = const Value.absent(),
    this.passed = const Value.absent(),
    this.currentQuestionIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quizType = Value(quizType),
       startedAt = Value(startedAt),
       totalQuestions = Value(totalQuestions);
  static Insertable<Quizze> custom({
    Expression<String>? id,
    Expression<String>? quizType,
    Expression<int>? examSheetIndex,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<int>? totalQuestions,
    Expression<int>? correctAnswers,
    Expression<int>? totalPoints,
    Expression<int>? earnedPoints,
    Expression<bool>? passed,
    Expression<int>? currentQuestionIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quizType != null) 'quiz_type': quizType,
      if (examSheetIndex != null) 'exam_sheet_index': examSheetIndex,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (correctAnswers != null) 'correct_answers': correctAnswers,
      if (totalPoints != null) 'total_points': totalPoints,
      if (earnedPoints != null) 'earned_points': earnedPoints,
      if (passed != null) 'passed': passed,
      if (currentQuestionIndex != null)
        'current_question_index': currentQuestionIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizzesCompanion copyWith({
    Value<String>? id,
    Value<String>? quizType,
    Value<int?>? examSheetIndex,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<int>? totalQuestions,
    Value<int>? correctAnswers,
    Value<int>? totalPoints,
    Value<int>? earnedPoints,
    Value<bool?>? passed,
    Value<int>? currentQuestionIndex,
    Value<int>? rowid,
  }) {
    return QuizzesCompanion(
      id: id ?? this.id,
      quizType: quizType ?? this.quizType,
      examSheetIndex: examSheetIndex ?? this.examSheetIndex,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalPoints: totalPoints ?? this.totalPoints,
      earnedPoints: earnedPoints ?? this.earnedPoints,
      passed: passed ?? this.passed,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quizType.present) {
      map['quiz_type'] = Variable<String>(quizType.value);
    }
    if (examSheetIndex.present) {
      map['exam_sheet_index'] = Variable<int>(examSheetIndex.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (correctAnswers.present) {
      map['correct_answers'] = Variable<int>(correctAnswers.value);
    }
    if (totalPoints.present) {
      map['total_points'] = Variable<int>(totalPoints.value);
    }
    if (earnedPoints.present) {
      map['earned_points'] = Variable<int>(earnedPoints.value);
    }
    if (passed.present) {
      map['passed'] = Variable<bool>(passed.value);
    }
    if (currentQuestionIndex.present) {
      map['current_question_index'] = Variable<int>(currentQuestionIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesCompanion(')
          ..write('id: $id, ')
          ..write('quizType: $quizType, ')
          ..write('examSheetIndex: $examSheetIndex, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('correctAnswers: $correctAnswers, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('earnedPoints: $earnedPoints, ')
          ..write('passed: $passed, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizQuestionsTable extends QuizQuestions
    with TableInfo<$QuizQuestionsTable, QuizQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quizzes (id)',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<int> questionId = GeneratedColumn<int>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shuffledAnswerIdsJsonMeta =
      const VerificationMeta('shuffledAnswerIdsJson');
  @override
  late final GeneratedColumn<String> shuffledAnswerIdsJson =
      GeneratedColumn<String>(
        'shuffled_answer_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _selectedAnswerIdMeta = const VerificationMeta(
    'selectedAnswerId',
  );
  @override
  late final GeneratedColumn<String> selectedAnswerId = GeneratedColumn<String>(
    'selected_answer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wasCorrectMeta = const VerificationMeta(
    'wasCorrect',
  );
  @override
  late final GeneratedColumn<bool> wasCorrect = GeneratedColumn<bool>(
    'was_correct',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answeredAtMeta = const VerificationMeta(
    'answeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
    'answered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    quizId,
    questionId,
    orderIndex,
    shuffledAnswerIdsJson,
    selectedAnswerId,
    wasCorrect,
    points,
    answeredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('shuffled_answer_ids_json')) {
      context.handle(
        _shuffledAnswerIdsJsonMeta,
        shuffledAnswerIdsJson.isAcceptableOrUnknown(
          data['shuffled_answer_ids_json']!,
          _shuffledAnswerIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shuffledAnswerIdsJsonMeta);
    }
    if (data.containsKey('selected_answer_id')) {
      context.handle(
        _selectedAnswerIdMeta,
        selectedAnswerId.isAcceptableOrUnknown(
          data['selected_answer_id']!,
          _selectedAnswerIdMeta,
        ),
      );
    }
    if (data.containsKey('was_correct')) {
      context.handle(
        _wasCorrectMeta,
        wasCorrect.isAcceptableOrUnknown(data['was_correct']!, _wasCorrectMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
        _answeredAtMeta,
        answeredAt.isAcceptableOrUnknown(data['answered_at']!, _answeredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {quizId, questionId};
  @override
  QuizQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizQuestion(
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      shuffledAnswerIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shuffled_answer_ids_json'],
      )!,
      selectedAnswerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_answer_id'],
      ),
      wasCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_correct'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      answeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}answered_at'],
      ),
    );
  }

  @override
  $QuizQuestionsTable createAlias(String alias) {
    return $QuizQuestionsTable(attachedDatabase, alias);
  }
}

class QuizQuestion extends DataClass implements Insertable<QuizQuestion> {
  final String quizId;
  final int questionId;
  final int orderIndex;
  final String shuffledAnswerIdsJson;
  final String? selectedAnswerId;
  final bool? wasCorrect;
  final int points;
  final DateTime? answeredAt;
  const QuizQuestion({
    required this.quizId,
    required this.questionId,
    required this.orderIndex,
    required this.shuffledAnswerIdsJson,
    this.selectedAnswerId,
    this.wasCorrect,
    required this.points,
    this.answeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['quiz_id'] = Variable<String>(quizId);
    map['question_id'] = Variable<int>(questionId);
    map['order_index'] = Variable<int>(orderIndex);
    map['shuffled_answer_ids_json'] = Variable<String>(shuffledAnswerIdsJson);
    if (!nullToAbsent || selectedAnswerId != null) {
      map['selected_answer_id'] = Variable<String>(selectedAnswerId);
    }
    if (!nullToAbsent || wasCorrect != null) {
      map['was_correct'] = Variable<bool>(wasCorrect);
    }
    map['points'] = Variable<int>(points);
    if (!nullToAbsent || answeredAt != null) {
      map['answered_at'] = Variable<DateTime>(answeredAt);
    }
    return map;
  }

  QuizQuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuizQuestionsCompanion(
      quizId: Value(quizId),
      questionId: Value(questionId),
      orderIndex: Value(orderIndex),
      shuffledAnswerIdsJson: Value(shuffledAnswerIdsJson),
      selectedAnswerId: selectedAnswerId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedAnswerId),
      wasCorrect: wasCorrect == null && nullToAbsent
          ? const Value.absent()
          : Value(wasCorrect),
      points: Value(points),
      answeredAt: answeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(answeredAt),
    );
  }

  factory QuizQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizQuestion(
      quizId: serializer.fromJson<String>(json['quizId']),
      questionId: serializer.fromJson<int>(json['questionId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      shuffledAnswerIdsJson: serializer.fromJson<String>(
        json['shuffledAnswerIdsJson'],
      ),
      selectedAnswerId: serializer.fromJson<String?>(json['selectedAnswerId']),
      wasCorrect: serializer.fromJson<bool?>(json['wasCorrect']),
      points: serializer.fromJson<int>(json['points']),
      answeredAt: serializer.fromJson<DateTime?>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'quizId': serializer.toJson<String>(quizId),
      'questionId': serializer.toJson<int>(questionId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'shuffledAnswerIdsJson': serializer.toJson<String>(shuffledAnswerIdsJson),
      'selectedAnswerId': serializer.toJson<String?>(selectedAnswerId),
      'wasCorrect': serializer.toJson<bool?>(wasCorrect),
      'points': serializer.toJson<int>(points),
      'answeredAt': serializer.toJson<DateTime?>(answeredAt),
    };
  }

  QuizQuestion copyWith({
    String? quizId,
    int? questionId,
    int? orderIndex,
    String? shuffledAnswerIdsJson,
    Value<String?> selectedAnswerId = const Value.absent(),
    Value<bool?> wasCorrect = const Value.absent(),
    int? points,
    Value<DateTime?> answeredAt = const Value.absent(),
  }) => QuizQuestion(
    quizId: quizId ?? this.quizId,
    questionId: questionId ?? this.questionId,
    orderIndex: orderIndex ?? this.orderIndex,
    shuffledAnswerIdsJson: shuffledAnswerIdsJson ?? this.shuffledAnswerIdsJson,
    selectedAnswerId: selectedAnswerId.present
        ? selectedAnswerId.value
        : this.selectedAnswerId,
    wasCorrect: wasCorrect.present ? wasCorrect.value : this.wasCorrect,
    points: points ?? this.points,
    answeredAt: answeredAt.present ? answeredAt.value : this.answeredAt,
  );
  QuizQuestion copyWithCompanion(QuizQuestionsCompanion data) {
    return QuizQuestion(
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      shuffledAnswerIdsJson: data.shuffledAnswerIdsJson.present
          ? data.shuffledAnswerIdsJson.value
          : this.shuffledAnswerIdsJson,
      selectedAnswerId: data.selectedAnswerId.present
          ? data.selectedAnswerId.value
          : this.selectedAnswerId,
      wasCorrect: data.wasCorrect.present
          ? data.wasCorrect.value
          : this.wasCorrect,
      points: data.points.present ? data.points.value : this.points,
      answeredAt: data.answeredAt.present
          ? data.answeredAt.value
          : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestion(')
          ..write('quizId: $quizId, ')
          ..write('questionId: $questionId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('shuffledAnswerIdsJson: $shuffledAnswerIdsJson, ')
          ..write('selectedAnswerId: $selectedAnswerId, ')
          ..write('wasCorrect: $wasCorrect, ')
          ..write('points: $points, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    quizId,
    questionId,
    orderIndex,
    shuffledAnswerIdsJson,
    selectedAnswerId,
    wasCorrect,
    points,
    answeredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizQuestion &&
          other.quizId == this.quizId &&
          other.questionId == this.questionId &&
          other.orderIndex == this.orderIndex &&
          other.shuffledAnswerIdsJson == this.shuffledAnswerIdsJson &&
          other.selectedAnswerId == this.selectedAnswerId &&
          other.wasCorrect == this.wasCorrect &&
          other.points == this.points &&
          other.answeredAt == this.answeredAt);
}

class QuizQuestionsCompanion extends UpdateCompanion<QuizQuestion> {
  final Value<String> quizId;
  final Value<int> questionId;
  final Value<int> orderIndex;
  final Value<String> shuffledAnswerIdsJson;
  final Value<String?> selectedAnswerId;
  final Value<bool?> wasCorrect;
  final Value<int> points;
  final Value<DateTime?> answeredAt;
  final Value<int> rowid;
  const QuizQuestionsCompanion({
    this.quizId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.shuffledAnswerIdsJson = const Value.absent(),
    this.selectedAnswerId = const Value.absent(),
    this.wasCorrect = const Value.absent(),
    this.points = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizQuestionsCompanion.insert({
    required String quizId,
    required int questionId,
    required int orderIndex,
    required String shuffledAnswerIdsJson,
    this.selectedAnswerId = const Value.absent(),
    this.wasCorrect = const Value.absent(),
    required int points,
    this.answeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : quizId = Value(quizId),
       questionId = Value(questionId),
       orderIndex = Value(orderIndex),
       shuffledAnswerIdsJson = Value(shuffledAnswerIdsJson),
       points = Value(points);
  static Insertable<QuizQuestion> custom({
    Expression<String>? quizId,
    Expression<int>? questionId,
    Expression<int>? orderIndex,
    Expression<String>? shuffledAnswerIdsJson,
    Expression<String>? selectedAnswerId,
    Expression<bool>? wasCorrect,
    Expression<int>? points,
    Expression<DateTime>? answeredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (quizId != null) 'quiz_id': quizId,
      if (questionId != null) 'question_id': questionId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (shuffledAnswerIdsJson != null)
        'shuffled_answer_ids_json': shuffledAnswerIdsJson,
      if (selectedAnswerId != null) 'selected_answer_id': selectedAnswerId,
      if (wasCorrect != null) 'was_correct': wasCorrect,
      if (points != null) 'points': points,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizQuestionsCompanion copyWith({
    Value<String>? quizId,
    Value<int>? questionId,
    Value<int>? orderIndex,
    Value<String>? shuffledAnswerIdsJson,
    Value<String?>? selectedAnswerId,
    Value<bool?>? wasCorrect,
    Value<int>? points,
    Value<DateTime?>? answeredAt,
    Value<int>? rowid,
  }) {
    return QuizQuestionsCompanion(
      quizId: quizId ?? this.quizId,
      questionId: questionId ?? this.questionId,
      orderIndex: orderIndex ?? this.orderIndex,
      shuffledAnswerIdsJson:
          shuffledAnswerIdsJson ?? this.shuffledAnswerIdsJson,
      selectedAnswerId: selectedAnswerId ?? this.selectedAnswerId,
      wasCorrect: wasCorrect ?? this.wasCorrect,
      points: points ?? this.points,
      answeredAt: answeredAt ?? this.answeredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<int>(questionId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (shuffledAnswerIdsJson.present) {
      map['shuffled_answer_ids_json'] = Variable<String>(
        shuffledAnswerIdsJson.value,
      );
    }
    if (selectedAnswerId.present) {
      map['selected_answer_id'] = Variable<String>(selectedAnswerId.value);
    }
    if (wasCorrect.present) {
      map['was_correct'] = Variable<bool>(wasCorrect.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizQuestionsCompanion(')
          ..write('quizId: $quizId, ')
          ..write('questionId: $questionId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('shuffledAnswerIdsJson: $shuffledAnswerIdsJson, ')
          ..write('selectedAnswerId: $selectedAnswerId, ')
          ..write('wasCorrect: $wasCorrect, ')
          ..write('points: $points, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $QuestionRankingsTable questionRankings = $QuestionRankingsTable(
    this,
  );
  late final $QuestionSettingsTable questionSettings = $QuestionSettingsTable(
    this,
  );
  late final $QuizzesTable quizzes = $QuizzesTable(this);
  late final $QuizQuestionsTable quizQuestions = $QuizQuestionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    questions,
    questionRankings,
    questionSettings,
    quizzes,
    quizQuestions,
  ];
}

typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      required String categoryId,
      required String questionText,
      required int points,
      Value<bool> hasImages,
      Value<String> imageRefsJson,
      Value<String> answersJson,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      Value<String> categoryId,
      Value<String> questionText,
      Value<int> points,
      Value<bool> hasImages,
      Value<String> imageRefsJson,
      Value<String> answersJson,
    });

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestionRankingsTable, List<QuestionRanking>>
  _questionRankingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questionRankings,
    aliasName: $_aliasNameGenerator(
      db.questions.id,
      db.questionRankings.questionId,
    ),
  );

  $$QuestionRankingsTableProcessedTableManager get questionRankingsRefs {
    final manager = $$QuestionRankingsTableTableManager(
      $_db,
      $_db.questionRankings,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _questionRankingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizQuestionsTable, List<QuizQuestion>>
  _quizQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizQuestions,
    aliasName: $_aliasNameGenerator(
      db.questions.id,
      db.quizQuestions.questionId,
    ),
  );

  $$QuizQuestionsTableProcessedTableManager get quizQuestionsRefs {
    final manager = $$QuizQuestionsTableTableManager(
      $_db,
      $_db.quizQuestions,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasImages => $composableBuilder(
    column: $table.hasImages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageRefsJson => $composableBuilder(
    column: $table.imageRefsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> questionRankingsRefs(
    Expression<bool> Function($$QuestionRankingsTableFilterComposer f) f,
  ) {
    final $$QuestionRankingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questionRankings,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionRankingsTableFilterComposer(
            $db: $db,
            $table: $db.questionRankings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizQuestionsRefs(
    Expression<bool> Function($$QuizQuestionsTableFilterComposer f) f,
  ) {
    final $$QuizQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasImages => $composableBuilder(
    column: $table.hasImages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageRefsJson => $composableBuilder(
    column: $table.imageRefsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<bool> get hasImages =>
      $composableBuilder(column: $table.hasImages, builder: (column) => column);

  GeneratedColumn<String> get imageRefsJson => $composableBuilder(
    column: $table.imageRefsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  Expression<T> questionRankingsRefs<T extends Object>(
    Expression<T> Function($$QuestionRankingsTableAnnotationComposer a) f,
  ) {
    final $$QuestionRankingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questionRankings,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionRankingsTableAnnotationComposer(
            $db: $db,
            $table: $db.questionRankings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizQuestionsRefs<T extends Object>(
    Expression<T> Function($$QuizQuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuizQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({
            bool questionRankingsRefs,
            bool quizQuestionsRefs,
          })
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<bool> hasImages = const Value.absent(),
                Value<String> imageRefsJson = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                categoryId: categoryId,
                questionText: questionText,
                points: points,
                hasImages: hasImages,
                imageRefsJson: imageRefsJson,
                answersJson: answersJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String categoryId,
                required String questionText,
                required int points,
                Value<bool> hasImages = const Value.absent(),
                Value<String> imageRefsJson = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                categoryId: categoryId,
                questionText: questionText,
                points: points,
                hasImages: hasImages,
                imageRefsJson: imageRefsJson,
                answersJson: answersJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({questionRankingsRefs = false, quizQuestionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (questionRankingsRefs) db.questionRankings,
                    if (quizQuestionsRefs) db.quizQuestions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (questionRankingsRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          QuestionRanking
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._questionRankingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).questionRankingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizQuestionsRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          QuizQuestion
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._quizQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).quizQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({
        bool questionRankingsRefs,
        bool quizQuestionsRefs,
      })
    >;
typedef $$QuestionRankingsTableCreateCompanionBuilder =
    QuestionRankingsCompanion Function({
      Value<int> questionId,
      Value<int> timesCorrect,
    });
typedef $$QuestionRankingsTableUpdateCompanionBuilder =
    QuestionRankingsCompanion Function({
      Value<int> questionId,
      Value<int> timesCorrect,
    });

final class $$QuestionRankingsTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuestionRankingsTable, QuestionRanking> {
  $$QuestionRankingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.questionRankings.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<int>('question_id')!;

    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuestionRankingsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionRankingsTable> {
  $$QuestionRankingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get timesCorrect => $composableBuilder(
    column: $table.timesCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionRankingsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionRankingsTable> {
  $$QuestionRankingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get timesCorrect => $composableBuilder(
    column: $table.timesCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionRankingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionRankingsTable> {
  $$QuestionRankingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get timesCorrect => $composableBuilder(
    column: $table.timesCorrect,
    builder: (column) => column,
  );

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionRankingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionRankingsTable,
          QuestionRanking,
          $$QuestionRankingsTableFilterComposer,
          $$QuestionRankingsTableOrderingComposer,
          $$QuestionRankingsTableAnnotationComposer,
          $$QuestionRankingsTableCreateCompanionBuilder,
          $$QuestionRankingsTableUpdateCompanionBuilder,
          (QuestionRanking, $$QuestionRankingsTableReferences),
          QuestionRanking,
          PrefetchHooks Function({bool questionId})
        > {
  $$QuestionRankingsTableTableManager(
    _$AppDatabase db,
    $QuestionRankingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionRankingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionRankingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionRankingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> questionId = const Value.absent(),
                Value<int> timesCorrect = const Value.absent(),
              }) => QuestionRankingsCompanion(
                questionId: questionId,
                timesCorrect: timesCorrect,
              ),
          createCompanionCallback:
              ({
                Value<int> questionId = const Value.absent(),
                Value<int> timesCorrect = const Value.absent(),
              }) => QuestionRankingsCompanion.insert(
                questionId: questionId,
                timesCorrect: timesCorrect,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionRankingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable:
                                    $$QuestionRankingsTableReferences
                                        ._questionIdTable(db),
                                referencedColumn:
                                    $$QuestionRankingsTableReferences
                                        ._questionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuestionRankingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionRankingsTable,
      QuestionRanking,
      $$QuestionRankingsTableFilterComposer,
      $$QuestionRankingsTableOrderingComposer,
      $$QuestionRankingsTableAnnotationComposer,
      $$QuestionRankingsTableCreateCompanionBuilder,
      $$QuestionRankingsTableUpdateCompanionBuilder,
      (QuestionRanking, $$QuestionRankingsTableReferences),
      QuestionRanking,
      PrefetchHooks Function({bool questionId})
    >;
typedef $$QuestionSettingsTableCreateCompanionBuilder =
    QuestionSettingsCompanion Function({
      required String key,
      required int value,
      Value<int> rowid,
    });
typedef $$QuestionSettingsTableUpdateCompanionBuilder =
    QuestionSettingsCompanion Function({
      Value<String> key,
      Value<int> value,
      Value<int> rowid,
    });

class $$QuestionSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionSettingsTable> {
  $$QuestionSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionSettingsTable> {
  $$QuestionSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionSettingsTable> {
  $$QuestionSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$QuestionSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionSettingsTable,
          QuestionSetting,
          $$QuestionSettingsTableFilterComposer,
          $$QuestionSettingsTableOrderingComposer,
          $$QuestionSettingsTableAnnotationComposer,
          $$QuestionSettingsTableCreateCompanionBuilder,
          $$QuestionSettingsTableUpdateCompanionBuilder,
          (
            QuestionSetting,
            BaseReferences<
              _$AppDatabase,
              $QuestionSettingsTable,
              QuestionSetting
            >,
          ),
          QuestionSetting,
          PrefetchHooks Function()
        > {
  $$QuestionSettingsTableTableManager(
    _$AppDatabase db,
    $QuestionSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionSettingsCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required int value,
                Value<int> rowid = const Value.absent(),
              }) => QuestionSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionSettingsTable,
      QuestionSetting,
      $$QuestionSettingsTableFilterComposer,
      $$QuestionSettingsTableOrderingComposer,
      $$QuestionSettingsTableAnnotationComposer,
      $$QuestionSettingsTableCreateCompanionBuilder,
      $$QuestionSettingsTableUpdateCompanionBuilder,
      (
        QuestionSetting,
        BaseReferences<_$AppDatabase, $QuestionSettingsTable, QuestionSetting>,
      ),
      QuestionSetting,
      PrefetchHooks Function()
    >;
typedef $$QuizzesTableCreateCompanionBuilder =
    QuizzesCompanion Function({
      required String id,
      required String quizType,
      Value<int?> examSheetIndex,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      required int totalQuestions,
      Value<int> correctAnswers,
      Value<int> totalPoints,
      Value<int> earnedPoints,
      Value<bool?> passed,
      Value<int> currentQuestionIndex,
      Value<int> rowid,
    });
typedef $$QuizzesTableUpdateCompanionBuilder =
    QuizzesCompanion Function({
      Value<String> id,
      Value<String> quizType,
      Value<int?> examSheetIndex,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<int> totalQuestions,
      Value<int> correctAnswers,
      Value<int> totalPoints,
      Value<int> earnedPoints,
      Value<bool?> passed,
      Value<int> currentQuestionIndex,
      Value<int> rowid,
    });

final class $$QuizzesTableReferences
    extends BaseReferences<_$AppDatabase, $QuizzesTable, Quizze> {
  $$QuizzesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuizQuestionsTable, List<QuizQuestion>>
  _quizQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizQuestions,
    aliasName: $_aliasNameGenerator(db.quizzes.id, db.quizQuestions.quizId),
  );

  $$QuizQuestionsTableProcessedTableManager get quizQuestionsRefs {
    final manager = $$QuizQuestionsTableTableManager(
      $_db,
      $_db.quizQuestions,
    ).filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizzesTableFilterComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quizType => $composableBuilder(
    column: $table.quizType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get examSheetIndex => $composableBuilder(
    column: $table.examSheetIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get earnedPoints => $composableBuilder(
    column: $table.earnedPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> quizQuestionsRefs(
    Expression<bool> Function($$QuizQuestionsTableFilterComposer f) f,
  ) {
    final $$QuizQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizzesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quizType => $composableBuilder(
    column: $table.quizType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get examSheetIndex => $composableBuilder(
    column: $table.examSheetIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get earnedPoints => $composableBuilder(
    column: $table.earnedPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizzesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quizType =>
      $composableBuilder(column: $table.quizType, builder: (column) => column);

  GeneratedColumn<int> get examSheetIndex => $composableBuilder(
    column: $table.examSheetIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctAnswers => $composableBuilder(
    column: $table.correctAnswers,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPoints => $composableBuilder(
    column: $table.totalPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get earnedPoints => $composableBuilder(
    column: $table.earnedPoints,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  GeneratedColumn<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => column,
  );

  Expression<T> quizQuestionsRefs<T extends Object>(
    Expression<T> Function($$QuizQuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuizQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizQuestions,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizzesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizzesTable,
          Quizze,
          $$QuizzesTableFilterComposer,
          $$QuizzesTableOrderingComposer,
          $$QuizzesTableAnnotationComposer,
          $$QuizzesTableCreateCompanionBuilder,
          $$QuizzesTableUpdateCompanionBuilder,
          (Quizze, $$QuizzesTableReferences),
          Quizze,
          PrefetchHooks Function({bool quizQuestionsRefs})
        > {
  $$QuizzesTableTableManager(_$AppDatabase db, $QuizzesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizzesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizzesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizzesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quizType = const Value.absent(),
                Value<int?> examSheetIndex = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> correctAnswers = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> earnedPoints = const Value.absent(),
                Value<bool?> passed = const Value.absent(),
                Value<int> currentQuestionIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizzesCompanion(
                id: id,
                quizType: quizType,
                examSheetIndex: examSheetIndex,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                totalPoints: totalPoints,
                earnedPoints: earnedPoints,
                passed: passed,
                currentQuestionIndex: currentQuestionIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quizType,
                Value<int?> examSheetIndex = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int totalQuestions,
                Value<int> correctAnswers = const Value.absent(),
                Value<int> totalPoints = const Value.absent(),
                Value<int> earnedPoints = const Value.absent(),
                Value<bool?> passed = const Value.absent(),
                Value<int> currentQuestionIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizzesCompanion.insert(
                id: id,
                quizType: quizType,
                examSheetIndex: examSheetIndex,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                totalQuestions: totalQuestions,
                correctAnswers: correctAnswers,
                totalPoints: totalPoints,
                earnedPoints: earnedPoints,
                passed: passed,
                currentQuestionIndex: currentQuestionIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizzesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizQuestionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (quizQuestionsRefs) db.quizQuestions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quizQuestionsRefs)
                    await $_getPrefetchedData<
                      Quizze,
                      $QuizzesTable,
                      QuizQuestion
                    >(
                      currentTable: table,
                      referencedTable: $$QuizzesTableReferences
                          ._quizQuestionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$QuizzesTableReferences(
                        db,
                        table,
                        p0,
                      ).quizQuestionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.quizId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuizzesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizzesTable,
      Quizze,
      $$QuizzesTableFilterComposer,
      $$QuizzesTableOrderingComposer,
      $$QuizzesTableAnnotationComposer,
      $$QuizzesTableCreateCompanionBuilder,
      $$QuizzesTableUpdateCompanionBuilder,
      (Quizze, $$QuizzesTableReferences),
      Quizze,
      PrefetchHooks Function({bool quizQuestionsRefs})
    >;
typedef $$QuizQuestionsTableCreateCompanionBuilder =
    QuizQuestionsCompanion Function({
      required String quizId,
      required int questionId,
      required int orderIndex,
      required String shuffledAnswerIdsJson,
      Value<String?> selectedAnswerId,
      Value<bool?> wasCorrect,
      required int points,
      Value<DateTime?> answeredAt,
      Value<int> rowid,
    });
typedef $$QuizQuestionsTableUpdateCompanionBuilder =
    QuizQuestionsCompanion Function({
      Value<String> quizId,
      Value<int> questionId,
      Value<int> orderIndex,
      Value<String> shuffledAnswerIdsJson,
      Value<String?> selectedAnswerId,
      Value<bool?> wasCorrect,
      Value<int> points,
      Value<DateTime?> answeredAt,
      Value<int> rowid,
    });

final class $$QuizQuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizQuestionsTable, QuizQuestion> {
  $$QuizQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuizzesTable _quizIdTable(_$AppDatabase db) => db.quizzes.createAlias(
    $_aliasNameGenerator(db.quizQuestions.quizId, db.quizzes.id),
  );

  $$QuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.quizQuestions.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<int>('question_id')!;

    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shuffledAnswerIdsJson => $composableBuilder(
    column: $table.shuffledAnswerIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedAnswerId => $composableBuilder(
    column: $table.selectedAnswerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasCorrect => $composableBuilder(
    column: $table.wasCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizzesTableFilterComposer get quizId {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shuffledAnswerIdsJson => $composableBuilder(
    column: $table.shuffledAnswerIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedAnswerId => $composableBuilder(
    column: $table.selectedAnswerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasCorrect => $composableBuilder(
    column: $table.wasCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizzesTableOrderingComposer get quizId {
    final $$QuizzesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableOrderingComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizQuestionsTable> {
  $$QuizQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shuffledAnswerIdsJson => $composableBuilder(
    column: $table.shuffledAnswerIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedAnswerId => $composableBuilder(
    column: $table.selectedAnswerId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasCorrect => $composableBuilder(
    column: $table.wasCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => column,
  );

  $$QuizzesTableAnnotationComposer get quizId {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizQuestionsTable,
          QuizQuestion,
          $$QuizQuestionsTableFilterComposer,
          $$QuizQuestionsTableOrderingComposer,
          $$QuizQuestionsTableAnnotationComposer,
          $$QuizQuestionsTableCreateCompanionBuilder,
          $$QuizQuestionsTableUpdateCompanionBuilder,
          (QuizQuestion, $$QuizQuestionsTableReferences),
          QuizQuestion,
          PrefetchHooks Function({bool quizId, bool questionId})
        > {
  $$QuizQuestionsTableTableManager(_$AppDatabase db, $QuizQuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> quizId = const Value.absent(),
                Value<int> questionId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> shuffledAnswerIdsJson = const Value.absent(),
                Value<String?> selectedAnswerId = const Value.absent(),
                Value<bool?> wasCorrect = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<DateTime?> answeredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion(
                quizId: quizId,
                questionId: questionId,
                orderIndex: orderIndex,
                shuffledAnswerIdsJson: shuffledAnswerIdsJson,
                selectedAnswerId: selectedAnswerId,
                wasCorrect: wasCorrect,
                points: points,
                answeredAt: answeredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String quizId,
                required int questionId,
                required int orderIndex,
                required String shuffledAnswerIdsJson,
                Value<String?> selectedAnswerId = const Value.absent(),
                Value<bool?> wasCorrect = const Value.absent(),
                required int points,
                Value<DateTime?> answeredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizQuestionsCompanion.insert(
                quizId: quizId,
                questionId: questionId,
                orderIndex: orderIndex,
                shuffledAnswerIdsJson: shuffledAnswerIdsJson,
                selectedAnswerId: selectedAnswerId,
                wasCorrect: wasCorrect,
                points: points,
                answeredAt: answeredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizId = false, questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quizId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quizId,
                                referencedTable: $$QuizQuestionsTableReferences
                                    ._quizIdTable(db),
                                referencedColumn: $$QuizQuestionsTableReferences
                                    ._quizIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$QuizQuestionsTableReferences
                                    ._questionIdTable(db),
                                referencedColumn: $$QuizQuestionsTableReferences
                                    ._questionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizQuestionsTable,
      QuizQuestion,
      $$QuizQuestionsTableFilterComposer,
      $$QuizQuestionsTableOrderingComposer,
      $$QuizQuestionsTableAnnotationComposer,
      $$QuizQuestionsTableCreateCompanionBuilder,
      $$QuizQuestionsTableUpdateCompanionBuilder,
      (QuizQuestion, $$QuizQuestionsTableReferences),
      QuizQuestion,
      PrefetchHooks Function({bool quizId, bool questionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$QuestionRankingsTableTableManager get questionRankings =>
      $$QuestionRankingsTableTableManager(_db, _db.questionRankings);
  $$QuestionSettingsTableTableManager get questionSettings =>
      $$QuestionSettingsTableTableManager(_db, _db.questionSettings);
  $$QuizzesTableTableManager get quizzes =>
      $$QuizzesTableTableManager(_db, _db.quizzes);
  $$QuizQuestionsTableTableManager get quizQuestions =>
      $$QuizQuestionsTableTableManager(_db, _db.quizQuestions);
}
