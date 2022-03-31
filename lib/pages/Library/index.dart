/**
 * 书库
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 11:28:39
 */
import 'package:flutter/material.dart';
import './Catetory/Gender.dart';
import './Catetory/Catetory.dart';
import 'Catetory/Leaderboard.dart';
import 'Search/index.dart';
class Library extends StatefulWidget {
  Library({
    Key key
  }):super(key: key);
  @override
  _LibraryState createState() => _LibraryState();
}
// 分类
class BookCatetory {
  final String title;
  BookCatetory({
    this.title
  });
}
class _LibraryState extends State<Library> with SingleTickerProviderStateMixin {
  List<BookCatetory> barList = [];
  TabController _tabController;
  PageController _pageController = new PageController();
  int _currentIndex = 0;
  @override
  void initState() {
    _getBarItem();
    super.initState();
  }
  // 获取分类列表
  _getBarItem() async {
    barList = [
      BookCatetory(
        title: '男生'
      ),
      BookCatetory(
        title: '女生'
      ),
      BookCatetory(
        title: '分类'
      ),
      BookCatetory(
        title: '榜单'
      )
    ];
    _tabController = TabController(
      vsync: this,
      length: barList.length
    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    final tabTextStyle = TextStyle(
      fontSize: 18,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TabBar(
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          controller: _tabController,
          tabs: List.generate(
            barList.length,
            (int index) {
              return Tab(
                child: Transform.scale(
                  scale: _currentIndex == index ? 1.4 : 1,
                  child: Text(
                    barList[index].title,
                    style: tabTextStyle,
                  ),
                ),
              );
            }
          ),
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(
              index
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Search();
                  }
                )
              );
            },
            icon: Icon(
              Icons.search
            ),
          )
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
          _tabController.animateTo(index);
        },
        children: [
          CateoryGender(
            gender: 'man',
          ),
          CateoryGender(
            gender: 'lady'
          ),
          Catetory(),
          Leaderboard(),
        ],
      ),
    );
  }
}