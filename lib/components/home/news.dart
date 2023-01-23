import 'package:flutter/material.dart';
import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/model/setting.dart';
import 'package:mobileinpact/services/rss.dart';

import 'article_item.dart';
import 'time_elapsed.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({
    Key? key,
    required this.filter,
  }) : super(key: key);

  final List<Article> Function(List<Article>) filter;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late List<Article> articles;
  bool isLoading = false;

  static bool firstRun = true;

  Future refreshArticles() async {
    setState(() => isLoading = true);
    articles = widget
        .filter(await ArticlesDatabase.instance.getAllArticlesSummaries());
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    refreshArticles();
    if (Setting.fetchOnStartup.get() as bool && firstRun) onRefresh();
    firstRun = false;
  }

  Future<void> onRefresh() async {
    String? result = await fetchItems();

    // if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result == null
          ? 'Items fetched with success'
          : 'Error while fetching items: $result'),
    ));
    if (result == null) await refreshArticles();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: onRefresh,
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
                    return Divider();
                  },
                  itemCount: articles.length + 1,
                ),
              ));
  }
}
