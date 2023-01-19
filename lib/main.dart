import 'package:flutter/material.dart';
import 'package:mobileinpact/components/home/home.dart';
import 'package:mobileinpact/components/read_later/read_later.dart';
import 'package:mobileinpact/components/settings/settings.dart';
import 'package:wakelock/wakelock.dart';

var secondaryColor = Colors.blue.shade300;

void main() {
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

class _MainState extends State<Main> {
  int _currentIndex = 1;

  final List<Widget> _pages = const <Widget>[ReadLater(), Home(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logo-nxi.png'),
          width: 200,
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: secondaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Read Later',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
