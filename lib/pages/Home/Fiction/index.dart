/**
 * 小说组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/05 22:47:10
 */
import 'package:flutter/material.dart';
import './item.dart';
import 'package:intimate_couple/model/book.dart';
import 'package:intimate_couple/sqlite/book.dart';
import 'package:intimate_couple/pages/Library/index.dart';
import 'package:intimate_couple/utils/events.dart';
import 'package:intimate_couple/apis/book.dart';

class Fiction extends StatefulWidget {
  @override
  _FictionState createState() => _FictionState();
}
class _FictionState extends State<Fiction> {
  // 图书列表
  List<Book> _books = [];
  BookSqlite _bookSqlite = new BookSqlite();
  @override
  void initState() {
    /// 监听添加eventBus
    eventBus.on<InsertBook>().listen((event) {
      _bookSqlite.insertBook(event.book).then((value) {
        _getSelfBooks();
      });
    });
    // 监听更新图书
    eventBus.on<UpdateBook>().listen((event) {
      _bookSqlite.updateById(
        id: event.id,
        values: event.values
      ).then((row) {
        print(row);
        _getSelfBooks();
      });
    });
    super.initState();
    // 获取我的书架的书
    _getSelfBooks().then((books) {
      _updateBookData(books);
    });
  }
  _getSelfBooks() async {
    // 清空书架
    _books.clear();
    final books = await _bookSqlite.queryAll();
    if (books != null) {
      print('书架上有${books.length}本书');
      setState(() {
        _books.addAll(books);
      });
    }
    return books;
  }
  /// 更新书本
  Future _updateBookData(List<Book> books) async{
    try {
      for (Book book in books) {
        final Map tempBook = await getInfoData(book.id);
        if (tempBook['data'] != null) {
          final data = tempBook['data'];
          await _bookSqlite.updateById(
            id: book.id,
            values: {
              'LastChapter': data['LastChapter'],
              'LastChapterId':data['LastChapterId'],
              'LastTime':data['LastTime']
            }
          );
        }
      }
      _getSelfBooks();
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '书架',
          style: TextStyle(
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.library_books,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Library()
                )
              );
            },
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (BuildContext context, int index) {
            return FictonItem(
              book: _books[index]
            );
          },
        ),
      ),
    );
  }
}
