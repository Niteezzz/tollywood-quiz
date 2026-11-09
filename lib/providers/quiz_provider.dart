import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../data/questions_data.dart';

enum QuizState { idle, loading, active, answered, finished }

class QuizProvider extends ChangeNotifier {
  List<Question> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1;
  bool _isAnswerSelected = false;
  int _timeLeft = 30;
  int _streak = 0;
  int _maxStreak = 0;
  double _multiplier = 1.0;
  bool _fiftyFiftyUsed = false;
  bool _skipUsed = false;
  QuizState _quizState = QuizState.idle;
  Set<int> _eliminatedOptions = {};
  int _correctCount = 0;
  int _wrongCount = 0;
  int _skippedCount = 0;
  QuizCategory _selectedCategory = QuizCategory.all;
  Difficulty _selectedDifficulty = Difficulty.easy;

  Timer? _timer;

  // Getters
  List<Question> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isAnswerSelected => _isAnswerSelected;
  int get timeLeft => _timeLeft;
  int get streak => _streak;
  int get maxStreak => _maxStreak;
  double get multiplier => _multiplier;
  bool get fiftyFiftyUsed => _fiftyFiftyUsed;
  bool get skipUsed => _skipUsed;
  QuizState get quizState => _quizState;
  Set<int> get eliminatedOptions => _eliminatedOptions;
  int get correctCount => _correctCount;
  int get wrongCount => _wrongCount;
  int get skippedCount => _skippedCount;
  QuizCategory get selectedCategory => _selectedCategory;
  Difficulty get selectedDifficulty => _selectedDifficulty;

  Question? get currentQuestion =>
      _currentQuestions.isNotEmpty && _currentQuestionIndex < _currentQuestions.length
          ? _currentQuestions[_currentQuestionIndex]
          : null;

  int get totalQuestions => _currentQuestions.length;
  bool get isLastQuestion => _currentQuestionIndex >= _currentQuestions.length - 1;

  double get progressFraction =>
      _currentQuestions.isEmpty ? 0 : (_currentQuestionIndex + 1) / _currentQuestions.length;

  int get maxTime => _selectedDifficulty.timeSeconds;

  void startQuiz(QuizCategory category, Difficulty difficulty) {
    _selectedCategory = category;
    _selectedDifficulty = difficulty;
    _currentQuestions = getRandomQuestions(category, difficulty, count: 10);
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswerIndex = -1;
    _isAnswerSelected = false;
    _streak = 0;
    _maxStreak = 0;
    _multiplier = 1.0;
    _fiftyFiftyUsed = false;
    _skipUsed = false;
    _quizState = QuizState.active;
    _eliminatedOptions = {};
    _correctCount = 0;
    _wrongCount = 0;
    _skippedCount = 0;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _selectedDifficulty.timeSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _timeExpired();
      }
    });
  }

  void _timeExpired() {
    if (_isAnswerSelected) return;
    _isAnswerSelected = true;
    _selectedAnswerIndex = -1;
    _streak = 0;
    _multiplier = 1.0;
    _wrongCount++;
    _quizState = QuizState.answered;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_isAnswerSelected || _quizState != QuizState.active) return;
    _timer?.cancel();

    _selectedAnswerIndex = index;
    _isAnswerSelected = true;
    _quizState = QuizState.answered;

    final question = currentQuestion;
    if (question != null && index == question.correctAnswerIndex) {
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;
      _multiplier = _calculateMultiplier();
      final baseScore = _calculateBaseScore();
      _score += (baseScore * _multiplier).round();
      _correctCount++;
    } else {
      _streak = 0;
      _multiplier = 1.0;
      _wrongCount++;
    }

    notifyListeners();
  }

  double _calculateMultiplier() {
    final timeRatio = _timeLeft / _selectedDifficulty.timeSeconds;
    if (timeRatio > 0.6) return 2.0;
    if (timeRatio > 0.3) return 1.5;
    return 1.0;
  }

  int _calculateBaseScore() {
    switch (_selectedDifficulty) {
      case Difficulty.easy:
        return 10;
      case Difficulty.medium:
        return 20;
      case Difficulty.hard:
        return 30;
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex >= _currentQuestions.length - 1) {
      _quizState = QuizState.finished;
      notifyListeners();
      return;
    }

    _currentQuestionIndex++;
    _selectedAnswerIndex = -1;
    _isAnswerSelected = false;
    _eliminatedOptions = {};
    _quizState = QuizState.active;
    _startTimer();
    notifyListeners();
  }

  void useFiftyFifty() {
    if (_fiftyFiftyUsed || _isAnswerSelected) return;
    _fiftyFiftyUsed = true;

    final question = currentQuestion;
    if (question == null) return;

    final wrongIndices = <int>[];
    for (int i = 0; i < question.options.length; i++) {
      if (i != question.correctAnswerIndex) wrongIndices.add(i);
    }
    wrongIndices.shuffle();

    _eliminatedOptions = {wrongIndices[0], wrongIndices[1]};
    notifyListeners();
  }

  void useSkip() {
    if (_skipUsed || _isAnswerSelected) return;
    _skipUsed = true;
    _timer?.cancel();
    _isAnswerSelected = true;
    _selectedAnswerIndex = -2; // skip marker
    _skippedCount++;
    _streak = 0;
    _multiplier = 1.0;
    _quizState = QuizState.answered;
    notifyListeners();
  }

  void resetQuiz() {
    _timer?.cancel();
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswerIndex = -1;
    _isAnswerSelected = false;
    _timeLeft = 30;
    _streak = 0;
    _maxStreak = 0;
    _multiplier = 1.0;
    _fiftyFiftyUsed = false;
    _skipUsed = false;
    _quizState = QuizState.idle;
    _eliminatedOptions = {};
    _correctCount = 0;
    _wrongCount = 0;
    _skippedCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
