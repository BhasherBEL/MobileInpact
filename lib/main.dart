import 'package:flutter/material.dart';
import 'package:mobileinpact/components/home/all_news_list.dart';
import 'package:mobileinpact/components/home/articles_news_list.dart';
import 'package:mobileinpact/components/home/drawer_menu.dart';
import 'package:mobileinpact/components/home/flock_news_list.dart';
import 'package:mobileinpact/components/home/lebrief_news_list.dart';
import 'package:mobileinpact/components/home/news.dart';
import 'package:mobileinpact/services/colors.dart';
import 'package:mobileinpact/services/shared_prefs.dart';
import 'package:wakelock/wakelock.dart';

var secondaryColor = Colors.blue.shade300;
var backgroundColor = Color(0xFF202020);

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
        primaryColor: Color(0xFF6E1616),
        // ignore: deprecated_member_use
        accentColor: const Color(0xFF115291),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6E1616),
        ),
        scaffoldBackgroundColor: backgroundColor,
        drawerTheme: DrawerThemeData(backgroundColor: backgroundColor),
        dividerColor: backgroundColor.lighten(0.2),
      ),
      home: Main(page: Pages.allNewsPage),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    Key? key,
    required this.page,
  }) : super(key: key);

  final Pages page;

  @override
  State<Main> createState() => _MainState();
}

class Pages {
  Pages(this.label, this.icon, this.screen);

  final String label;
  final IconData icon;
  final Widget screen;

  static Pages allNewsPage = Pages(
    'All News',
    Icons.home,
    NewsScreen(
      buildChild: (articles) => AllNewsList(allArticles: articles),
    ),
  );
  static Pages articlesPage = Pages(
    'Articles',
    Icons.newspaper,
    NewsScreen(
      buildChild: (articles) => ArticlesNewsList(allArticles: articles),
    ),
  );
  static Pages leBriefPage = Pages(
    '#Le Brief',
    Icons.free_breakfast,
    NewsScreen(
      buildChild: (articles) => LeBriefNewsList(allArticles: articles),
    ),
  );
  static Pages flockPage = Pages(
    'Flock',
    Icons.draw,
    NewsScreen(
      buildChild: (articles) => FlockNewsList(allArticles: articles),
    ),
  );

  static List<Pages> pages = [
    allNewsPage,
    articlesPage,
    leBriefPage,
    flockPage,
  ];
}

class _MainState extends State<Main> {
  late Pages page;

  void updateBody(Pages p) {
    setState(() {
      page = p;
    });
  }

  @override
  void initState() {
    page = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Image(
          image: AssetImage('assets/logo-nxi.png'),
          width: 200,
        ),
      ),
      body: page.screen,
      drawer: DrawerMenu(updateBody),
    );
  }
}
