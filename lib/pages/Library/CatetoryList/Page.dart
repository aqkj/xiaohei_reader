/**
 * 获取分类详情数据
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/13 17:50:13
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/components/PageLoading.dart';
import 'package:intimate_couple/pages/Library/Catetory/GenderBookItem.dart';
import 'package:intimate_couple/apis/book.dart';
class CatetoryListPage extends StatefulWidget {
  final String name;
  final String catetoryId;
  CatetoryListPage({
    this.name,
    this.catetoryId
  });
  @override
  _CatetoryListPageState createState() => _CatetoryListPageState();
}

class _CatetoryListPageState extends State<CatetoryListPage> with AutomaticKeepAliveClientMixin {
  List _list = [];
  ScrollController _scrollController;
  int _page = 0;
  bool _isLoading = false;
  bool _isFinish = false;
  /// 获取分类列表数据
  Future<void> _getCatetoryListData() async{
    try {
      ++ _page;
      final result = await getCategoryRankData(
        categoryId: widget.catetoryId,
        kind: widget.name,
        curPage: _page
      );
      if (result != null && result['data'] != null && result['data']['BookList'].length > 0) {
        _list.addAll(result['data']['BookList']);
      } else {
        _isFinish = true;
      }
      setState(() {});
    } catch (e) {
      print(e);
      setState(() {
        _isFinish = true;
      });
    }
  }
  @override
  void initState() {
    _getCatetoryListData();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 30) &&
        !_isLoading &&
        !_isFinish) {
        _isLoading = true;
        // 更新数据
        _getCatetoryListData().whenComplete(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _list.length == 0 ? PageLoading() : ListView.builder(
      controller: _scrollController,
      itemCount: _list.length + 1,
      itemBuilder: (context, int index) {
          // 判断最后一条
          if (index == _list.length) {
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
           book: _list[index],
         );
      },
    );
  }
  @override
  bool get wantKeepAlive => true;
}