import 'package:shared_preferences/shared_preferences.dart';

class AppCache {

  final SharedPreferences _prefs;

  final String _timer = 'timer';

  AppCache(this._prefs);

  Future<void> setTimer(String time) async {
    _prefs.setString(_timer, time);
  }

  String? getTimer() {
    return _prefs.getString(_timer);
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}
