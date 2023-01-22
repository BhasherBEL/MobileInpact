import 'package:flutter/material.dart';

import '../../model/setting.dart';
import '../../services/delay.dart';

class TextSetting extends StatefulWidget {
  TextSetting({
    Key? key,
    required this.setting,
  }) : super(key: key);

  final Setting setting;

  @override
  State<TextSetting> createState() => _TextSettingState();
}

class _TextSettingState extends State<TextSetting> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = (widget.setting.get()) as String;
    super.initState();
  }

  void save(String value) {
    widget.setting.setString(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          widget.setting.text,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: controller,
        onChanged: (v) => debounce(const Duration(seconds: 1), save, [v]),
        autocorrect: false,
        decoration: InputDecoration(border: OutlineInputBorder()),
      )
    ]);
  }
}
