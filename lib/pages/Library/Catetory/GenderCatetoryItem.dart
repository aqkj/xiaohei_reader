/**
 * 性别分类元素
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 15:33:13
 */
import 'package:flutter/material.dart';
// import 'package:intimate_couple/model/book.dart';
// import 'package:flutter/services.dart';
import 'GenderBookItem.dart';
import 'GenderBookCatetoryItem.dart';
import 'GenderBookListItem.dart';
import 'package:intimate_couple/pages/Library/MoreList/index.dart';
class CatetoryItem extends StatelessWidget {
  final Map category;
  final int cateIndex;
  final String gender;
  CatetoryItem({
    this.category,
    this.cateIndex,
    this.gender
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  category['Category'],
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.w600
                  ),
                ),
                if(category['Books'] != null)
                  // 为text增加点击事件
                  GestureDetector(
                    // 点击
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return MoreList(
                            name: category['Category'],
                            index: cateIndex,
                            gender: gender
                          );
                        }
                      ));
                    },
                    child: Text(
                      '更多 >',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  )
              ],
            )
          ),
          if(category['Books'] != null)
            ...List.generate(
              category['Books'].length,
              (int index) {
                return GenderBookItem(
                  book: category['Books'][index],
                );
              }
            ).toList(),
          if (category['Categories'] != null)
            Container(
              height: 90,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: category['Categories'].length,
                itemBuilder: (context, index) {
                  return GenderBookCatetoryItem(
                    index: index,
                    catetory: category['Categories'][index],
                    isLast: index == category['Categories'].length - 1,
                  );
                },
              )
            ),
          if (category['BookList'] != null)
            GenderBookListItem(bookList: category['BookList'],)
        ],
      ),
    );
  }
}