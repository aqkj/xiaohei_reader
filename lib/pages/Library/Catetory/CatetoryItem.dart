/**
 * 分类元素组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/08 19:58:03
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intimate_couple/utils/utils.dart';
import 'package:intimate_couple/config/config.dart';
import 'package:intimate_couple/pages/Library/CatetoryList/index.dart';
class CatetoryItem extends StatelessWidget {
  final Map catetory;
  CatetoryItem({
    this.catetory
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return CatetoryList(
                  catetory: catetory,
                );
              }
            )
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 4
                  )
                ]
              ),
              margin: EdgeInsets.only(right: 5),
              child: CachedNetworkImage(
                width: 23 * MediaQuery.of(context).devicePixelRatio,
                imageUrl: getCompleteImgUrl(
                  Config.CATETORY_IMAGES[catetory['Id'].toString()] + '.jpg'
                ),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    catetory['Name'],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    catetory['Count'].toString() + '部',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black45
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}