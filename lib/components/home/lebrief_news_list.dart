import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/services/time.dart';

import 'article_item.dart';
import 'time_elapsed.dart';
import '../../services/colors.dart';

class LeBriefNewsList extends StatelessWidget {
  const LeBriefNewsList({super.key, required this.allArticles});

  final List<Article> allArticles;

  @override
  Widget build(BuildContext context) {
    final List<Article> leBriefArticles = allArticles
        .where((element) =>
            element.link != null && element.link!.contains('lebrief'))
        .toList();

    final List<Widget> listItems = [
      Container(
        width: double.infinity,
        height: 30,
        child: Center(
          child: TimeElapsed(),
        ),
      ),
    ];

    String last = "";
    for (Article leBriefArticle in leBriefArticles) {
      String current = getStringDate(leBriefArticle.pubDate);

      if (current != last) {
        last = current;
        listItems.add(
          ListTile(
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '#',
                    style: TextStyle(
                        color: Colors.orange, fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: 'LeBrief',
                    style: TextStyle(
                        color: Colors.lightBlue.lighten(0.1),
                        fontStyle: FontStyle.italic),
                  ),
                  TextSpan(
                    text: " of " + daysElapsed(leBriefArticle.pubDate),
                  ),
                ],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.em(20).size,
                ),
              ),
            ),
          ),
        );
      }

      listItems.add(ArticleItem(leBriefArticle));
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) => listItems[index],
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: listItems.length,
    );
  }
}
