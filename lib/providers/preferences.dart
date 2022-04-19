import 'package:flutter/material.dart';
import 'package:parichaya_frontend/shared_preferences/shared_preferences_helper.dart';

class Preferences extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _username = '';
  bool _isOnboardingComplete = false;

  final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper();
  Preferences.noSync() {
    // SharedPreferencesHelper _tempSharedPreferencesHelper =
    //     SharedPreferencesHelper();
    // _sharedPreferencesHelper = _tempSharedPreferencesHelper;
  }
  Preferences() {
    syncToSharedPreferences();
  }

  Future<void> syncToSharedPreferences() async {
    _username = await _sharedPreferencesHelper.getUsername();
    _themeMode = await _sharedPreferencesHelper.getThemeMode();
    _isOnboardingComplete =
        await _sharedPreferencesHelper.getOnboardingStatus();
    notifyListeners();
  }

  ThemeMode get themeMode {
    return _themeMode;
  }

  String get username {
    return _username;
  }

  bool get isOnboardingComplete {
    return _isOnboardingComplete;
  }

  Future<void> setOnboardingAsComplete() async {
    _isOnboardingComplete = true;
    _sharedPreferencesHelper.setOnboardingAsComplete();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    _sharedPreferencesHelper.setThemeMode(themeMode);
    notifyListeners();
  }

  Future<void> setUsername(String username) async {
    _username = username;
    _sharedPreferencesHelper.setUsername(username);
    notifyListeners();
  }
}
