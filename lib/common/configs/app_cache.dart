import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  final SharedPreferences _prefs;

  final String _timer = 'timer';
  final String _timeReminder = 'timeReminder';

  AppCache(this._prefs);

  Future<void> setTimer(String time) async {
    _prefs.setString(_timer, time);
  }

  String? getTimer() {
    return _prefs.getString(_timer);
  }

  Future<void> setReminder(String time) async {
    _prefs.setString(_timeReminder, time);
  }

  String? getReminder() {
    return _prefs.getString(_timeReminder);
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}
