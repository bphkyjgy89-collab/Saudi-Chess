# Saudi Chess ♟️

تطبيق شطرنج بالعربي مبني بـ Flutter. المرحلة الحالية (المرحلة 1): لعب أوفلاين — ضد الكمبيوتر (Stockfish) أو مع صديق على نفس الجهاز.

## الميزات الحالية
- لوحة شطرنج كاملة بقواعد الشطرنج الرسمية (كش ملك، تعادل، ترقية البيدق...)
- لعب ضد محرك Stockfish بـ 5 مستويات صعوبة
- لعب محلي (Pass and Play) بين لاعبين على نفس الجهاز
- واجهة عربية كاملة مع دعم RTL
- ألوان مستوحاة من العلم السعودي

## هيكل المشروع
```
lib/
  main.dart              نقطة البداية + إعداد RTL والثيم
  theme/app_theme.dart    الألوان والخطوط
  l10n/app_strings.dart   كل النصوص العربية بمكان واحد
  models/game_mode.dart   أنماط اللعب ومستويات الصعوبة
  services/stockfish_service.dart   التعامل مع محرك Stockfish
  screens/home_screen.dart          الشاشة الرئيسية
  screens/game_screen.dart          شاشة اللعب + منطق اللعبة
  widgets/                          مكونات UI قابلة لإعادة الاستخدام
```

## التشغيل على GitHub Codespaces (بدون جهاز Mac)

1. أنشئ مستودع جديد على GitHub وارفع هذا المجلد بالكامل.
2. افتح المستودع بـ Codespaces.
3. ثبّت Flutter داخل الـ Codespace (مرة وحدة بس، أول ما تفتحه):
   ```bash
   git clone https://github.com/flutter/flutter.git -b stable --depth 1 ~/flutter
   echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
   source ~/.bashrc
   flutter doctor
   ```
4. جهّز مشروع Flutter كامل (عشان تنضاف مجلدات android/ و ios/ اللي ناقصة هنا):
   ```bash
   flutter create --org com.saudichess --project-name saudi_chess --platforms=ios,android .
   ```
   ⚠️ هذا الأمر ما بيلمس ملفات lib/ اللي جهزناها، بس بيولّد مجلدات ios/ و android/ والملفات الأساسية.
5. ثبّت الحزم:
   ```bash
   flutter pub get
   ```
6. تأكد تشتغل (تحليل الكود بدون تشغيل فعلي، لأن ما عندك جهاز يشغّل عليه):
   ```bash
   flutter analyze
   ```

## بخصوص Bundle ID و App Store Connect
- **Bundle ID المقترح:** `com.saudichess.app`
- سجّل اسم التطبيق "Saudi Chess" على App Store Connect وجهز:
  - App ID جديد بنفس الـ Bundle ID
  - مفتاح ASC API (متل يلي سويته لـ Khat Bat)
  - أيقونة التطبيق (1024×1024) وسكرين شوتس iPhone/iPad

## النشر عبر Codemagic
- ملف `codemagic.yaml` جاهز بنفس نمط مشروع Khat Bat.
- بس لازم تعدّل:
  - اسم integration الخاص بمفتاح ASC (`SaudiChess_ASC_Key`)
  - قيمة `APP_STORE_APPLE_ID` بعد ما تنشئ التطبيق بـ App Store Connect
- اربط المستودع بـ Codemagic وابدأ أول Build.

## خارطة الطريق (المراحل القادمة)
1. ✅ **المرحلة 1:** لعبة أوفلاين شغالة (هذا المشروع)
2. **المرحلة 2:** حسابات مستخدمين + تصنيف (rating) بسيط عبر Firebase/Supabase
3. **المرحلة 3:** لعب أونلاين بالوقت الحقيقي بين لاعبين
4. **المرحلة 4:** الألغاز (Puzzles) — ممكن تجيب قاعدة بيانات ألغاز مفتوحة من Lichess
5. **المرحلة 5:** دروس وتحليل بعد اللعبة

## ملاحظات تقنية مهمة
- **Stockfish على iOS:** محرك Stockfish بيشتغل عبر Dart FFI، وهذا يتطلب بناء فعلي بـ Xcode (يصير تلقائي عبر Codemagic، ما تحتاج تسويه يدوي).
- **الحد الأدنى لنظام iOS:** تأكد `IPHONEOS_DEPLOYMENT_TARGET` بمشروع iOS يكون 12.0 أو أعلى (بيتطلبها Stockfish package).
- إذا واجهت خطأ ببناء iOS بخصوص Stockfish، جرب `flutter clean` ثم `flutter pub get` من جديد قبل البناء.
