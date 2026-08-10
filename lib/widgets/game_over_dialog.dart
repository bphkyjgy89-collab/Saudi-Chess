import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

/// نافذة تظهر عند انتهاء اللعبة (كش ملك، تعادل...)
class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onPlayAgain,
  });

  final String title;
  final String message;
  final VoidCallback onPlayAgain;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onPlayAgain,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameOverDialog(
        title: title,
        message: message,
        onPlayAgain: onPlayAgain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: AppColors.gold, size: 48),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text(AppStrings.backToHome),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPlayAgain();
                    },
                    child: const Text(AppStrings.playAgain),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
