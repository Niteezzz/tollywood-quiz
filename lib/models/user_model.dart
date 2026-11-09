class UserModel {
  final String name;
  final int totalScore;
  final int quizzesPlayed;
  final int bestScore;
  final int streakRecord;

  const UserModel({
    required this.name,
    this.totalScore = 0,
    this.quizzesPlayed = 0,
    this.bestScore = 0,
    this.streakRecord = 0,
  });

  UserModel copyWith({
    String? name,
    int? totalScore,
    int? quizzesPlayed,
    int? bestScore,
    int? streakRecord,
  }) {
    return UserModel(
      name: name ?? this.name,
      totalScore: totalScore ?? this.totalScore,
      quizzesPlayed: quizzesPlayed ?? this.quizzesPlayed,
      bestScore: bestScore ?? this.bestScore,
      streakRecord: streakRecord ?? this.streakRecord,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'totalScore': totalScore,
      'quizzesPlayed': quizzesPlayed,
      'bestScore': bestScore,
      'streakRecord': streakRecord,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String? ?? 'Player',
      totalScore: map['totalScore'] as int? ?? 0,
      quizzesPlayed: map['quizzesPlayed'] as int? ?? 0,
      bestScore: map['bestScore'] as int? ?? 0,
      streakRecord: map['streakRecord'] as int? ?? 0,
    );
  }

  factory UserModel.empty() {
    return const UserModel(name: 'Player');
  }

  @override
  String toString() =>
      'UserModel{name: $name, totalScore: $totalScore, quizzesPlayed: $quizzesPlayed, bestScore: $bestScore, streakRecord: $streakRecord}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          totalScore == other.totalScore;

  @override
  int get hashCode => name.hashCode ^ totalScore.hashCode;
}

class LeaderboardEntry {
  final String playerName;
  final int score;
  final DateTime dateTime;

  const LeaderboardEntry({
    required this.playerName,
    required this.score,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'score': score,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      playerName: map['playerName'] as String? ?? 'Player',
      score: map['score'] as int? ?? 0,
      dateTime: DateTime.tryParse(map['dateTime'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
