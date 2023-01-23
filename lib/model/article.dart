import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webfeed/domain/rss_item.dart';

const String tableArticles = 'articles';

class ArticleFields {
  static const values = [
    id,
    hidden,
    title,
    link,
    pubDate,
    imageUrl,
    image,
    content
  ];

  static const String id = '_id';
  static const String hidden = 'hidden';
  static const String title = 'title';
  static const String link = 'link';
  static const String pubDate = 'pubDate';
  static const String imageUrl = 'imageUrl';
  static const String image = 'image';
  static const String content = 'content';
}

class Article {
  const Article({
    this.id,
    required this.title,
    this.link,
    required this.pubDate,
    this.hidden = false,
    this.imageUrl,
    this.image,
    this.content,
  });

  final int? id;
  final bool hidden;
  final String title;
  final String? link;
  final DateTime pubDate;
  final String? imageUrl;
  final Uint8List? image;
  final String? content;

  Map<String, Object?> toJson() => {
        ArticleFields.id: id,
        ArticleFields.hidden: hidden ? 1 : 0,
        ArticleFields.title: title,
        ArticleFields.link: link,
        ArticleFields.pubDate: pubDate.millisecondsSinceEpoch,
        ArticleFields.imageUrl: imageUrl,
        ArticleFields.image: image == null ? '' : base64.encode(image!),
        ArticleFields.content: content ?? ''
      };

  Article copy({
    int? id,
    bool? hidden,
    String? title,
    String? link,
    DateTime? pubDate,
    String? imageUrl,
    Uint8List? image,
    String? creator,
    String? content,
  }) {
    return Article(
        id: id ?? this.id,
        hidden: hidden ?? this.hidden,
        title: title ?? this.title,
        link: link ?? this.link,
        pubDate: pubDate ?? this.pubDate,
        imageUrl: imageUrl ?? this.imageUrl,
        image: image ?? this.image,
        content: content ?? this.content);
  }

  static Article fromJson(Map<String, Object?> json) {
    return Article(
      id: json[ArticleFields.id] as int?,
      hidden: json[ArticleFields.hidden] == 1,
      title: json[ArticleFields.title] as String,
      link: json[ArticleFields.link] as String?,
      pubDate: DateTime.fromMillisecondsSinceEpoch(
          json[ArticleFields.pubDate] as int),
      imageUrl: json[ArticleFields.imageUrl] as String?,
      image: (json[ArticleFields.image] as String?) == null
          ? null
          : base64.decode(json[ArticleFields.image] as String),
      content: json[ArticleFields.content] as String?,
    );
  }

  static Future<Article> fromRssItem(RssItem item) async {
    return Article(
      title: item.title ?? 'No title',
      pubDate: item.pubDate ?? DateTime.now(),
      link: item.link,
      imageUrl: item.enclosure != null ? item.enclosure!.url : null,
      // image: item.enclosure != null && item.enclosure!.url != null
      //     ? (await NetworkAssetBundle(Uri.parse(item.enclosure!.url!))
      //             .load(item.enclosure!.url!))
      //         .buffer
      //         .asUint8List()
      //     : null,
      content: item.description,
    );
  }

  static Article fromShortJson(Map<String, Object?> json) {
    return Article(
      id: json[ArticleFields.id] as int,
      link: json[ArticleFields.link] as String,
      title: json[ArticleFields.title] as String,
      imageUrl: json[ArticleFields.imageUrl] as String,
      pubDate: DateTime.fromMillisecondsSinceEpoch(
          json[ArticleFields.pubDate] as int),
    );
  }
}
