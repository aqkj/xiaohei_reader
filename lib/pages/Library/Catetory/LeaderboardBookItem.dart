/**
 * 分类书组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 15:36:54
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/model/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Detail/index.dart';
class LeaderboardBookItem extends StatelessWidget {
  final Map book;
  LeaderboardBookItem({
    this.book
  });
  @override
  Widget build(BuildContext context) {
    Book _book = Book.fromMap(book);
    print(_book);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return Detail(
                bookId: _book.id,
              );
            }
          )
        );
      },
      child: Container(
        height: 124,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.2,
              color: Color(0xf5f5f5f5f5f)
            )
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Hero(
                tag: _book.id,
                child: CachedNetworkImage(
                  imageUrl: _book.img,
                  width: 80,
                  height: 104,
                  placeholder: (context, url) => Container(
                    color: Colors.black12,
                    width: 80,
                    height: 104,
                    alignment: Alignment(0, 0),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.black12,
                    width: 80,
                    height: 104,
                    alignment: Alignment(0, 0),
                    child: Icon(Icons.error),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                // height: ,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _book.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 1
                          )
                        ]
                      ),
                    ),
                    Text(
                      '${_book.author} / ${_book.cname}',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${_book.desc}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}