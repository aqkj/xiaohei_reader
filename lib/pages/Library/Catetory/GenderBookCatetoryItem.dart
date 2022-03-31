/**
 * 图书分类导航
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 23:11:11
 */
import 'package:flutter/material.dart';

class GenderBookCatetoryItem extends StatelessWidget {
  final int index;
  final Map catetory; 
  /// 是否为最后一个
  final bool isLast;
  GenderBookCatetoryItem({
    this.catetory,
    this.index,
    this.isLast
  });
  static const List<MaterialColor> _colorList = [
    Colors.amber,
    Colors.blue,
    Colors.teal,
    Colors.brown,
    Colors.cyan
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 5, isLast ? 20 : 0, 5),
      width: 150,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)
        ),
        onPressed: () {},
        color: _colorList[index],
        child: Text(
          catetory['CategoryName'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
        )
      ),
    );
    // return Material(
    //   child: InkWell(
    //     onTap: () {},
    //     child: Container(
    //       width: 150,
    //       margin: EdgeInsets.fromLTRB(20, 5, isLast ? 20 : 0, 5),
    //       alignment: Alignment(0, 0),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(6),
    //         boxShadow: [
    //           BoxShadow(
    //             offset: Offset(1, 1),
    //             color: Colors.black45,
    //             blurRadius: 3
    //           )
    //         ],
    //         // color: _colorList[index]
    //       ),
    //       child:Text(
    //         catetory['CategoryName'],
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 18
    //         ),
    //       )
    //     ),
    //   ),
    // );
  }
}