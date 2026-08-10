/// جميع نصوص التطبيق بالعربي في مكان واحد
/// لاحقاً لو حبيت تضيف لغات ثانية، تقدر تحول هذا الملف
/// إلى ملفات .arb واستخدام intl الرسمية بسهولة
class AppStrings {
  AppStrings._();

  // عام
  static const appName = 'Saudi Chess';
  static const appNameArabic = 'الشطرنج السعودي';

  // الشاشة الرئيسية
  static const homeSubtitle = 'العب الشطرنج بالعربي';
  static const playVsComputer = 'العب ضد الكمبيوتر';
  static const playVsFriend = 'العب مع صديق';
  static const playOnline = 'العب أونلاين';
  static const comingSoon = 'قريباً';
  static const puzzles = 'الألغاز';
  static const settings = 'الإعدادات';

  // اختيار الصعوبة
  static const chooseDifficulty = 'اختر مستوى الصعوبة';
  static const difficultyBeginner = 'مبتدئ';
  static const difficultyEasy = 'سهل';
  static const difficultyMedium = 'متوسط';
  static const difficultyHard = 'صعب';
  static const difficultyExpert = 'خبير';
  static const start = 'ابدأ';
  static const cancel = 'إلغاء';

  // اختيار اللون
  static const chooseColor = 'اختر لونك';
  static const playAsWhite = 'أبيض';
  static const playAsBlack = 'أسود';

  // أثناء اللعب
  static const yourTurn = 'دورك';
  static const computerThinking = 'الكمبيوتر يفكر...';
  static const whiteTurn = 'دور الأبيض';
  static const blackTurn = 'دور الأسود';
  static const newGame = 'لعبة جديدة';
  static const undoMove = 'تراجع';
  static const resign = 'استسلام';
  static const flipBoard = 'قلب اللوحة';

  // نهاية اللعبة
  static const checkmate = 'كش ملك';
  static const whiteWins = 'الأبيض يفوز!';
  static const blackWins = 'الأسود يفوز!';
  static const draw = 'تعادل';
  static const stalemate = 'تعادل بالجمود';
  static const gameOver = 'انتهت اللعبة';
  static const playAgain = 'العب مرة ثانية';
  static const backToHome = 'الرئيسية';

  // قطع الشطرنج بالعربي
  static const king = 'الملك';
  static const queen = 'الوزير';
  static const rook = 'الرخ';
  static const bishop = 'الفيل';
  static const knight = 'الحصان';
  static const pawn = 'البيدق';

  // ترقية البيدق
  static const promotionTitle = 'ترقية البيدق';
  static const promotionSubtitle = 'اختر القطعة يلي تبي ترقي لها';
}
