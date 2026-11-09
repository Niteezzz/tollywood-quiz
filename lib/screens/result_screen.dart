import 'package:flutter/material.dart';

import '../data/score_store.dart';
import '../theme/app_theme.dart';
import 'leaderboard_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.total,
  });

  final String category;
  final String difficulty;
  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : score / total;
    final message = percentage >= 0.8
        ? 'Tollywood expert!'
        : percentage >= 0.5
            ? 'Great effort!'
            : 'Keep exploring cinema!';

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz complete')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.13), shape: BoxShape.circle),
                  child: const Icon(Icons.emoji_events_rounded, color: AppTheme.accent, size: 58),
                ),
                const SizedBox(height: 22),
                Text(message, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('$category  •  $difficulty', style: const TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white10)),
                  child: Column(
                    children: [
                      Text('$score / $total', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.accent, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      const Text('CORRECT ANSWERS', style: TextStyle(color: AppTheme.muted, letterSpacing: 1.4, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: percentage, minHeight: 10, backgroundColor: Colors.white12, color: AppTheme.success)),
                      const SizedBox(height: 12),
                      Text('${(percentage * 100).round()}% accuracy', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Choose another quiz'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
                    icon: const Icon(Icons.leaderboard_outlined),
                    label: const Text('View leaderboard'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Back to home'),
                ),
                if (ScoreStore.scores.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Nice work, ${ScoreStore.playerName}!', style: const TextStyle(color: AppTheme.muted)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
