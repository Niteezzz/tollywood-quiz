import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _rotationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    _navigate();
  }

  void _navigate() {
    if (!mounted) return;
    final userProvider = context.read<UserProvider>();
    if (userProvider.hasName) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.onboarding);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Star field background
          const _StarField(),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated clapperboard / film reel
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [AppColors.goldDark, AppColors.darkCard],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: child,
                          );
                        },
                        child: const Icon(
                          Icons.movie_filter_rounded,
                          color: AppColors.gold,
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textFadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'TOLLYWOOD',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 38,
                              letterSpacing: 6,
                            ),
                      ),
                      Text(
                        'TRIVIA',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.white,
                              letterSpacing: 10,
                              fontSize: 24,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Test Your Telugu Cinema Knowledge',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.grey,
                              letterSpacing: 1,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                FadeTransition(
                  opacity: _textFadeAnimation,
                  child: const _LoadingDots(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final progress = (_controller.value - delay).clamp(0.0, 1.0 / 3) * 3;
            final opacity = math.sin(progress * math.pi).clamp(0.3, 1.0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _StarField extends StatefulWidget {
  const _StarField();

  @override
  State<_StarField> createState() => _StarFieldState();
}

class _StarFieldState extends State<_StarField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = math.Random(42);
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = List.generate(
      60,
      (_) => _Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2 + 0.5,
        opacity: _random.nextDouble() * 0.6 + 0.1,
        phase: _random.nextDouble() * 2 * math.pi,
      ),
    );

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _StarPainter(stars: _stars, t: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  final double x, y, size, opacity, phase;
  const _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.phase,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double t;

  const _StarPainter({required this.stars, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in stars) {
      final twinkle = (math.sin(t * 2 * math.pi + star.phase) * 0.3 + 0.7)
          .clamp(0.1, 1.0);
      paint.color = AppColors.gold.withOpacity(star.opacity * twinkle);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) => oldDelegate.t != t;
}
