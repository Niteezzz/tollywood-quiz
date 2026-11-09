import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/question_model.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import '../router/app_router.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  QuizCategory? _selectedCategory;

  final List<_CategoryData> _categories = [
    _CategoryData(
      category: QuizCategory.actors,
      emoji: '🎭',
      title: 'Actors',
      gradientColors: [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
    ),
    _CategoryData(
      category: QuizCategory.movies,
      emoji: '🎬',
      title: 'Movies',
      gradientColors: [const Color(0xFFE94560), const Color(0xFFC62828)],
    ),
    _CategoryData(
      category: QuizCategory.directors,
      emoji: '🎥',
      title: 'Directors',
      gradientColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
    ),
    _CategoryData(
      category: QuizCategory.songs,
      emoji: '🎵',
      title: 'Songs',
      gradientColors: [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
    ),
    _CategoryData(
      category: QuizCategory.awards,
      emoji: '🏆',
      title: 'Awards',
      gradientColors: [const Color(0xFFB8860B), const Color(0xFFFFD700)],
    ),
    _CategoryData(
      category: QuizCategory.dialogues,
      emoji: '💬',
      title: 'Dialogues',
      gradientColors: [const Color(0xFF4776E6), const Color(0xFF8E54E9)],
    ),
    _CategoryData(
      category: QuizCategory.all,
      emoji: '🌟',
      title: 'All Categories',
      gradientColors: [const Color(0xFF0F3460), const Color(0xFFE94560)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Choose Category'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'What do you want to\ntest yourself on?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.white,
                    height: 1.3,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final data = _categories[index];
                  final delay = index * 0.1;
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final animValue = (((_controller.value - delay) / (1 - delay))
                          .clamp(0.0, 1.0));
                      return Opacity(
                        opacity: animValue,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - animValue)),
                          child: child,
                        ),
                      );
                    },
                    child: CategoryCard(
                      emoji: data.emoji,
                      title: data.title,
                      gradientColors: data.gradientColors,
                      isSelected: _selectedCategory == data.category,
                      onTap: () {
                        setState(() => _selectedCategory = data.category);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          if (mounted) {
                            context.push(
                              '${AppRouter.difficulty}/${data.category.name}',
                            );
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final QuizCategory category;
  final String emoji;
  final String title;
  final List<Color> gradientColors;

  const _CategoryData({
    required this.category,
    required this.emoji,
    required this.title,
    required this.gradientColors,
  });
}
