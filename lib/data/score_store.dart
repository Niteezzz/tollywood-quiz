import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quiz_question.dart';

/// Stores player details and quiz scores in this browser's local storage.
/// On Flutter Web, shared_preferences uses browser storage, so scores remain
/// available after refreshing or reopening the app in the same browser.
/// This is a local leaderboard, not a shared leaderboard across users/devices.
class ScoreStore {
  ScoreStore._();

  static const String _scoresKey = 'tollywood_quiz_scores_v1';
  static const String _playerNameKey = 'tollywood_quiz_player_name_v1';

  static String _playerName = 'Cinema Fan';
  static String get playerName => _playerName;

  // Keep the existing assignment style used by the home screen, while also
  // saving the new name automatically.
  static set playerName(String value) {
    final cleaned = value.trim();
    _playerName = cleaned.isEmpty ? 'Cinema Fan' : cleaned;
    unawaited(_savePlayerName(_playerName));
  }

  static final List<QuizScore> scores = [];

  /// Load previously saved data once, before the app starts.
  static Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    _playerName = preferences.getString(_playerNameKey) ?? 'Cinema Fan';

    final savedScores = preferences.getString(_scoresKey);
    if (savedScores == null || savedScores.isEmpty) return;

    try {
      final decoded = jsonDecode(savedScores);
      if (decoded is! List) return;

      scores
        ..clear()
        ..addAll(decoded.whereType<Map>().map((raw) {
          final item = Map<String, dynamic>.from(raw);
          return QuizScore(
            playerName: item['playerName'] as String? ?? 'Cinema Fan',
            category: item['category'] as String? ?? 'Movies',
            difficulty: item['difficulty'] as String? ?? 'Easy',
            score: (item['score'] as num?)?.toInt() ?? 0,
            total: (item['total'] as num?)?.toInt() ?? 0,
            completedAt: DateTime.tryParse(
                  item['completedAt'] as String? ?? '',
                ) ??
                DateTime.now(),
          );
        }));
      _sortScores();
    } catch (_) {
      // If old/corrupt browser data cannot be read, start with an empty list.
      scores.clear();
    }
  }

  static void add({
    required String category,
    required String difficulty,
    required int score,
    required int total,
  }) {
    scores.add(
      QuizScore(
        playerName: _playerName,
        category: category,
        difficulty: difficulty,
        score: score,
        total: total,
        completedAt: DateTime.now(),
      ),
    );
    _sortScores();
    unawaited(_saveScores());
  }

  static void _sortScores() {
    scores.sort((a, b) {
      final percentageOrder = b.percentage.compareTo(a.percentage);
      if (percentageOrder != 0) return percentageOrder;
      return b.completedAt.compareTo(a.completedAt);
    });
  }

  static Future<void> _savePlayerName(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_playerNameKey, value);
  }

  static Future<void> _saveScores() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = scores
        .map((entry) => <String, dynamic>{
              'playerName': entry.playerName,
              'category': entry.category,
              'difficulty': entry.difficulty,
              'score': entry.score,
              'total': entry.total,
              'completedAt': entry.completedAt.toIso8601String(),
            })
        .toList();
    await preferences.setString(_scoresKey, jsonEncode(encoded));
  }
}
