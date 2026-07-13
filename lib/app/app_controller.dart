import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('pt', 'BR');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void cycleThemeMode() {
    _themeMode = switch (_themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    notifyListeners();
  }

  void toggleLocale() {
    _locale = _locale.languageCode == 'pt'
        ? const Locale('en')
        : const Locale('pt', 'BR');
    notifyListeners();
  }
}
