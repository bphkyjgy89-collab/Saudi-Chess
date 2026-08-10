/// نوع اللعبة يلي يختارها اللاعب من الشاشة الرئيسية
enum GameMode {
  vsComputer,
  vsFriend,
}

/// مستويات صعوبة الكمبيوتر (Stockfish)
/// skillLevel: 0-20 (حسب بروتوكول UCI)
/// moveTimeMs: الوقت المسموح للمحرك يفكر بكل نقلة
enum Difficulty {
  beginner(label: 'مبتدئ', skillLevel: 1, moveTimeMs: 300),
  easy(label: 'سهل', skillLevel: 4, moveTimeMs: 500),
  medium(label: 'متوسط', skillLevel: 8, moveTimeMs: 800),
  hard(label: 'صعب', skillLevel: 13, moveTimeMs: 1200),
  expert(label: 'خبير', skillLevel: 18, moveTimeMs: 2000);

  const Difficulty({
    required this.label,
    required this.skillLevel,
    required this.moveTimeMs,
  });

  final String label;
  final int skillLevel;
  final int moveTimeMs;
}
