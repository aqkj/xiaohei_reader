/**
 * 排行榜
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/08 21:08:58
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intimate_couple/apis/book.dart';
import 'LeaderboardBookItem.dart';
class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}
class LeaderboardCatetory {
  final String label;
  final String name;
  LeaderboardCatetory({
    @required this.label,
    @required this.name
  });
}
class _LeaderboardState extends State<Leaderboard> with AutomaticKeepAliveClientMixin {
  final List<LeaderboardCatetory> _catetorys = [
    LeaderboardCatetory(
      label: '最热榜',
      name: 'hot',
    ),
    LeaderboardCatetory(
      label: '完结榜',
      name: 'over',
    ),
    LeaderboardCatetory(
      label: '推荐榜',
      name: 'commend',
    ),
    LeaderboardCatetory(
      label: '新书榜',
      name: 'new',
    ),
    LeaderboardCatetory(
      label: '评分榜',
      name: 'vote',
    ),
    LeaderboardCatetory(
      label: '起点榜',
      name: '1',
    ),
  ];
  /// 当前选中
  int _currentCategory = 0;
  String _gender = 'lady';
  int _page = 0;
  List _books = [];
  /// 是否加载中
  bool _isLoading = false;
  // 加载页面
  bool _isLoadingPage = true;
  /// 是否加载完成
  bool _isFinish = false;
  ScrollController _scrollController = ScrollController();
  Future<void> _getBookList({ isadd = false }) async{
    try {
      _page++;
      Map result;
      if (_catetorys[_currentCategory].name != '1') {
        /// 获取排名数据
        result = await getRankData(_gender, _catetorys[_currentCategory].name, 'week', _page);
      } else {
        /// 获取起点数据
        result = await getRankMoreData(_gender, _gender == 'man' ? _catetorys[_currentCategory].name : '2', _page);
      }
      if (result != null && result['data'].length > 0) {
        setState(() {
          if (!isadd) {
            /// 回到顶部
            _scrollController.jumpTo(0);
            _books = result['data']['BookList'];
          } else {
            _books.addAll(result['data']['BookList']);
          }
          _isLoadingPage = false;
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
  void initState() {
    _getBookList();
    super.initState();
    _scrollController.addListener(() {
      /// 判断当前位置是否为最大位置
      if (_scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 30) &&
        !_isLoading &&
        !_isFinish) {
        _isLoading = true;
        // 更新数据
        _getBookList(
          isadd: true
        ).whenComplete(() {
          _isLoading = false;
        });
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: <Widget>[
        _leftBuild(),
        _rightBuild()
      ],
    );
  }
  /// 渲染右侧
  Widget _rightBuild() {
    final size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: 250,
            padding: EdgeInsets.all(20),
            child: CupertinoSegmentedControl(
              selectedColor: Colors.red,
              borderColor: Colors.red,
              groupValue: _gender,
              onValueChanged: (value) {
                _page = 0;
                setState(() {
                  _isFinish = false;
                  _isLoadingPage = true;
                  _gender = value;
                });
                _getBookList().whenComplete(() {
                  _isLoading = false;
                });
              },
              children: {
                'lady': Text('女'),
                'man': Text('男')
              },
            ),
          ),
          Container(
            // 计算高度
            height: height - 148,
            // 计算宽度
            width: width - 100,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _books.length + 1,
              itemBuilder: (context, int index) {
                // 判断最后一条
                if (index == _books.length) {
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
                return LeaderboardBookItem(
                  book: _books[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
  Widget _leftBuild() {
    return Container(
      width: 100,
      color: Color(0xdddddddd),
      child: ListView.builder(
        itemCount: _catetorys.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () {
              _page = 0;
              setState(() {
                _isFinish = false;
                _isLoadingPage = true;
                _currentCategory = index;
              });
              _getBookList().whenComplete(() {
                _isLoading = false;
              });
            },
            child: Container(
              alignment: Alignment(0, 0),
              color: _currentCategory == index ? Colors.white : null,
              height: 50,
              width: 100,
              child: Container(
                width: 100,
                padding: EdgeInsets.only(left: 22),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 3,
                      color: _currentCategory == index ? Colors.red : Colors.transparent
                    )
                  )
                ),
                child: Text(
                  _catetorys[index].label,
                  style: TextStyle(
                    color: _currentCategory == index ? Colors.red : Colors.black54,
                    fontSize: 16,
                    fontWeight: _currentCategory == index ? FontWeight.bold : FontWeight.w400
                  ),
                ),
              ),
            )
          );
        },
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}