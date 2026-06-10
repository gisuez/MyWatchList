import 'package:flutter/material.dart';
import 'package:my_watch_list/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // VARIABILI
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.indigo;
  String _serverUrl = 'http://localhost:3000';

  // COSTRUTTORE
  SettingsProvider() {
    _loadFromPrefs();
  }

  // GETTER
  ThemeMode get getThemeMode => _themeMode;
  Color get getSeedColor => _seedColor;
  String get getServerUrl => _serverUrl;

  // SETTER
  void setServerUrl(String url) async {
    _serverUrl = url;
    ApiService.serverUrl = url;

    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('serverUrl', url);
  }

  void setSeedColor(Color color) async {
    _seedColor = color;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seedColor', color.value);
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', mode.name);
  }

  void _loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? themeStr = prefs.getString('theme');
    if (themeStr != null) {
      // scrivi in unalltro modo
      switch (themeStr) {
        case 'system':
          _themeMode = ThemeMode.system;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'light':
          _themeMode = ThemeMode.light;
          break;
      }
    }

    String? serverUrlStr = prefs.getString('serverUrl');
    if (serverUrlStr != null) {
      _serverUrl = serverUrlStr;
      ApiService.serverUrl = serverUrlStr;
    }

    int? seedColorInt = prefs.getInt('seedColor');
    if (seedColorInt != null) {
      _seedColor = Color(seedColorInt);
    }

    notifyListeners();
  }
}
