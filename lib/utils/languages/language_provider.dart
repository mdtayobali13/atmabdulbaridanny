import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'app_translations.dart';

class _LanguageNotifier extends Notifier<String> {
  @override
  String build() {
    _loadLanguage();
    return "en_US";
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("app_language") ?? "en_US";

    /// en_U Ses_ES
    state = saved;
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
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
  @override
  String build() {
    _loadLanguage();
    return "en_US";
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString("app_language") ?? "en_US";
    state = saved;
  }

  Future<void> setLanguage(String lang) async {
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
