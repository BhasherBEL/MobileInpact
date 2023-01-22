import 'package:flutter/material.dart';
import 'package:mobileinpact/components/home/home.dart';
import 'package:mobileinpact/components/settings/settings.dart';
import 'package:mobileinpact/services/shared_prefs.dart';
import 'package:wakelock/wakelock.dart';

var secondaryColor = Colors.blue.shade300;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs().init();
  runApp(const MobileImpactApp());
}

class MobileImpactApp extends StatelessWidget {
  const MobileImpactApp({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF831C1C),
        // ignore: deprecated_member_use
        accentColor: const Color(0xFF115291),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF831C1C),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF831C1C),
        ),
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    Key? key,
  }) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

enum Pages {
  // ReadLater('Read Later', Icons.watch_later, ReadLaterScreen()),
  Home('Home', Icons.home, HomeScreen()),
  Settings('Settings', Icons.settings, SettingsScreen());

  const Pages(this.label, this.icon, this.screen);

  final String label;
  final IconData icon;
  final Widget screen;

  static int defaultIndex = Pages.values.indexOf(Pages.Home);
}

class _MainState extends State<Main> {
  int _currentIndex = Pages.defaultIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logo-nxi.png'),
          width: 200,
        ),
      ),
      body: Pages.values[_currentIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: secondaryColor,
        items: Pages.values
            .map((e) =>
                BottomNavigationBarItem(icon: Icon(e.icon), label: e.label))
            .toList(),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
