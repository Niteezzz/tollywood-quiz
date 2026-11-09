import 'package:flutter/material.dart';

import '../data/score_store.dart';
import '../theme/app_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [...ScoreStore.scores]..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.leaderboard_outlined, size: 64, color: AppTheme.muted),
                        const SizedBox(height: 16),
                        Text('No scores yet', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('Complete a quiz and your score will appear here.', style: TextStyle(color: AppTheme.muted), textAlign: TextAlign.center),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: index == 0 ? AppTheme.accent.withValues(alpha: 0.18) : Colors.white10,
                            child: Text('${index + 1}', style: TextStyle(color: index == 0 ? AppTheme.accent : Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(entry.playerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${entry.category}  •  ${entry.difficulty}', style: const TextStyle(color: AppTheme.muted)),
                          trailing: Text('${entry.score}/${entry.total}', style: const TextStyle(color: AppTheme.accent, fontSize: 17, fontWeight: FontWeight.w900)),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
