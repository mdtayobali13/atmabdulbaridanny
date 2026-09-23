import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'app_translations.dart';

class _LanguageNotifier extends Notifier<String> {
  static const String _storageKey = "user_app_language_v2";

  @override
  String build() {
    _loadLanguage();
    return "bn_BD";
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString(_storageKey);
    if (saved == null) {
      saved = "bn_BD";
      await prefs.setString(_storageKey, "bn_BD");
      await prefs.setString("app_language", "bn_BD");
    }
    state = saved;
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, lang);
    await prefs.setString("app_language", lang);
    state = lang;
  }

  Future<void> toggleLanguage() async {
    if (state.toLowerCase().startsWith("bn")) {
      await setLanguage("en_US");
    } else {
      await setLanguage("bn_BD");
    }
  }
}

final languageProvider = NotifierProvider<_LanguageNotifier, String>(() {
  return _LanguageNotifier();
});

final isBanglaProvider = Provider<bool>((ref) {
  final lang = ref.watch(languageProvider);
  return lang.toLowerCase().startsWith("bn");
});

class _InitialLanguage extends Notifier<String> {
  static const String _storageKey = "user_app_language_v2";

  @override
  String build() {
    _loadLanguage();
    return "bn_BD";
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString(_storageKey);
    if (saved == null) {
      saved = "bn_BD";
      await prefs.setString(_storageKey, "bn_BD");
      await prefs.setString("app_language", "bn_BD");
    }
    state = saved;
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, lang);
    await prefs.setString("app_language", lang);
    state = lang;
  }
}

extension BanglaDigitExtension on String {
  String toBanglaDigits(bool isBangla) {
    if (!isBangla) return this;
    const eng = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bng = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var res = this;
    for (int i = 0; i < 10; i++) {
      res = res.replaceAll(eng[i], bng[i]);
    }
    return res;
  }
}

final initialLanguageProvider = NotifierProvider<_InitialLanguage, String>(() {
  return _InitialLanguage();
});
