import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/game_mode.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _startVsComputer(BuildContext context) async {
    final difficulty = await _pickDifficulty(context);
    if (difficulty == null || !context.mounted) return;

    final playerIsWhite = await _pickColor(context);
    if (playerIsWhite == null || !context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(
          mode: GameMode.vsComputer,
          difficulty: difficulty,
          playerIsWhite: playerIsWhite,
        ),
      ),
    );
  }

  void _startVsFriend(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GameScreen(mode: GameMode.vsFriend),
      ),
    );
  }

  Future<Difficulty?> _pickDifficulty(BuildContext context) {
    return showModalBottomSheet<Difficulty>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.chooseDifficulty,
                textAlign: TextAlign.center,
                style: Theme.of(sheetContext)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...Difficulty.values.map(
                (d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(sheetContext).pop(d),
                    child: Text(d.label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _pickColor(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          AppStrings.chooseColor,
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ColorChoice(
              label: AppStrings.playAsWhite,
              color: Colors.white,
              borderColor: Colors.black26,
              onTap: () => Navigator.of(dialogContext).pop(true),
            ),
            _ColorChoice(
              label: AppStrings.playAsBlack,
              color: Colors.black87,
              borderColor: Colors.black87,
              onTap: () => Navigator.of(dialogContext).pop(false),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              const _Logo(),
              const SizedBox(height: 8),
              Text(
                AppStrings.homeSubtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 48),
              _MenuButton(
                icon: Icons.smart_toy_outlined,
                label: AppStrings.playVsComputer,
                onTap: () => _startVsComputer(context),
              ),
              const SizedBox(height: 14),
              _MenuButton(
                icon: Icons.people_alt_outlined,
                label: AppStrings.playVsFriend,
                onTap: () => _startVsFriend(context),
              ),
              const SizedBox(height: 14),
              _MenuButton(
                icon: Icons.public,
                label: AppStrings.playOnline,
                badge: AppStrings.comingSoon,
                onTap: null,
              ),
              const SizedBox(height: 14),
              _MenuButton(
                icon: Icons.extension_outlined,
                label: AppStrings.puzzles,
                badge: AppStrings.comingSoon,
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.castle_outlined,
            color: AppColors.gold,
            size: 44,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appNameArabic,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: enabled ? AppColors.primaryGreen : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: enabled ? Colors.white : Colors.black54),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: enabled ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
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

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({
    required this.label,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
