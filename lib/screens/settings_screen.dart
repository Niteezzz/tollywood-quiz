import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile section
              _SectionHeader(label: 'Profile'),
              _SettingsTile(
                icon: Icons.person_rounded,
                title: 'Player Name',
                subtitle: userProvider.user.name,
                onTap: () => _showChangeNameDialog(context, userProvider),
              ),
              const SizedBox(height: 20),

              // Preferences section
              _SectionHeader(label: 'Preferences'),
              _ToggleTile(
                icon: Icons.music_note_rounded,
                title: 'Sound Effects',
                subtitle: 'Enable in-game sounds',
                value: userProvider.soundEnabled,
                onChanged: (val) => userProvider.setSoundEnabled(val),
              ),
              _ToggleTile(
                icon: Icons.dark_mode_rounded,
                title: 'Dark Theme',
                subtitle: 'Cinema-style dark mode',
                value: userProvider.isDarkTheme,
                onChanged: (val) => userProvider.setDarkTheme(val),
              ),
              const SizedBox(height: 20),

              // Stats section
              _SectionHeader(label: 'Your Stats'),
              _StatsTile(
                icon: Icons.quiz_rounded,
                label: 'Quizzes Played',
                value: '${userProvider.user.quizzesPlayed}',
                color: AppColors.red,
              ),
              _StatsTile(
                icon: Icons.star_rounded,
                label: 'Total Score',
                value: '${userProvider.user.totalScore}',
                color: AppColors.gold,
              ),
              _StatsTile(
                icon: Icons.emoji_events_rounded,
                label: 'Best Score',
                value: '${userProvider.user.bestScore}',
                color: AppColors.green,
              ),
              _StatsTile(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak Record',
                value: '${userProvider.user.streakRecord}',
                color: AppColors.orange,
              ),
              const SizedBox(height: 20),

              // About section
              _SectionHeader(label: 'About'),
              _InfoTile(
                icon: Icons.info_rounded,
                title: 'App Version',
                value: '1.0.0',
              ),
              _InfoTile(
                icon: Icons.code_rounded,
                title: 'Developer',
                value: 'Tollywood Trivia Team',
              ),
              _InfoTile(
                icon: Icons.movie_rounded,
                title: 'Questions',
                value: '60+ Telugu cinema trivia',
              ),
              const SizedBox(height: 20),

              // Danger zone
              _SectionHeader(label: 'Danger Zone'),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.wrongRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.wrongRed.withOpacity(0.3), width: 1),
                ),
                child: ListTile(
                  leading: const Icon(Icons.delete_forever_rounded,
                      color: AppColors.red),
                  title: const Text(
                    'Reset All Progress',
                    style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'This will erase all your scores and data',
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                  onTap: () => _showResetDialog(context, userProvider),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showChangeNameDialog(
      BuildContext context, UserProvider userProvider) async {
    final controller = TextEditingController(text: userProvider.user.name);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Change Name',
            style: TextStyle(color: AppColors.gold)),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: AppColors.white),
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
              hintStyle: TextStyle(color: AppColors.grey),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name cannot be empty';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                Navigator.of(context).pop(controller.text.trim());
              }
            },
            child: const Text('Save',
                style: TextStyle(color: AppColors.gold)),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await userProvider.setUserName(result);
    }
  }

  Future<void> _showResetDialog(
      BuildContext context, UserProvider userProvider) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: const Text('Reset Progress',
            style: TextStyle(color: AppColors.red)),
        content: const Text(
          'Are you sure? This will permanently delete all your scores, stats, and leaderboard entries. This cannot be undone.',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset',
                style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      await userProvider.resetProgress();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress reset successfully'),
            backgroundColor: AppColors.darkCard,
          ),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gold,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        trailing: const Icon(Icons.edit_rounded, color: AppColors.grey, size: 18),
        onTap: onTap,
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}

class _StatsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatsTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: AppColors.white, fontSize: 15)),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: const TextStyle(color: AppColors.white, fontSize: 15)),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
