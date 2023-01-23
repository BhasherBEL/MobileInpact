import 'package:flutter/material.dart';
import 'package:mobileinpact/model/article.dart';

import 'article_item.dart';
import 'time_elapsed.dart';

class FlockNewsList extends StatelessWidget {
  const FlockNewsList({super.key, required this.allArticles});

  final List<Article> allArticles;

  @override
  Widget build(BuildContext context) {
    final List<Article> articleArticles =
        allArticles.where((element) => element.pubDate.weekday == 6).toList();
    return ListView.separated(
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
          return ArticleItem(articleArticles[index - 1]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: articleArticles.length + 1,
    );
  }
}
