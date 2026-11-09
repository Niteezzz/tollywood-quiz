import 'dart:async';

import 'package:flutter/material.dart';

import '../data/score_store.dart';
import '../models/quiz_question.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.questions,
  });

  final String category;
  final String difficulty;
  final List<QuizQuestion> questions;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final int _timeLimit;
  Timer? _timer;
  int _questionIndex = 0;
  int _secondsLeft = 15;
  int _score = 0;
  int? _selectedIndex;
  bool _showFeedback = false;
  bool _movingToNext = false;

  QuizQuestion get _currentQuestion => widget.questions[_questionIndex];

  @override
  void initState() {
    super.initState();
    _timeLimit = switch (widget.difficulty) {
      'Easy' => 20,
      'Medium' => 15,
      _ => 10,
    };
    _secondsLeft = _timeLimit;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _showFeedback) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _selectedIndex = -1;
          _showFeedback = true;
        });
        _scheduleNext();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _selectAnswer(int index) {
    if (_showFeedback || _movingToNext) return;
    _timer?.cancel();
    setState(() {
      _selectedIndex = index;
      _showFeedback = true;
      if (index == _currentQuestion.correctIndex) _score++;
    });
    _scheduleNext();
  }

  void _scheduleNext() {
    if (_movingToNext) return;
    _movingToNext = true;
    Future<void>.delayed(const Duration(milliseconds: 1050), _nextQuestion);
  }

  void _nextQuestion() {
    if (!mounted) return;
    if (_questionIndex + 1 >= widget.questions.length) {
      ScoreStore.add(
        category: widget.category,
        difficulty: widget.difficulty,
        score: _score,
        total: widget.questions.length,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            category: widget.category,
            difficulty: widget.difficulty,
            score: _score,
            total: widget.questions.length,
          ),
        ),
      );
      return;
    }

    setState(() {
      _questionIndex++;
      _secondsLeft = _timeLimit;
      _selectedIndex = null;
      _showFeedback = false;
      _movingToNext = false;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color _optionColor(int index) {
    if (!_showFeedback) return AppTheme.surface;
    if (index == _currentQuestion.correctIndex) return AppTheme.success.withValues(alpha: 0.18);
    if (index == _selectedIndex) return AppTheme.danger.withValues(alpha: 0.18);
    return AppTheme.surface;
  }

  Color _optionBorder(int index) {
    if (!_showFeedback) return Colors.white12;
    if (index == _currentQuestion.correctIndex) return AppTheme.success;
    if (index == _selectedIndex) return AppTheme.danger;
    return Colors.white12;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_questionIndex + 1) / widget.questions.length;
    final timerFraction = _secondsLeft / _timeLimit;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Exit quiz',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: Text(widget.category, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Center(
              child: Text(widget.difficulty.toUpperCase(), style: const TextStyle(color: AppTheme.accent, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('QUESTION ${_questionIndex + 1} OF ${widget.questions.length}', style: const TextStyle(color: AppTheme.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
                    Text('$_score correct', style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(value: progress, minHeight: 7, backgroundColor: Colors.white10, color: AppTheme.primary),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white10)),
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppTheme.accent),
                      const SizedBox(width: 12),
                      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: timerFraction.clamp(0, 1), minHeight: 8, backgroundColor: Colors.white10, color: _secondsLeft <= 5 ? AppTheme.danger : AppTheme.accent))),
                      const SizedBox(width: 12),
                      SizedBox(width: 30, child: Text('$_secondsLeft', textAlign: TextAlign.end, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: _secondsLeft <= 5 ? AppTheme.danger : Colors.white))),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(_currentQuestion.question, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, height: 1.25)),
                const SizedBox(height: 22),
                Expanded(
                  child: ListView.separated(
                    itemCount: _currentQuestion.options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isCorrect = index == _currentQuestion.correctIndex;
                      final isSelected = index == _selectedIndex;
                      return Material(
                        color: _optionColor(index),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          onTap: _showFeedback ? null : () => _selectAnswer(index),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 64),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: _optionBorder(index), width: 1.3)),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                  child: Text(String.fromCharCode(65 + index), style: const TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(child: Text(_currentQuestion.options[index], style: const TextStyle(fontWeight: FontWeight.w600))),
                                if (_showFeedback && isCorrect) const Icon(Icons.check_circle, color: AppTheme.success),
                                if (_showFeedback && isSelected && !isCorrect) const Icon(Icons.cancel, color: AppTheme.danger),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_showFeedback)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(_selectedIndex == _currentQuestion.correctIndex ? Icons.check_circle : Icons.info_outline, color: _selectedIndex == _currentQuestion.correctIndex ? AppTheme.success : AppTheme.accent),
                        const SizedBox(width: 10),
                        Expanded(child: Text(_selectedIndex == -1 ? 'Time is up. ${_currentQuestion.explanation}' : _currentQuestion.explanation, style: const TextStyle(height: 1.4, color: Colors.white70))),
                      ],
                    ),
                  )
                else
                  const Text('Choose the best answer before the timer reaches zero.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
