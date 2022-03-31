/**
 * 数据库操作
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 10:21:11
 */
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intimate_couple/model/book.dart';
/// 数据库表名
const String table = 'book';
/// id列
const String columnId = 'Id';
/// 名称列
const String columnName = 'Name';
/// 作者列
const String columnAuthor = 'Author';
/// 图片列
const String columnImg = 'Img';
/// 描述列
const String columnDesc = 'Desc';
/// 状态列
const String columnBookStatus = 'BookStatuc';
/// 最后章节id列
const String columnLastChapterId = 'LastChapterId';
/// 最后章节列
const String columnLastChapter = 'LastChapter';
/// 更新事件列
const String columnLastTime = 'LastTime';
/// 第一章id
const String columnFirstChapterId = 'FirstChapterId';
/// 历史浏览章节
const String columnHistoryChapterId = 'HistoryChapterId';
/// 历史页面
const String columnHistoryPage = 'HistoryPage';
class BookSqlite {
  Database db;
  _openSqlite() async {
    // 获取本地数据位置
    final databasesPath = await getDatabasesPath();
    // 将数据库和路径合并
    String path = join(databasesPath, 'bookdb.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName VARCHAR(250),
            $columnAuthor VARCHAR(250),
            $columnBookStatus VARCHAR(250),
            $columnDesc TEXT,
            $columnImg VARCHAR(250),
            $columnLastChapterId VARCHAR(250),
            $columnLastChapter VARCHAR(250),
            $columnLastTime VARCHAR(250),
            $columnFirstChapterId VARCHAR(250),
            $columnHistoryChapterId VARCHAR(250),
            $columnHistoryPage VARCHAR(100)
          )
        ''');
      }
    );
  }
  /// 插入一条
  Future insert(Map map) async {
    await this._openSqlite();
    return await db.insert(table, {
      columnId: map[columnId],
      columnName: map[columnName],
      columnAuthor: map[columnAuthor],
      columnBookStatus: map[columnBookStatus],
      columnDesc:map[columnDesc],
      columnImg: map[columnImg],
      columnLastChapterId: map[columnLastChapterId],
      columnLastChapter:map[columnLastChapter],
      columnLastTime: map[columnLastTime],
      columnFirstChapterId: map[columnFirstChapterId],
      columnHistoryChapterId: map[columnHistoryChapterId],
      columnHistoryPage: map[columnHistoryPage]
    });
  }
  /// 插入书本
  Future insertBook(Book book) async {
    await this._openSqlite();
    return await db.insert(table, {
      columnId: book.id,
      columnName: book.name,
      columnAuthor: book.author,
      columnBookStatus: book.bookStatus,
      columnDesc: book.desc,
      columnImg: book.img,
      columnLastChapterId: book.lastChapterId,
      columnLastChapter: book.lastChapter,
      columnLastTime: book.lastTime,
      columnFirstChapterId: book.firstChapterId,
      columnHistoryChapterId: book.historyChapterId ?? 0,
      columnHistoryPage: book.historyChapterPage ?? 1
    });
  }
  /// 查询所有
  Future<List<Book>> queryAll() async {
    await this._openSqlite();
    List<Map> maps = await db.query(table, columns: [
      columnId,
      columnName,
      columnAuthor,
      columnImg,
      columnDesc,
      columnBookStatus,
      columnLastChapterId,
      columnLastChapter,
      columnLastTime,
      columnFirstChapterId,
      columnHistoryChapterId,
      columnHistoryPage
    ]);
    if (maps == null || maps.length == 0) {
      return null;
    }
    print(maps.toString());
    List<Book> books = List.generate(
      maps.length,
      (int index) => Book.fromMap(maps[index])
    );
    return books;
  }
  /// 通过id查找
  Future<Book> queryById<T>(T id) async{
    await this._openSqlite();
    List<Map> maps =await db.query(table, columns: [
      columnId,
      columnName,
      columnAuthor,
      columnImg,
      columnDesc,
      columnBookStatus,
      columnLastChapterId,
      columnLastChapter,
      columnLastTime,
      columnFirstChapterId,
      columnHistoryChapterId,
      columnHistoryPage
    ],
      where: '$columnId = ?',
      whereArgs: [id]
    );
    if (maps.length > 0) {
      return Book.fromMap(maps.first);
    }
    return null;
  }
  /// 更新book
  Future<int> updateById<T>({T id, Map<String, dynamic> values}) async{
    await this._openSqlite();
    return await db.update(
      table,
      values,
      where: '$columnId = ?',
      whereArgs: [id]
    );
  }
}