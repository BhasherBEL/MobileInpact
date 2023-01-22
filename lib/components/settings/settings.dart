import 'package:flutter/material.dart';
import 'package:mobileinpact/model/setting.dart';

import 'text_setting.dart';
import 'switch_setting.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        itemBuilder: (content, index) {
          Setting setting = Setting.values.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Icon(
                      setting.icon,
                      size: 40,
                    )),
                Expanded(
                    flex: 5,
                    child: {
                      SettingType.Text: TextSetting(
                        setting: setting,
                      ),
                      SettingType.Switch: SwitchSetting(
                        setting: setting,
                      )
                    }[setting.type]!),
              ],
            ),
          );
        },
        itemCount: Setting.values.length,
      ),
    );
  }
}
