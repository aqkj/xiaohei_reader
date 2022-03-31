/**
 * 详情其他小说/类似小说
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/13 21:55:07
 */
import 'package:flutter/material.dart';
import 'BookListItem.dart';
class DetailBookList extends StatelessWidget {
  final String label;
  final List books;
  DetailBookList({
    @required this.books,
    @required this.label
  });
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
          label,
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          // controller: _scrollController,
          itemCount: books.length + 1,
          itemBuilder: (context, int index) {
            // 判断最后一条
            if (index == books.length) {
              return Container(
                alignment: Alignment(0, 0),
                height: 50,
                child: Text(
                  '没有更多了',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 14
                  ),
                )
              );
            }
            return BookListItem(
              book: books[index],
            );
          },
        ),
      )
    );
  }
}
// class BookList extends StatefulWidget {
//   final String label;
//   final List books;
//   BookList({
//     @required this.books,
//     @required this.label
//   });
//   @override
//   _BookListState createState() => _BookListState();
// }

// class _BookListState extends State<BookList> {
//   // List<dynamic> books = [];
//   static const List<String> _kind = ['new', 'hot', 'commend', 'over'];
//   int _page = 0;
//   /// 是否加载中
//   bool _isLoading = false;
//   /// 是否加载完成
//   bool _isFinish = false;
//   ScrollController _scrollController = ScrollController();
//   @override
//   void initState() {
//     super.initState();
//     _getBookList();
//     _scrollController.addListener(() {
//       /// 判断当前位置是否为最大位置
//       if (_scrollController.position.pixels >=
//         (_scrollController.position.maxScrollExtent - 30) &&
//         !_isLoading &&
//         !_isFinish) {
//         _isLoading = true;
//         // 更新数据
//         _getBookList().whenComplete(() {
//           _isLoading = false;
//         });
//       }
//     });
//   }
//   Future<void> _getBookList() async{
//     try {
//       _page++;
//       final result = await getRankData(widget.gender, _kind[widget.index], 'week', _page);
//       if (result != null && result['data'].length > 0) {
//         print('请求数量: ' + result['data']['BookList'].length.toString());
//         setState(() {
//           books.addAll(result['data']['BookList']);
//         });
//       } else {
//         setState(() {
//           _isFinish = true;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isFinish = true;
//       });
//       print(e);
//     }
//   }
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//   @override
//   void didChangeDependencies() {
//     print('change' + books.toString());
//     super.didChangeDependencies();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }