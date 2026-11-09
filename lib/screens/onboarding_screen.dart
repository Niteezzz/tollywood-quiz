import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../router/app_router.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentPage = 0;
  late AnimationController _dotController;
  late AnimationController _pageAnimController;
  late Animation<double> _pageAnimation;

  final List<_OnboardingPage> _pages = [
    const _OnboardingPage(
      emoji: '🎬',
      title: 'Welcome to\nTollywood Trivia',
      subtitle:
          'The ultimate quiz app for Telugu cinema lovers. Test your knowledge about Tollywood\'s greatest stars, films, and moments!',
    ),
    const _OnboardingPage(
      emoji: '🏆',
      title: 'Multiple\nCategories',
      subtitle:
          'Choose from Actors, Movies, Directors, Songs, Awards, and Dialogues. Use lifelines like 50-50 and Skip to get through tough questions!',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _pageAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pageAnimController, curve: Curves.easeOut),
    );
    _pageAnimController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _dotController.dispose();
    _pageAnimController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _getStarted() async {
    if (_formKey.currentState?.validate() != true) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await context.read<UserProvider>().setUserName(name);
    if (mounted) {
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _pageAnimController.forward(from: 0);
                },
                children: [
                  ..._pages.asMap().entries.map(
                        (entry) => _buildInfoPage(entry.value),
                      ),
                  _buildNamePage(),
                ],
              ),
            ),
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.gold
                          : AppColors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: _currentPage < 2
                  ? CustomButton(
                      label: 'Next',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _nextPage,
                      width: double.infinity,
                    )
                  : CustomButton(
                      label: 'Get Started',
                      icon: Icons.movie_rounded,
                      onPressed: _getStarted,
                      width: double.infinity,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPage(_OnboardingPage page) {
    return FadeTransition(
      opacity: _pageAnimation,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.2),
                    AppColors.darkCard,
                  ],
                ),
                border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 2),
              ),
              child: Center(
                child: Text(
                  page.emoji,
                  style: const TextStyle(fontSize: 64),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey,
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamePage() {
    return FadeTransition(
      opacity: _pageAnimation,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.2),
                    AppColors.darkCard,
                  ],
                ),
                border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 2),
              ),
              child: const Center(
                child: Text('⭐', style: TextStyle(fontSize: 64)),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "What's Your Name?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Enter your name to personalize your Tollywood Trivia experience!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyLarge,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'e.g. Ravi Kumar',
                  prefixIcon: const Icon(Icons.person_rounded, color: AppColors.gold),
                  filled: true,
                  fillColor: AppColors.darkCard,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
}
