import 'package:flutter/material.dart';
import 'package:mobileinpact/services/shared_prefs.dart';

enum SettingType {
  Text,
  Switch;
}

enum Setting {
  rssUrl('rssUrl', SettingType.Text, Icons.rss_feed, 'RSS feed URL', ''),
  theme('theme', SettingType.Switch, Icons.dark_mode_sharp, 'Dark mode', true,
      enabled: false),
  fetchOnStartup('fetchOnStartup', SettingType.Switch, Icons.cloud_download,
      'Fetch on startup', false),
  autoFetch('autoFetch', SettingType.Switch, Icons.downloading,
      'Auto fetch every hour', false,
      enabled: false);

  const Setting(this.name, this.type, this.icon, this.text, this.defaultValue,
      {this.enabled = true});

  final String name;
  final IconData icon;
  final SettingType type;
  final String text;
  final Object defaultValue;
  final bool enabled;

  Object get() {
    return SharedPrefs().instance.get(name) ?? defaultValue;
  }

  Future<bool> setString(String value) async {
    return SharedPrefs().instance.setString(name, value);
  }

  Future<bool> setBool(bool state) async {
    return SharedPrefs().instance.setBool(name, state);
  }
}
