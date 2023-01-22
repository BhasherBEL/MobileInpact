import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/services/time.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../db/articles_database.dart';

class ArticleItem extends StatefulWidget {
  const ArticleItem(this.article, {super.key});

  final Article article;

  @override
  State<ArticleItem> createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: CachedNetworkImage(
        width: 80,
        height: 60,
        fit: BoxFit.cover,
        imageUrl: widget.article.imageUrl!,
        placeholder: ((context, url) => CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            Image.asset('assets/default-leading.jpg', fit: BoxFit.cover),
      ),
      title: Text(
        widget.article.title,
        maxLines: 3,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      subtitle: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.access_time_sharp,
              color: Colors.grey,
            ),
          ),
          Text(timeElapsed(widget.article.pubDate))
        ],
      ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ArticleScreen(articleId: widget.article.id!)))
      },
    );
  }
}

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key, required this.articleId});

  final int articleId;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late Article? article;
  bool isLoading = false;

  Future loadArticle() async {
    setState(() => isLoading = true);
    article = await ArticlesDatabase.instance.getArticleById(widget.articleId);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    loadArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? null
            : article == null || article!.content == null
                ? const Text("No content found")
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          article!.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(timeElapsed(article!.pubDate)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CachedNetworkImage(
                          imageUrl: article!.imageUrl!,
                          placeholder: ((context, url) =>
                              CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                              'assets/default-leading.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                      Html(
                        data: article!.content!,
                        style: {
                          'p': Style(
                              textAlign: TextAlign.justify,
                              lineHeight: LineHeight.percent(120),
                              fontSize: FontSize.large),
                        },
                        onLinkTap: (url, context, attributes, element) async {
                          if (url == null) return;
                          if (await canLaunchUrlString(url))
                            launchUrlString(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                        },
                      ),
                    ],
                  )),
      ),
    );
  }
}
