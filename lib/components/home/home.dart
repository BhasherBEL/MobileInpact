import 'package:flutter/material.dart';
import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/services/rss.dart';

import 'article_item.dart';
import 'time_elapsed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        child: isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  addAutomaticKeepAlives: false,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                        width: double.infinity,
                        height: 30,
                        child: Center(
                          child: TimeElapsed(),
                        ),
                      );
                    else
                      return ArticleItem(articles[index - 1]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: HSLColor.fromColor(Theme.of(context).primaryColor)
                          .withLightness(0.5)
                          .toColor(),
                    );
                  },
                  itemCount: articles.length + 1,
                ),
              ));
  }
}
