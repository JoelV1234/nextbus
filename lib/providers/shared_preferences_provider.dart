import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  late SharedPreferences _prefs;

  Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  SharedPreferences get prefs => _prefs;
}
