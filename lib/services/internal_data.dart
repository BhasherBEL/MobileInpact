import 'package:mobileinpact/services/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InternalData {
  static SharedPreferences _instance = SharedPrefs().instance;

  static DateTime get lastUpdate =>
      DateTime.fromMillisecondsSinceEpoch(_instance.getInt('lastUpdate') ?? 0);

  static set lastUpdate(DateTime dateTime) {
    _instance.setInt('lastUpdate', dateTime.millisecondsSinceEpoch);
  }
}
