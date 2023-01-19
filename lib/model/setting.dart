import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SettingType {
  Text,
  Switch;
}

enum Setting {
  rssUrl('rssUrl', SettingType.Text, Icons.rss_feed, 'RSS feed URL', ''),
  theme('theme', SettingType.Switch, Icons.dark_mode_sharp, 'Dark mode', true,
      enabled: false);

  const Setting(this.name, this.type, this.icon, this.text, this.defaultValue,
      {this.enabled = true});

  final String name;
  final IconData icon;
  final SettingType type;
  final String text;
  final Object defaultValue;
  final bool enabled;

  Future get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(name) ?? defaultValue;
  }

  Future<bool> setString(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(name, value);
  }

  Future<bool> setBool(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(name, state);
  }
}
