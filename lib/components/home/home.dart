import 'package:flutter/material.dart';
import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/services/rss.dart';

import 'article_item.dart';

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
