/**
 * 小说元素组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 15:36:54
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/model/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intimate_couple/pages/Library/ReadPage/index.dart';
class FictonItem extends StatelessWidget {
  final Book book;
  FictonItem({
    this.book
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              final String chapterId = book.historyChapterId ?? book.firstChapterId;
              return ReadPage(
                book: book,
                chapterId: chapterId,
                chapterPage: book.historyChapterPage ?? 1
              );
            }
          )
        );
      },
      child: Container(
        height: 136.4,
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
              child: CachedNetworkImage(
                imageUrl: book.img,
                width: 80,
                height: 106.4,
                placeholder: (context, url) => Container(
                  color: Colors.black12,
                  width: 80,
                  height: 106.4,
                  alignment: Alignment(0, 0),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.black12,
                  width: 80,
                  height: 106.4,
                  alignment: Alignment(0, 0),
                  child: Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                // height: ,
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      book.name,
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
                      '${book.author}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87
                      ),
                    ),
                    Text(
                      '${book.lastChapter}',
                      style:TextStyle(
                        fontSize: 14,
                        color: Colors.black87
                      )
                    ),
                    Text(
                      '${book.lastTime}',
                      maxLines: 3,
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