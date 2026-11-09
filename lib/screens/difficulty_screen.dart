import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../router/app_router.dart';

class DifficultyScreen extends StatefulWidget {
  final QuizCategory category;

  const DifficultyScreen({super.key, required this.category});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<_DifficultyData> _difficulties = [
    _DifficultyData(
      difficulty: Difficulty.easy,
      label: 'Easy',
      emoji: '😊',
      description: '30 seconds per question\nGreat for beginners',
      color: AppColors.green,
      gradientColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
      points: '10 pts per question',
    ),
    _DifficultyData(
      difficulty: Difficulty.medium,
      label: 'Medium',
      emoji: '🤔',
      description: '20 seconds per question\nFor casual fans',
      color: AppColors.orange,
      gradientColors: [const Color(0xFFf37335), const Color(0xFFfda085)],
      points: '20 pts per question',
    ),
    _DifficultyData(
      difficulty: Difficulty.hard,
      label: 'Hard',
      emoji: '🔥',
      description: '15 seconds per question\nFor true Tollywood fans',
      color: AppColors.red,
      gradientColors: [const Color(0xFFE94560), const Color(0xFFC62828)],
      points: '30 pts per question',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startQuiz(Difficulty difficulty) {
    context.read<QuizProvider>().startQuiz(widget.category, difficulty);
    context.push(AppRouter.quiz);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text('${widget.category.emoji} ${widget.category.displayName}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Choose Difficulty',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Higher difficulty = more points & faster timer!',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 32),
            ...List.generate(_difficulties.length, (index) {
              final data = _difficulties[index];
              final delay = index * 0.15;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final animValue = ((_controller.value - delay) / (1 - delay))
                        .clamp(0.0, 1.0);
                    return Opacity(
                      opacity: animValue,
                      child: Transform.translate(
                        offset: Offset(60 * (1 - animValue), 0),
                        child: child,
                      ),
                    );
                  },
                  child: _DifficultyCard(
                    data: data,
                    onTap: () => _startQuiz(data.difficulty),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DifficultyData {
  final Difficulty difficulty;
  final String label;
  final String emoji;
  final String description;
  final Color color;
  final List<Color> gradientColors;
  final String points;

  const _DifficultyData({
    required this.difficulty,
    required this.label,
    required this.emoji,
    required this.description,
    required this.color,
    required this.gradientColors,
    required this.points,
  });
}

class _DifficultyCard extends StatefulWidget {
  final _DifficultyData data;
  final VoidCallback onTap;

  const _DifficultyCard({required this.data, required this.onTap});

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: widget.data.gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.data.color.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(widget.data.emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.label,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.data.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.white.withOpacity(0.85),
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.data.points,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
