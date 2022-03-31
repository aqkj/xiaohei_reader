/**
 * 首页
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/05 21:14:26
 */
import 'package:flutter/material.dart';
import 'Fiction/index.dart';
import '../Chat/index.dart';
import '../Location/index.dart';
import './ButtomItem.dart';
class Home extends StatefulWidget {
  static final String routerName = '/home';
  @override
  _HomeState createState() => _HomeState();
}
// 底部导航item抽象

class _HomeState extends State<Home> {
  int _currentIndex;
  List<BottomNavBarItem> _navList;
  PageController _pageController;
  @override
  // 初始化state
  void initState() {
    super.initState();
    _currentIndex = 0;
    _navList = [
      BottomNavBarItem(
        component: Fiction(),
        icon: Icon(
          Icons.book
        ),
        activeIcon: Icon(
          Icons.book,
        ),
        title: Text('书架')
      ),
      BottomNavBarItem(
        component: Location(),
        icon: Icon(
          Icons.face
        ),
        activeIcon: Icon(
          Icons.face
        ),
        title: Text('位置')
      )
    ];
    _pageController = PageController(
      initialPage: _currentIndex
    );
  }
  @override
  // 修改触发
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(_currentIndex);
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, index) {
          return _navList[index].component;
        },
        // 不左右滑动
        physics:NeverScrollableScrollPhysics(),
        itemCount:_navList.length,
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        backgroundColor: Colors.brown,
        child: Icon(
          Icons.chat,
          size: 26,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Chat();
              }
            )
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _navList.map((BottomNavBarItem bottomNavBarItem) => ButtomItem(
            bottomNavBarItem: bottomNavBarItem,
            onTap: () {
              int index = _navList.indexOf(bottomNavBarItem);
              setState(() {
                _currentIndex = index;
              });
              _pageController.jumpToPage(
                index
              );
            },
            isActive: _navList[_currentIndex] == bottomNavBarItem,
          )).toList(),
        ),
      )
    );
  }
}