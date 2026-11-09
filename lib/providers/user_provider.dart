import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel.empty();
  bool _isLoaded = false;
  List<LeaderboardEntry> _leaderboard = [];

  static const String _userKey = 'user_data';
  static const String _leaderboardKey = 'leaderboard_data';
  static const String _themeKey = 'theme_dark';
  static const String _soundKey = 'sound_enabled';

  bool _isDarkTheme = true;
  bool _soundEnabled = true;

  UserModel get user => _user;
  bool get isLoaded => _isLoaded;
  bool get hasName => _user.name.isNotEmpty && _user.name != 'Player';
  List<LeaderboardEntry> get leaderboard => List.unmodifiable(_leaderboard);
  bool get isDarkTheme => _isDarkTheme;
  bool get soundEnabled => _soundEnabled;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        _user = UserModel.fromMap(map);
      } catch (_) {
        _user = UserModel.empty();
      }
    }

    final leaderboardJson = prefs.getStringList(_leaderboardKey);
    if (leaderboardJson != null) {
      _leaderboard = leaderboardJson
          .map((s) {
            try {
              return LeaderboardEntry.fromMap(jsonDecode(s) as Map<String, dynamic>);
            } catch (_) {
              return null;
            }
          })
          .whereType<LeaderboardEntry>()
          .toList();
      _leaderboard.sort((a, b) => b.score.compareTo(a.score));
    }

    _isDarkTheme = prefs.getBool(_themeKey) ?? true;
    _soundEnabled = prefs.getBool(_soundKey) ?? true;

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(_user.toMap()));
  }

  Future<void> setUserName(String name) async {
    _user = _user.copyWith(name: name.trim());
    await saveUser();
    notifyListeners();
  }

  Future<void> updateScore(int quizScore) async {
    final newTotal = _user.totalScore + quizScore;
    final newBest = quizScore > _user.bestScore ? quizScore : _user.bestScore;
    final newPlayed = _user.quizzesPlayed + 1;

    _user = _user.copyWith(
      totalScore: newTotal,
      bestScore: newBest,
      quizzesPlayed: newPlayed,
    );

    await _addLeaderboardEntry(quizScore);
    await saveUser();
    notifyListeners();
  }

  Future<void> updateStreakRecord(int streak) async {
    if (streak > _user.streakRecord) {
      _user = _user.copyWith(streakRecord: streak);
      await saveUser();
      notifyListeners();
    }
  }

  Future<void> _addLeaderboardEntry(int score) async {
    final entry = LeaderboardEntry(
      playerName: _user.name,
      score: score,
      dateTime: DateTime.now(),
    );

    _leaderboard.add(entry);
    _leaderboard.sort((a, b) => b.score.compareTo(a.score));

    if (_leaderboard.length > 10) {
      _leaderboard = _leaderboard.take(10).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonList = _leaderboard
        .map((e) => jsonEncode(e.toMap()))
        .toList();
    await prefs.setStringList(_leaderboardKey, jsonList);
  }

  Future<void> setDarkTheme(bool value) async {
    _isDarkTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);
    notifyListeners();
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _user.name;
    await prefs.remove(_userKey);
    await prefs.remove(_leaderboardKey);
    _user = UserModel(name: name);
    _leaderboard = [];
    notifyListeners();
  }
}
