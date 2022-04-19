import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const themeModeKey = "THEMEMODE";
  static const usernameKey = "USERNAME";
  static const isOnBoardingCompleteKey = "ISONBOARDINGDONE";

  static final SharedPreferencesHelper _sharedPreferencesHelper =
      SharedPreferencesHelper._internal();
  factory SharedPreferencesHelper() => _sharedPreferencesHelper;
  SharedPreferencesHelper._internal();

  static SharedPreferences? _instance;

  Future<SharedPreferences> get instance async {
    if (_instance != null) return _instance!;
    _instance = await _initPrefInstance();
    return _instance!;
  }

  Future<SharedPreferences> _initPrefInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> setOnboardingAsComplete() async {
    log('Completing onboarding');
    final prefInstance = await _sharedPreferencesHelper.instance;
    prefInstance.setBool(SharedPreferencesHelper.isOnBoardingCompleteKey, true);
  }

  Future<bool> getOnboardingStatus() async {
    log('Getting onboarding status');
    final prefInstance = await _sharedPreferencesHelper.instance;
    return prefInstance.getBool(
          SharedPreferencesHelper.isOnBoardingCompleteKey,
        ) ??
        false;
  }

  Future<ThemeMode> setThemeMode(ThemeMode themeMode) async {
    log('Setting theme mode');
    final prefInstance = await _sharedPreferencesHelper.instance;
    prefInstance.setInt(SharedPreferencesHelper.themeModeKey, themeMode.index);
    return themeMode;
  }

  Future<ThemeMode> getThemeMode() async {
    log('Getting theme mode');
    final prefInstance = await _sharedPreferencesHelper.instance;
    final themeModeIndex =
        prefInstance.getInt(SharedPreferencesHelper.themeModeKey) ?? 1;
    return ThemeMode.values[themeModeIndex];
  }

  Future<String> setUsername(String username) async {
    log('Setting theme mode');
    final prefInstance = await _sharedPreferencesHelper.instance;
    prefInstance.setString(SharedPreferencesHelper.usernameKey, username);
    return username;
  }

  Future<String> getUsername() async {
    log('Getting theme mode');
    final prefInstance = await _sharedPreferencesHelper.instance;
    final username =
        prefInstance.getString(SharedPreferencesHelper.usernameKey) ?? '';
    return username;
  }
}
