import 'package:flutter/material.dart';
import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/model/setting.dart';
import 'package:mobileinpact/services/rss.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({
    Key? key,
    required this.buildChild,
  }) : super(key: key);

  final Function buildChild;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late List<Article> articles;
  bool isLoading = true;

  static bool firstRun = true;

  Future refreshArticles() async {
    setState(() => isLoading = true);
    articles = await ArticlesDatabase.instance.getAllArticlesSummaries();
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
                child: widget.buildChild(articles),
              ));
  }
}
