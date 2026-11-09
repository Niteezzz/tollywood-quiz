import 'package:flutter/material.dart';

import '../data/question_bank.dart';
import '../data/score_store.dart';
import '../theme/app_theme.dart';
import 'leaderboard_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, IconData> _categoryIcons = const {
    'Movies': Icons.movie_creation_outlined,
    'Actors': Icons.stars_outlined,
    'Directors': Icons.movie_filter_outlined,
    'Music': Icons.music_note_outlined,
    'Blockbusters': Icons.emoji_events_outlined,
    'Hardcore Tollywood': Icons.local_fire_department_outlined,
  };

  final Map<String, String> _categoryDescriptions = const {
    'Movies': 'Stories, scenes and unforgettable films',
    'Actors': 'Test your knowledge of Telugu stars',
    'Directors': 'The visionaries behind the camera',
    'Music': 'Composers, soundtracks and melodies',
    'Blockbusters': 'Popular films and iconic moments',
    'Hardcore Tollywood': 'For serious Telugu cinema fans',
  };

  Future<void> _chooseDifficulty(String category) async {
    final difficulty = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text('Choose your challenge', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(category, style: const TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 18),
              _DifficultyTile(
                title: 'Easy',
                subtitle: '20 seconds per question',
                icon: Icons.sentiment_satisfied_alt,
                color: AppTheme.success,
                onTap: () => Navigator.pop(context, 'Easy'),
              ),
              _DifficultyTile(
                title: 'Medium',
                subtitle: '15 seconds per question',
                icon: Icons.local_fire_department_outlined,
                color: AppTheme.accent,
                onTap: () => Navigator.pop(context, 'Medium'),
              ),
              _DifficultyTile(
                title: 'Hard',
                subtitle: '10 seconds per question',
                icon: Icons.bolt,
                color: AppTheme.primary,
                onTap: () => Navigator.pop(context, 'Hard'),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted || difficulty == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          category: category,
          difficulty: difficulty,
          questions: questionBank[category] ?? const [],
        ),
      ),
    );
  }

  Future<void> _editPlayerName() async {
    final controller = TextEditingController(text: ScoreStore.playerName);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Your player name'),
        content: TextField(
          controller: controller,
          maxLength: 18,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter a display name'),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(dialogContext, controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty && mounted) {
      setState(() => ScoreStore.playerName = name.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            final columns = constraints.maxWidth >= 1050 ? 3 : (constraints.maxWidth >= 620 ? 2 : 1);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: wide ? 34 : 18, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TopBar(
                        playerName: ScoreStore.playerName,
                        onLeaderboard: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
                        onProfile: _editPlayerName,
                      ),
                      const SizedBox(height: 26),
                      _HeroBanner(onStart: () => _chooseDifficulty('Movies')),
                      const SizedBox(height: 34),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Explore categories', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          Text('${quizCategories.length} categories', style: const TextStyle(color: AppTheme.muted)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quizCategories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 126,
                        ),
                        itemBuilder: (context, index) {
                          final category = quizCategories[index];
                          return _CategoryCard(
                            title: category,
                            description: _categoryDescriptions[category] ?? '',
                            icon: _categoryIcons[category] ?? Icons.movie,
                            onTap: () => _chooseDifficulty(category),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      _InfoStrip(),
                      const SizedBox(height: 26),
                      Center(
                        child: Text(
                          'Made for Telugu cinema fans  •  Tollywood Quiz',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.muted),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.playerName, required this.onLeaderboard, required this.onProfile});

  final String playerName;
  final VoidCallback onLeaderboard;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.local_movies_outlined, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOLLYWOOD QUIZ', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const Text('THE ULTIMATE TELUGU CINEMA CHALLENGE', style: TextStyle(fontSize: 9, color: AppTheme.muted, letterSpacing: 1.1)),
            ],
          ),
        ),
        IconButton(tooltip: 'Leaderboard', onPressed: onLeaderboard, icon: const Icon(Icons.leaderboard_outlined)),
        TextButton.icon(
          onPressed: onProfile,
          icon: const Icon(Icons.person_outline, size: 18),
          label: Text(playerName, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F1D2D), Color(0xFF311827), Color(0xFF171B28)],
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(30)),
                child: const Text('🎬  YOUR CINEMA. YOUR CHALLENGE.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
              ),
              const SizedBox(height: 18),
              Text('HOW WELL DO YOU\nKNOW TOLLYWOOD?', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -0.7)),
              const SizedBox(height: 12),
              const Text('From iconic movies to legendary stars. Put your Telugu cinema knowledge to the test.', style: TextStyle(color: Colors.white70, height: 1.5)),
              const SizedBox(height: 22),
              ElevatedButton.icon(onPressed: onStart, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Start a quiz')),
            ],
          );

          if (compact) return copy;
          return Row(
            children: [
              Expanded(flex: 3, child: copy),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Center(
                    child: Icon(Icons.movie_filter_rounded, size: 104, color: Color(0xFFFFC857)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.title, required this.description, required this.icon, required this.onTap});
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white10)),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: AppTheme.accent, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 5),
                    Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.muted, fontSize: 11, height: 1.3)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyTile extends StatelessWidget {
  const _DifficultyTile({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppTheme.muted)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _InfoStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(18)),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline, color: AppTheme.accent),
          SizedBox(width: 12),
          Expanded(child: Text('Choose a category, pick your pace and answer every question before the timer runs out.', style: TextStyle(color: AppTheme.muted, height: 1.4))),
        ],
      ),
    );
  }
}
