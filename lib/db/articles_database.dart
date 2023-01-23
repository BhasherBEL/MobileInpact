import 'package:path/path.dart';
import 'package:mobileinpact/model/article.dart';
import 'package:sqflite/sqflite.dart';

class ArticlesDatabase {
  static final ArticlesDatabase instance = ArticlesDatabase._init();

  static Database? _database;

  ArticlesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('articles.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableArticles (
  ${ArticleFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${ArticleFields.hidden} BOOLEAN NOT NULL,
  ${ArticleFields.title} INTEGER NOT NULL,
  ${ArticleFields.link} TEXT NOT NULL,
  ${ArticleFields.pubDate} INTEGER NOT NULL,
  ${ArticleFields.imageUrl} TEXT,
  ${ArticleFields.image} TEXT,
  ${ArticleFields.content} TEXT
)
''');
  }

  Future close() async {
    if (_database != null) {
      final db = await instance.database;
      db.close();
    }
  }

  Future<Article> insert(Article article) async {
    final db = await instance.database;
    final id = await db.insert(tableArticles, article.toJson());
    return article.copy(id: id);
  }

  Future<Article?> getArticle(String title, DateTime pubDate) async {
    final db = await instance.database;
    final articles = await db.query(tableArticles,
        columns: ArticleFields.values,
        where: '${ArticleFields.title} = ? AND ${ArticleFields.pubDate} = ?',
        whereArgs: [title, pubDate.millisecondsSinceEpoch]);

    if (articles.isNotEmpty) return Article.fromJson(articles.first);
    return null;
  }

  Future<Article?> getArticleById(int id) async {
    final db = await instance.database;
    final articles = await db.query(tableArticles,
        columns: ArticleFields.values,
        where: '${ArticleFields.id} = ?',
        whereArgs: [id]);

    if (articles.isNotEmpty) return Article.fromJson(articles.first);
    return null;
  }

  Future<Article?> insertIfNotExist(Article article) async {
    Article? candidate = await getArticle(article.title, article.pubDate);

    if (candidate != null) {
      return candidate;
    } else {
      return insert(article);
    }
  }

  Future<List<Article>> getAllArticlesSummaries() async {
    final db = await instance.database;
    final articles = await db.query(tableArticles,
        columns: [
          ArticleFields.id,
          ArticleFields.link,
          ArticleFields.title,
          ArticleFields.pubDate,
          ArticleFields.imageUrl
        ],
        orderBy: '${ArticleFields.pubDate} DESC');

    return articles.map((e) => Article.fromShortJson(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableArticles,
        where: '${ArticleFields.id} = ?', whereArgs: [id]);
  }
}
