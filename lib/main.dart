import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:mobileinpact/components/article_item.dart';
import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/services/rss.dart';
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

class ReadLater extends StatelessWidget {
  const ReadLater({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Article> articles;
  bool isLoading = false;

  Future refreshArticles() async {
    setState(() => isLoading = true);
    articles = await ArticlesDatabase.instance.getAllArticlesSummaries();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    refreshArticles();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          int result = await fetchItems();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result > 0
                ? '$result items fetched with success'
                : 'Error while fetching items'),
          ));
          refreshArticles();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  addAutomaticKeepAlives: false,
                  itemBuilder: (context, index) {
                    return ArticleItem(articles[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: HSLColor.fromColor(Theme.of(context).primaryColor)
                          .withLightness(0.5)
                          .toColor(),
                    );
                  },
                  itemCount: articles.length,
                ),
        ));
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
