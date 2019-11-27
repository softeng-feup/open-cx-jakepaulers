import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences prefs;

  static refreshSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> getPreferences() async {
    if (prefs == null)
      prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}