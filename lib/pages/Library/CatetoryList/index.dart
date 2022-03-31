/**
 * 分类列表
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/13 17:06:49
 */
import 'package:flutter/material.dart';
import 'Page.dart';
class CatetoryList extends StatefulWidget {
  final Map<String, dynamic> catetory;
  CatetoryList({
    this.catetory
  });
  @override
  _CatetoryListState createState() => _CatetoryListState();
}
class TabItemData {
  final String label;
  final List data;
  final String name;
  TabItemData({
    this.label,
    this.data,
    this.name
  });
}
class _CatetoryListState extends State<CatetoryList> with SingleTickerProviderStateMixin {
  List<TabItemData> _tabs = [];
  TabController _tabController;
  PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    _tabs = [
      TabItemData(
        name: 'hot',
        label: '最热'
      ),
      TabItemData(
        name: 'new',
        label: '最新'
      ),
      TabItemData(
        name: 'vote',
        label: '评分'
      ),
      TabItemData(
        name: 'over',
        label: '完结'
      ),
    ];
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentPage,
      length: _tabs.length
    );
    _pageController = PageController(
      initialPage: _currentPage
    );
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          widget.catetory['Name'],
          style: TextStyle(
            color: Colors.black87
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          onTap: (int index) {
            _pageController.animateToPage(
              index,
              curve: Curves.linearToEaseOut,
              duration: Duration(milliseconds: 500)
            );
            setState(() {
              _currentPage = index;
            });
          },
          tabs: _tabs.map((TabItemData tab) {
            return Tab(
              child: Text(
                tab.label,
                style: TextStyle(
                  color: _currentPage == _tabs.indexOf(tab) ? Colors.red : Colors.black87
                ),
              ),
            );
          }).toList(),
          indicatorWeight: 3,
          indicatorColor: Colors.red,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          _tabController.animateTo(index);
          setState(() {
            _currentPage = index;
          });
        },
        children: _tabs.map((tab) {
          return CatetoryListPage(
            name: tab.name,
            catetoryId: widget.catetory['Id']
          );
        }).toList()
      ),
    );
  }
}