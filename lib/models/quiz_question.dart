class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

class QuizScore {
  const QuizScore({
    required this.playerName,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.total,
    required this.completedAt,
  });

  final String playerName;
  final String category;
  final String difficulty;
  final int score;
  final int total;
  final DateTime completedAt;

  double get percentage => total == 0 ? 0 : score / total * 100;
}
