/**
 * 图书模型
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 09:50:09
 */
import 'package:intimate_couple/utils/utils.dart';
class Book {
  /// 书id
  int id;
  /// 书名
  String name;
  /// 作者
  String author;
  /// 封面
  String img;
  /// 描述
  String desc;
  /// 书状态
  String bookStatus;
  // 分类名称
  String cname;
  /// 最后章节id
  String lastChapterId;
  /// 最后章节
  String lastChapter;
  /// 更新时间
  String lastTime;
  /// 书评分
  final Map bookVote;
  /// 同作者下的小说
  final List sameUserBooks;
  /// 类似的小说
  final List sameCategoryBooks;
  /// 第一章id
  final String firstChapterId;
  /// 历史浏览章节记录
  String historyChapterId;
  /// 历史浏览页数
  int historyChapterPage;
  Book({
    this.id,
    this.name,
    this.author,
    this.img,
    this.desc,
    this.bookStatus,
    this.lastChapterId,
    this.lastChapter,
    this.lastTime,
    this.cname,
    this.bookVote,
    this.sameUserBooks,
    this.sameCategoryBooks,
    this.historyChapterId,
    this.historyChapterPage,
    this.firstChapterId
  });
  /// map转化成book
  /// 返回book数组
  static Book fromMap(Map<String, dynamic> map) {
    // 判断是否为null
    if (map == null) return null;
    Book book = Book(
      id: int.parse(map['Id'].toString()),
      name: map['Name'] ?? '',
      author: map['Author'] ?? '',
      img: getCompleteImgUrl(map['Img']) ?? '',
      desc: map['Desc'] ?? '',
      cname: map['CName'] ?? '',
      bookStatus: map['BookStatus'] ?? '',
      lastChapter: map['LastChapter'] ?? '',
      lastChapterId: map['LastChapter'] ?? '',
      bookVote: map['BookVote'] ?? Map(),
      sameUserBooks: map['SameUserBooks'] ?? List(),
      sameCategoryBooks: map['SameCategoryBooks'] ?? List(),
      firstChapterId: map['FirstChapterId'].toString() ?? '',
      lastTime: map['LastTime'] ?? '',
      historyChapterId: map['HistoryChapterId'] ?? null,
      historyChapterPage: map['HistoryChapterPage'] ?? 1,
    );
    return book;
  }
}