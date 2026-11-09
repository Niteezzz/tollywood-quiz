import 'package:go_router/go_router.dart';

import '../providers/user_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/difficulty_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/result_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/settings_screen.dart';
import '../models/question_model.dart';
import '../models/quiz_question.dart';
import '../data/question_bank.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String difficulty = '/difficulty';
  static const String quiz = '/quiz';
  static const String result = '/result';
  static const String leaderboard = '/leaderboard';
  static const String settings = '/settings';

  static GoRouter createRouter(UserProvider userProvider) {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: onboarding,
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: categories,
          name: 'categories',
          builder: (context, state) => const CategoryScreen(),
        ),
        GoRoute(
          path: '$difficulty/:category',
          name: 'difficulty',
          builder: (context, state) {
            final categoryStr =
                state.pathParameters['category'] ?? 'all';

            final category = QuizCategory.values.firstWhere(
              (c) => c.name == categoryStr,
              orElse: () => QuizCategory.all,
            );

            return DifficultyScreen(category: category);
          },
        ),
        GoRoute(
          path: quiz,
          name: 'quiz',
          builder: (context, state) {
            final extra =
                state.extra as Map<String, dynamic>? ?? {};

            final category =
                extra['category'] as String? ?? 'Movies';

            final difficulty =
                extra['difficulty'] as String? ?? 'Easy';

            final questions =
                extra['questions'] as List<QuizQuestion>? ??
                questionBank[category] ??
                questionBank['Movies']!;

            return QuizScreen(
              category: category,
              difficulty: difficulty,
              questions: questions,
            );
          },
        ),
        GoRoute(
          path: result,
          name: 'result',
          builder: (context, state) {
            final extra =
                state.extra as Map<String, dynamic>? ?? {};

            final category =
                extra['category'] as String? ?? 'Movies';

            final difficulty =
                extra['difficulty'] as String? ?? 'Easy';

            final total =
                extra['total'] as int? ??
                (questionBank[category] ??
                    questionBank['Movies']!).length;

            return ResultScreen(
              category: category,
              difficulty: difficulty,
              score: extra['score'] as int? ?? 0,
              total: total,
            );
          },
        ),
        GoRoute(
          path: leaderboard,
          name: 'leaderboard',
          builder: (context, state) =>
              const LeaderboardScreen(),
        ),
        GoRoute(
          path: settings,
          name: 'settings',
          builder: (context, state) =>
              const SettingsScreen(),
        ),
      ],
    );
  }
}
