import 'dart:convert';

import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:http/http.dart';
import 'package:webfeed/domain/rss_feed.dart';

const String rssUrl = '[RSS URL HERE]';

Future<int> fetchItems() async {
  final response = await get(Uri.parse(rssUrl));
  if (response.statusCode != 200) return 0;

  final decoded = RssFeed.parse(utf8.decode(response.bodyBytes));

  if (decoded.items == null) return 0;

  final items =
      await Future.wait(decoded.items!.map((e) => Article.fromRssItem(e)));

  return items
      .map((e) => ArticlesDatabase.instance.insertIfNotExist(e))
      .toList()
      .length;
}
