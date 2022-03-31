/**
 * 书单组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/07 00:39:35
 */
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GenderBookListItem extends StatelessWidget {
  final Map bookList;
  GenderBookListItem({
    this.bookList
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
      // padding: EdgeInsets。(top: 20),
      // decoration: BoxDecoration(
      //   border: Border(
      //     bottom: BorderSide(
      //       width: 0.2,
      //       color: Color(0xf5f5f5f5f5f)
      //     )
      //   )
      // ),
      child:  InkWell(
        onTap: () {
          print('click');
        },
        child: CachedNetworkImage(
          imageUrl: bookList['ImgUrl'],
          placeholder: (context, url) => Container(
            color: Colors.black12,
            alignment: Alignment(0, 0)
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.black12,
            alignment: Alignment(0, 0),
            child: Icon(Icons.error),
          ),
          fit: BoxFit.cover,
        ),
      )
    );
  }
}