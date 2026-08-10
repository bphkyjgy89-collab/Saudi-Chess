import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../models/game_mode.dart';
import '../theme/app_theme.dart';

/// نافذة سفلية لاختيار مستوى الصعوبة قبل بدء اللعب ضد الكمبيوتر
class DifficultySheet extends StatelessWidget {
  const DifficultySheet({super.key});

  static Future<Difficulty?> show(BuildContext context) {
    return showModalBottomSheet<Difficulty>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const DifficultySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.chooseDifficulty,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...Difficulty.values.map(
              (d) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(d),
                  child: Text(d.label),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
