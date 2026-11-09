import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final bool outlined;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.width,
    this.height = 56,
    this.borderRadius = 30,
    this.outlined = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.gold;
    final effectiveTextColor =
        widget.textColor ?? (widget.outlined ? effectiveColor : AppColors.darkBackground);

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.outlined ? Colors.transparent : effectiveColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.outlined
                ? Border.all(color: effectiveColor, width: 2)
                : null,
            boxShadow: widget.outlined
                ? null
                : [
                    BoxShadow(
                      color: effectiveColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: effectiveTextColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: effectiveTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
