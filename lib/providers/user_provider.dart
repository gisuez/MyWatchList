import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT DATABASE
import '../database/database_helper.dart';

// IMPORT MODELS
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  // VARIABILI
  User? _user;

  // GETTER
  User? get getUser => _user;

  // SETTER
  set setUser(User? newUser) {
    _user = newUser;
    _saveToPrefs(newUser);
    notifyListeners();
  }

  // CARICA UTENTE DALLE PREFERENZE
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userStr = prefs.getString('logged_user');

    if (userStr != null) {
      _user = User.fromJson(jsonDecode(userStr));
    }

    notifyListeners();
  }

  // SALVA UTENTE NELLE PREFERENZE
  Future<void> _saveToPrefs(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (user != null) {
      await prefs.setString('logged_user', jsonEncode(user.toJson()));
    } else {
      await prefs.remove('logged_user');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_user');
    await DatabaseHelper.instance.clearDatabase();
    notifyListeners();
  }
}
