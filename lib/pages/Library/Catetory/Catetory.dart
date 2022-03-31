/**
 * 书分类
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/08 14:31:52
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/apis/book.dart';
import 'CatetoryItem.dart';
import 'package:intimate_couple/components/PageLoading.dart';
class Catetory extends StatefulWidget {
  @override
  _CatetoryState createState() => _CatetoryState();
}

class _CatetoryState extends State<Catetory> with AutomaticKeepAliveClientMixin {
  List _categorys = [];
  /// 获取分类数据
  Future<void> _getCategory() async{
    try {
      final result = await getCategory();
      if (result != null && result['data'].length != 0) {
        setState(() {
          _categorys = result['data'];
        });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    _getCategory();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _categorys.length == 0 ? PageLoading() : GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1 / 0.7,
      children: <Widget>[
        ..._categorys.map((category) {
          return CatetoryItem(
            catetory: category
          );
        })
      ],
    );
  }
  @override
  bool get wantKeepAlive => true;
}