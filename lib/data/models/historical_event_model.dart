class QuizQuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  const QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctAnswerIndex: json['correctAnswerIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class HistoricalEventModel {
  final String id;
  final String eraId;
  final int year;
  final String title;
  final String summary;
  final String storyContent;
  final int estimatedMinutes;
  final int xpReward;
  final int coinReward;
  final String? rewardCardName;
  final bool isCompleted;
  final bool isCurrentActive;
  final List<QuizQuestionModel> questions;

  const HistoricalEventModel({
    required this.id,
    required this.eraId,
    required this.year,
    required this.title,
    required this.summary,
    required this.storyContent,
    this.estimatedMinutes = 5,
    this.xpReward = 100,
    this.coinReward = 30,
    this.rewardCardName,
    this.isCompleted = false,
    this.isCurrentActive = false,
    this.questions = const [],
  });

  HistoricalEventModel copyWith({
    String? id,
    String? eraId,
    int? year,
    String? title,
    String? summary,
    String? storyContent,
    int? estimatedMinutes,
    int? xpReward,
    int? coinReward,
    String? rewardCardName,
    bool? isCompleted,
    bool? isCurrentActive,
    List<QuizQuestionModel>? questions,
  }) {
    return HistoricalEventModel(
      id: id ?? this.id,
      eraId: eraId ?? this.eraId,
      year: year ?? this.year,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      storyContent: storyContent ?? this.storyContent,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      rewardCardName: rewardCardName ?? this.rewardCardName,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrentActive: isCurrentActive ?? this.isCurrentActive,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eraId': eraId,
      'year': year,
      'title': title,
      'summary': summary,
      'storyContent': storyContent,
      'estimatedMinutes': estimatedMinutes,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'rewardCardName': rewardCardName,
      'isCompleted': isCompleted,
      'isCurrentActive': isCurrentActive,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  factory HistoricalEventModel.fromJson(Map<String, dynamic> json) {
    return HistoricalEventModel(
      id: json['id'] as String? ?? '',
      eraId: json['eraId'] as String? ?? '',
      year: json['year'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      storyContent: json['storyContent'] as String? ?? '',
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
      xpReward: json['xpReward'] as int? ?? 100,
      coinReward: json['coinReward'] as int? ?? 30,
      rewardCardName: json['rewardCardName'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isCurrentActive: json['isCurrentActive'] as bool? ?? false,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
