import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  final SharedPreferences _prefs;

  final String _timer = 'timer';
  final String _timeReminder = 'timeReminder';
  final String _enableReminder = 'enableReminder';

  final String _enableReminderSun = 'enableReminderSun';
  final String _enableReminderMon = 'enableReminderMon';
  final String _enableReminderTues = 'enableReminderTues';
  final String _enableReminderWed = 'enableReminderWed';
  final String _enableReminderThus = 'enableReminderThus';
  final String _enableReminderFri = 'enableReminderFri';
  final String _enableReminderSat = 'enableReminderSat';

  final String _isPremiumMember = 'isPremiumMember';
  final String _isSubscriptionActive = '_subscribeActive';

  AppCache(this._prefs);

  Future<void> enablePremiumMember(bool enable) async {
    _prefs.setBool(_isPremiumMember, enable);
  }

  bool isLifetimePremium() {
    return _prefs.getBool(_isPremiumMember) ?? false;
  }

  Future<void> activeSubscription(bool active) async {
    _prefs.setBool(_isSubscriptionActive, active);
  }

  bool isSubscriptionActive() {
    return _prefs.getBool(_isSubscriptionActive) ?? false;
  }

  bool isPremiumMember() {
    if (_prefs.getBool(_isPremiumMember) == true) {
      return true;
    } else {
      return isSubscriptionActive();
    }
  }

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

  Future<void> enableReminder(bool enable) async {
    _prefs.setBool(_enableReminder, enable);
  }

  bool isEnableReminder() {
    return _prefs.getBool(_enableReminder) ?? false;
  }

  Future<void> enableReminderFor(String day, bool enable) async {
    switch (day) {
      case "Sun":
        {
          _prefs.setBool(_enableReminderSun, enable);
          break;
        }
      case "Mon":
        {
          _prefs.setBool(_enableReminderMon, enable);
          break;
        }
      case "Tues":
        {
          _prefs.setBool(_enableReminderTues, enable);
          break;
        }
      case "Wed":
        {
          _prefs.setBool(_enableReminderWed, enable);
          break;
        }
      case "Thus":
        {
          _prefs.setBool(_enableReminderThus, enable);
          break;
        }
      case "Fri":
        {
          _prefs.setBool(_enableReminderFri, enable);
          break;
        }
      case "Sat":
        {
          _prefs.setBool(_enableReminderSat, enable);
          break;
        }
    }
  }

  bool isEnableDayForReminder(String day) {
    switch (day) {
      case "Sun":
        {
          return _prefs.getBool(_enableReminderSun) ?? true;
        }
      case "Mon":
        {
          return _prefs.getBool(_enableReminderMon) ?? true;
        }
      case "Tues":
        {
          return _prefs.getBool(_enableReminderTues) ?? true;
        }
      case "Wed":
        {
          return _prefs.getBool(_enableReminderWed) ?? true;
        }
      case "Thus":
        {
          return _prefs.getBool(_enableReminderThus) ?? true;
        }
      case "Fri":
        {
          return _prefs.getBool(_enableReminderFri) ?? true;
        }
      case "Sat":
        {
          return _prefs.getBool(_enableReminderSat) ?? true;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}
