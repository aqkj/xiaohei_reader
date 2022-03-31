/**
 * 更多列表
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/07 14:13:01
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/apis/book.dart';
import 'package:intimate_couple/pages/Library/Catetory/GenderBookItem.dart';
class MoreList extends StatefulWidget {
  final int index;
  final String name;
  final String gender;
  MoreList({
    @required this.index,
    @required this.name,
    @required this.gender
  });
  @override
  _MoreListState createState() => _MoreListState();
}

class _MoreListState extends State<MoreList> {
  List<dynamic> books = [];
  static const List<String> _kind = ['new', 'hot', 'commend', 'over'];
  int _page = 0;
  /// 是否加载中
  bool _isLoading = false;
  /// 是否加载完成
  bool _isFinish = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _getBookList();
    _scrollController.addListener(() {
      /// 判断当前位置是否为最大位置
      if (_scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 30) &&
        !_isLoading &&
        !_isFinish) {
        _isLoading = true;
        // 更新数据
        _getBookList().whenComplete(() {
          _isLoading = false;
        });
      }
    });
  }
  Future<void> _getBookList() async{
    try {
      _page++;
      final result = await getRankData(widget.gender, _kind[widget.index], 'week', _page);
      if (result != null && result['data'].length > 0) {
        print('请求数量: ' + result['data']['BookList'].length.toString());
        setState(() {
          books.addAll(result['data']['BookList']);
        });
      } else {
        setState(() {
          _isFinish = true;
        });
      }
    } catch (e) {
      setState(() {
        _isFinish = true;
      });
      print(e);
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    print('change' + books.toString());
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 1,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: books.length + 1,
          itemBuilder: (context, int index) {
            // 判断最后一条
            if (index == books.length) {
              return Container(
                alignment: Alignment(0, 0),
                height: 50,
                child: _isFinish ?
                  Text(
                    '没有更多了',
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: 14
                    ),
                  ) :
                  CircularProgressIndicator(
                    strokeWidth: 4,
                ),
              );
            }
            return GenderBookItem(
              book: books[index],
            );
          },
        ),
      )
    );
  }
}