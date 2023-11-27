import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSwitcher extends ChangeNotifier {
  String _isDarkTheme = "deneme yazı";
  String get isDarkTheme => _isDarkTheme;

  ThemeMode themeMode = ThemeMode.light;

  switchTheme() {
    if(_isDarkTheme == "deneme yazı") {
      _isDarkTheme = "cdscsd";
    }else {
      _isDarkTheme = "deneme yazı";
    }
    notifyListeners();
  }
}

final themeProvider = ChangeNotifierProvider((ref) => ThemeSwitcher());