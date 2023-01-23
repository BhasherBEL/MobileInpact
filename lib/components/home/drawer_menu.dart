import 'package:flutter/material.dart';
import 'package:mobileinpact/components/settings/settings.dart';
import 'package:mobileinpact/main.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu(this.updateBody, {super.key});

  final void Function(Pages page)? updateBody;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/nxix-favicon2.png',
                  height: 80,
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter - const Alignment(0, 0.2),
                  child: Text(
                    "Mobile Inpact",
                    style: const TextStyle(fontSize: 20),
                  )),
            ],
          )),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                      leading: Icon(Pages.pages[index].icon),
                      title: Text(Pages.pages[index].label),
                      onTap: () {
                        if (updateBody != null) updateBody!(Pages.pages[index]);
                        Navigator.pop(context);
                      },
                    ),
                itemCount: Pages.pages.length),
            flex: 1,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text("Settings"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
