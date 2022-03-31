/**
 * 目录页面
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/09 19:55:27
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intimate_couple/components/sorptionview_flutter/adsorptionview_flutter.dart';
import 'package:intimate_couple/apis/book.dart';
import 'package:intimate_couple/model/book.dart';
import 'package:intimate_couple/model/chapter.dart';
import 'package:intimate_couple/components/PageLoading.dart';
import 'package:intimate_couple/pages/Library/ReadPage/index.dart';

class Catalog extends StatefulWidget {
  /// 书本id
  final Book book;
  /// 默认选中章节id
  final String chapterId;
  Catalog({
    this.book,
    this.chapterId
  });
  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> with SingleTickerProviderStateMixin{
  /// 章节列表
  List<Chapter> chapters = List();
  int _currentTab = 0;
  /// 章节高度
  final double itemHeader = 60;
  TabController _tabController;
  PageController _pageController;
  ScrollController _scrollController;
  /// 获取
  getChapters() async{
    try {
      final result = await getChaptersData(widget.book.id);
      double offsetTop = 0;
      if (result != null && result['data'] != null) {
        final List<dynamic> list = result['data']['list'];
        final List<Chapter> _chapters = List();
        list.forEach((item) {
          item['isHeader'] = true;
          final Chapter chapter = Chapter.fromMap(item);
          _chapters.add(chapter);
          item['list'].forEach((_item) {
            _chapters.add(Chapter.fromMap(_item));
          });
        });
        if (widget.chapterId != null && widget.chapterId != '') {
          double headerHeight = 0;
          int indexOf = _chapters.indexWhere((chapter) {
            /// 判断是否是头部，计算头部高度
            if (chapter.isHeader) {
              headerHeight += itemHeader;
            }
            return chapter.id == widget.chapterId;
          });
          /// 屏幕高度
          final double height = MediaQuery.of(context).size.height;
          /// 判断是否存在
          if (indexOf >= 0) {
            offsetTop = (indexOf.toDouble() * itemHeader) + headerHeight;
            if (offsetTop > (height / 2)) {
              offsetTop -= (height / 2);
            }
          }
        }
        _scrollController = ScrollController(
          initialScrollOffset: offsetTop
        );
        setState(() {
          chapters = _chapters;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 150)).then((value) {
      getChapters();
    });
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    _pageController = PageController(
      initialPage: 0
    );
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
        title: Center(
          child: Container(
            width: 150,
            child: TabBar(
              onTap: (int index) {
                setState(() {
                  _currentTab = index;
                });
                _pageController.animateToPage(index,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 500)
                );
              },
              unselectedLabelColor: Colors.black,
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              indicatorWeight: 3,
              indicatorColor: Colors.red,
              tabs: <Widget>[
                Tab(
                  child: Transform.scale(
                    scale: _currentTab == 0 ? 1.4 : 1,
                    child: Text(
                      '目录',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Transform.scale(
                    scale: _currentTab == 1 ? 1.4 : 1,
                    child: Text(
                      '书签',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          if (_currentTab == 1)
            SizedBox(
              width: 73,
            ),
          if (_currentTab == 0)
            Icon(
              Icons.swap_vert,
              size: 26,
              color: Colors.black87.withOpacity(.7),
            ),
          if (_currentTab == 0)
            Container(
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment(0, 0),
              child: Text(
                '倒序',
                style: TextStyle(
                  color: Colors.black87.withOpacity(.7),
                  fontSize: 16
                ),
              ),
            )
        ]
      ),
      body: PageView(
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
          _tabController.animateTo(index);
        },
        controller: _pageController,
        children: <Widget>[
          chapters.length == 0 ? PageLoading() : CupertinoScrollbar(
            child: AdsorptionView(
              scrollController: _scrollController,
              itemHeight: itemHeader,
              generalItemChild: (Chapter bin) {
                return Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      /// 判断是否有章节id
                      if (widget.chapterId != null) {
                        Navigator.of(context).pop(
                          bin.id
                        );
                      } else {
                        /// 点击某一章
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return ReadPage(
                                book: widget.book,
                                chapterId: bin.id,
                              );
                            }
                          )
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        bin.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: widget.chapterId != null && widget.chapterId == bin.id ? Colors.red : Colors.black87,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ),
                );
              },
              headChild: (Chapter bin) {
                return Container(
                  color: Color(0xfeeeeeee),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                  child: Text(
                    bin.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                );
              },
              adsorptionDatas: chapters
            )
          ),
          Container(
            alignment: Alignment(0, 0),
            child: Text(
              '暂无书签'
            ),
          )
        ],
      ),
    );
  }
}