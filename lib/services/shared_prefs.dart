import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();

  SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get instance => _sharedPrefs;
}
