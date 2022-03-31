/**
 * 搜索组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/13 11:06:39
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/apis/book.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intimate_couple/pages/Library/Catetory/GenderBookItem.dart';
import 'package:intimate_couple/components/PageLoading.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  ScrollController _scrollController;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _page = 0;
  bool _loading = false;
  bool _isFinish = false;
  bool _isEmpty = false;
  String keywords = '';
  List<dynamic> _bookList = [];
  /// 搜索图书
  Future<void> _searchBook(String key) async{
    try {
      keywords = key;
      ++_page;
      final result = await searchBook(key, _page);
      if (result != null && result['data'] != null && result['data'].length > 0) {
        print(result['data'].length);
        _bookList.addAll(result['data']);
        if(result['data'].length < 50) {
          _isFinish = true;
        }
      } else {
        _isFinish = true;
      }
      setState(() {});
      return result['data']?.length;
    } catch (e) {
      setState(() {
        _isFinish = true;
      });
      print(e);
    }
  }
  void _onSearch(value) {
    setState(() {
      _isEmpty = true;
      _bookList = [];
    });
    if (value == null || value == '') {
      showToast(
        '请输入你搜索的关键词',
        position: ToastPosition.bottom,
        backgroundColor: Colors.black.withOpacity(.8),
        textPadding: EdgeInsets.all(10)
      );
      _focusNode.requestFocus();
      return;
    }
    try {
      /// 回到顶部
      _scrollController.jumpTo(0);
    } catch (e) {
    }
    _page = 0;
    _searchBook(value).then((dynamic length) {
      _isEmpty = false;
      // if (length == null || length == 0) {
        
      // } else {
      //   _isEmpty = true;
      // }
      setState(() {});
    });
    _pageController.animateToPage(
      1,
      curve: Curves.linearToEaseOut,
      duration: Duration(milliseconds: 300)
    );
  }
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      /// 判断当前位置是否为最大位置
      if (_scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 30) &&
        !_loading &&
        !_isFinish) {
          _loading = true;
        // 更新数据
        _searchBook(keywords).whenComplete(() {
          _loading = false;
        });
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          child:  TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            autofocus: true,
            cursorColor: Colors.red,
            decoration: InputDecoration(
              focusColor: Colors.red,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
              ),
              hintText: '搜索你感兴趣的小说或作者'
            ),
            onTap: () {
              if (_currentPage == 0) return;
              _pageController.animateToPage(
                0,
                curve: Curves.linearToEaseOut,
                duration: Duration(milliseconds: 300)
              );
            },
            textInputAction:TextInputAction.search,
            onSubmitted: (value) {
              _onSearch(value);
            },
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: 60,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '取消'
              ),
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _searchHistory(),
          _searchResult()
        ],
      ),
    );
  }
  /// 搜索记录
  Widget _searchHistory() {
    return Container(
      padding:EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('搜索历史'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                _searchHistoryItem(
                  label: '斗破苍穹'
                ),
                _searchHistoryItem(
                  label: '武动乾坤'
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  /// 搜索历史记录元素
  Widget _searchHistoryItem({ String label }) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: RaisedButton(
        textColor: Colors.black54,
        onPressed: () {
          _textEditingController.value = TextEditingValue(
            text: label
          );
          _onSearch(label);
          _focusNode.unfocus();
        },
        child: Text(label),
      ),
    );
  }
  /// 搜索结果页面
  Widget _searchResult() {
    return Container(
      child: _isEmpty ? PageLoading() : (_bookList.length == 0 ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'static/images/empty_book.png',
            fit: BoxFit.contain,
            width: 200,
            height: 200,
          ),
          Text(
            '未找到您搜索的内容',
            style: TextStyle(
              color: Colors.black26
            ),
          )
        ],
      ) : ListView.builder(
        controller: _scrollController,
        itemCount: _bookList.length + 1,
        itemBuilder: (context, int index) {
          if (index == _bookList.length) {
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
            book: _bookList[index],
          );
        },
      )
    ));
  }
}