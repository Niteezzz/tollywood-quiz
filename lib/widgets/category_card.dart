import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryCard extends StatefulWidget {
  final String emoji;
  final String title;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.gradientColors,
    this.onTap,
    this.isSelected = false,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
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
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isSelected
                  ? [AppColors.gold, AppColors.goldDark]
                  : widget.gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
            border: widget.isSelected
                ? Border.all(color: AppColors.gold, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
