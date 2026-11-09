import 'package:flutter/foundation.dart';

enum QuizCategory {
  actors,
  movies,
  directors,
  songs,
  awards,
  dialogues,
  all,
}

extension QuizCategoryExtension on QuizCategory {
  String get displayName {
    switch (this) {
      case QuizCategory.actors:
        return 'Actors';
      case QuizCategory.movies:
        return 'Movies';
      case QuizCategory.directors:
        return 'Directors';
      case QuizCategory.songs:
        return 'Songs';
      case QuizCategory.awards:
        return 'Awards';
      case QuizCategory.dialogues:
        return 'Dialogues';
      case QuizCategory.all:
        return 'All Categories';
    }
  }

  String get emoji {
    switch (this) {
      case QuizCategory.actors:
        return '🎭';
      case QuizCategory.movies:
        return '🎬';
      case QuizCategory.directors:
        return '🎥';
      case QuizCategory.songs:
        return '🎵';
      case QuizCategory.awards:
        return '🏆';
      case QuizCategory.dialogues:
        return '💬';
      case QuizCategory.all:
        return '🌟';
    }
  }
}

enum Difficulty {
  easy,
  medium,
  hard,
}

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  int get timeSeconds {
    switch (this) {
      case Difficulty.easy:
        return 30;
      case Difficulty.medium:
        return 20;
      case Difficulty.hard:
        return 15;
    }
  }
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final QuizCategory category;
  final Difficulty difficulty;
  final String? hint;

  const Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
    required this.difficulty,
    this.hint,
  });

  String get correctAnswer => options[correctAnswerIndex];

  Question copyWith({
    String? id,
    String? questionText,
    List<String>? options,
    int? correctAnswerIndex,
    QuizCategory? category,
    Difficulty? difficulty,
    String? hint,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      hint: hint ?? this.hint,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Question{id: $id, questionText: $questionText}';
}
