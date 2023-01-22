import 'dart:convert';

import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:http/http.dart';
import 'package:mobileinpact/model/setting.dart';
import 'package:mobileinpact/services/internal_data.dart';
import 'package:webfeed/domain/rss_feed.dart';

Future<int> fetchItems() async {
  String url = Setting.rssUrl.get() as String;
  try {
    Uri uri = Uri.parse(url);
    final response = await get(uri);
    if (response.statusCode != 200) return 0;

    final decoded = RssFeed.parse(utf8.decode(response.bodyBytes));

    if (decoded.items == null) return 0;

    final items =
        await Future.wait(decoded.items!.map((e) => Article.fromRssItem(e)));

    InternalData.lastUpdate = DateTime.now();

    return items
        .map((e) => ArticlesDatabase.instance.insertIfNotExist(e))
        .toList()
        .length;
  } catch (e) {
    return 0;
  }
}
