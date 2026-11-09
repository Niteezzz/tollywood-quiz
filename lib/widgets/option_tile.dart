import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum OptionState { normal, correct, wrong, disabled, eliminated }

class OptionTile extends StatefulWidget {
  final String text;
  final String prefix;
  final OptionState state;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.prefix,
    this.state = OptionState.normal,
    this.onTap,
  });

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: AppColors.darkCard,
      end: _getTargetColor(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.state != OptionState.normal) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _colorAnimation = ColorTween(
        begin: _colorAnimation.value ?? _getSourceColor(oldWidget.state),
        end: _getTargetColor(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
    }
  }

  Color _getSourceColor(OptionState state) {
    switch (state) {
      case OptionState.normal:
        return AppColors.darkCard;
      case OptionState.correct:
        return AppColors.correctGreen;
      case OptionState.wrong:
        return AppColors.wrongRed;
      case OptionState.disabled:
        return AppColors.darkCard;
      case OptionState.eliminated:
        return AppColors.eliminated;
    }
  }

  Color _getTargetColor() {
    switch (widget.state) {
      case OptionState.normal:
        return AppColors.darkCard;
      case OptionState.correct:
        return AppColors.correctGreen;
      case OptionState.wrong:
        return AppColors.wrongRed;
      case OptionState.disabled:
        return AppColors.darkCard;
      case OptionState.eliminated:
        return AppColors.eliminated;
    }
  }

  Color _getBorderColor() {
    switch (widget.state) {
      case OptionState.normal:
        return AppColors.gold.withOpacity(0.3);
      case OptionState.correct:
        return AppColors.green;
      case OptionState.wrong:
        return AppColors.red;
      case OptionState.disabled:
        return AppColors.grey.withOpacity(0.3);
      case OptionState.eliminated:
        return AppColors.grey.withOpacity(0.2);
    }
  }

  IconData? _getTrailingIcon() {
    switch (widget.state) {
      case OptionState.correct:
        return Icons.check_circle_rounded;
      case OptionState.wrong:
        return Icons.cancel_rounded;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEliminated = widget.state == OptionState.eliminated;
    final isDisabled = widget.state == OptionState.disabled || isEliminated;

    return GestureDetector(
      onTapDown: isDisabled || widget.onTap == null ? null : (_) => _controller.forward(),
      onTapUp: isDisabled || widget.onTap == null
          ? null
          : (_) {
              _controller.reverse();
              widget.onTap?.call();
            },
      onTapCancel: isDisabled || widget.onTap == null ? null : () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.state == OptionState.normal ? _scaleAnimation.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _colorAnimation.value ?? _getTargetColor(),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _getBorderColor(), width: 1.5),
                boxShadow: widget.state == OptionState.correct ||
                        widget.state == OptionState.wrong
                    ? [
                        BoxShadow(
                          color: _getTargetColor().withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isEliminated
                          ? AppColors.grey.withOpacity(0.3)
                          : AppColors.darkBackground.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        widget.prefix,
                        style: TextStyle(
                          color: isEliminated ? AppColors.grey : AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: isEliminated ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isEliminated ? AppColors.grey : AppColors.white,
                            fontWeight: FontWeight.w500,
                            decoration: isEliminated ? TextDecoration.lineThrough : null,
                          ),
                    ),
                  ),
                  if (_getTrailingIcon() != null)
                    Icon(
                      _getTrailingIcon(),
                      color: widget.state == OptionState.correct
                          ? AppColors.green
                          : AppColors.red,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
