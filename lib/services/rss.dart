import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobileinpact/db/articles_database.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:http/http.dart';
import 'package:mobileinpact/model/setting.dart';
import 'package:mobileinpact/services/internal_data.dart';
import 'package:webfeed/domain/rss_feed.dart';

Future<String?> fetchItems() async {
  String url = Setting.rssUrl.get() as String;
  try {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw SocketException('');
    }

    Uri uri = Uri.parse(url);
    final response = await get(uri);
    if (response.statusCode != 200) return 'Error ${response.statusCode}';

    final decoded = RssFeed.parse(utf8.decode(response.bodyBytes));

    if (decoded.items == null) return 'Unable to parse feed';

    final items =
        await Future.wait(decoded.items!.map((e) => Article.fromRssItem(e)));

    InternalData.lastUpdate = DateTime.now();

    items
        .map((e) => ArticlesDatabase.instance.insertIfNotExist(e))
        .toList()
        .length;
    return null;
  } on FormatException {
    return 'Invalid URL';
  } catch (e) {
    return '$e';
  }
}
