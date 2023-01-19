import 'package:flutter/material.dart';

import '../../model/setting.dart';

class SwitchSetting extends StatefulWidget {
  const SwitchSetting({
    Key? key,
    required this.setting,
  }) : super(key: key);

  final Setting setting;

  @override
  State<SwitchSetting> createState() => _SwitchSettingState();
}

class _SwitchSettingState extends State<SwitchSetting> {
  bool currentState = false;

  Future refreshState() async {
    currentState = (await widget.setting.get()) as bool;
    setState(
      () => currentState = currentState,
    );
  }

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  void save(bool state) {
    if (!widget.setting.enabled) return;
    widget.setting.setBool(state);
    setState(
      () => currentState = state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          Text(
            widget.setting.text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (!widget.setting.enabled)
            Text(' (disabled)', style: TextStyle(fontStyle: FontStyle.italic)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Switch(
                  value: currentState,
                  onChanged: save,
                  activeColor: (widget.setting.enabled
                          ? Colors.tealAccent
                          : Color(0xFF424242))
                      .withOpacity(0.5),
                  activeTrackColor: widget.setting.enabled
                      ? Colors.tealAccent
                      : Color(0xFF616161),
                  inactiveTrackColor:
                      widget.setting.enabled ? Colors.grey : Color(0xFF616161),
                  inactiveThumbColor:
                      (widget.setting.enabled ? Colors.grey : Color(0xFF424242))
                          .withOpacity(0.5),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
