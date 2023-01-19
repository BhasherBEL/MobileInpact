import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:mobileinpact/services/time.dart';

import '../../db/articles_database.dart';

class ArticleItem extends StatelessWidget {
  const ArticleItem(this.article, {super.key});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: article.image == null
          ? article.imageUrl != null
              ? Image.network(article.imageUrl!, width: 80, fit: BoxFit.fill)
              : Image.asset('assets/default-leading.jpg',
                  width: 80, fit: BoxFit.fill)
          : Image.memory(article.image!, width: 80, fit: BoxFit.fill),
      title: Text(
        article.title,
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
          Text(timeElapsed(article.pubDate))
        ],
      ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ArticleScreen(articleId: article.id!)))
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
                        child: article!.imageUrl != null
                            ? Image.network(article!.imageUrl!)
                            : Image.asset('assets/default-leading.jpg'),
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
                          // if (await canLaunchUrlString(url)) {
                          // await launchUrlString(url,
                          //     mode: LaunchMode.externalApplication);
                          // }
                        },
                      ),
                    ],
                  )),
      ),
    );
  }
}
