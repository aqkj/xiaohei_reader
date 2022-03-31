/**
 * 书详情
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/09 10:32:11
 */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intimate_couple/model/book.dart';
import 'package:intimate_couple/apis/book.dart';
import 'package:intimate_couple/sqlite/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intimate_couple/components/PageLoading.dart';
import 'package:intimate_couple/utils/events.dart';
import 'Catalog.dart';
import 'BookList.dart';
import 'package:intimate_couple/pages/Library/ReadPage/index.dart';
class Detail extends StatefulWidget {
  final int bookId;
  Detail({
    @required this.bookId
  });
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Book _bookInfo = Book();
  bool _isMore = false;
  Future<void> getBookDetail() async{
    try {
      final result = await getInfoData(widget.bookId);
      if (result != null && result['data'] != null) {
        setState(() {
          _bookInfo = Book.fromMap(result['data']);
        });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 150)).then((value) {
      getBookDetail();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bookInfo?.name == null ? PageLoading() : CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.red,
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              // title: Text(_bookInfo.name),
              background: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment(0, 0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          _bookInfo.img
                        ),
                        fit: BoxFit.cover
                      )
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.4)
                      ),
                    ),
                  ),
                  Positioned(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment(0, 0),
                          child: Hero(
                            tag: widget.bookId,
                            child: CachedNetworkImage(
                              imageUrl: _bookInfo.img,
                              width: 100,
                            ),
                          ),
                        ),
                        Text(
                          _bookInfo.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: Text(
                            '${_bookInfo.author} / ${_bookInfo.cname} / ${_bookInfo.bookStatus}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        )
                      ],
                    )
                  )
                ],
              )
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _bookVote(),
              Divider(
                height: 0,
              ),
              _bookDesc(),
              Divider(
                height: 15,
                color: Colors.white,
              ),
              _bookCell(
                onTap: () {
                  /// 跳转目录页
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return Catalog(
                        book: _bookInfo,
                      );
                    }
                  ));
                },
                title: '目录',
                children: [
                  Container(
                    width: 260,
                    child: Text(
                      '最新章节：${_bookInfo.lastChapter}',
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    ),
                  )
                ]
              ),
              Divider(
                height: 15,
                color: Colors.white,
              ),
              _bookCell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DetailBookList(
                      books: _bookInfo.sameUserBooks,
                      label: '作者其他小说',
                    ))
                  );
                },
                title: '作者其他小说',
                children: [
                  Container(
                    width: 260,
                    child: Text(
                      '有 ${_bookInfo.sameUserBooks.length} 部',
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    ),
                  )
                ]
              ),
              Divider(
                height: 15,
                color: Colors.white,
              ),
              _bookCell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DetailBookList(
                      books: _bookInfo.sameCategoryBooks,
                      label: '类似小说',
                    ))
                  );
                },
                title: '类似小说',
                children: [
                  Container(
                    width: 260,
                    child: Text(
                      '有 ${_bookInfo.sameCategoryBooks.length} 部',
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54
                      ),
                    ),
                  )
                ]
              ),
              Divider(
                height: 15,
                color: Colors.white,
              ),
            ]),
          )
        ],
      ),
      bottomNavigationBar: Material(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.2,
                color: Colors.black.withOpacity(.2)
              )
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
                onPressed: () {
                  eventBus.fire(InsertBook(
                    book: _bookInfo
                  ));
                },
                child: Container(
                  alignment:Alignment(0, 0),
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 24,
                        color: Colors.black87,
                      ),
                      Text('加入书架',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
                )
              ), FlatButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                ),
                color: Colors.red,
                splashColor: Colors.redAccent,
                onPressed: () {
                  BookSqlite().queryById(_bookInfo.id).then((Book book) {
                    // 获取章节id
                    final String cid = book == null ? _bookInfo.firstChapterId : book.historyChapterId ?? book.firstChapterId;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ReadPage(
                            book: book == null ? _bookInfo : book,
                            chapterId: cid,
                            chapterPage:  book == null ? 1 : book.historyChapterPage ?? 1,
                          );
                        }
                      )
                    );
                  });
                },
                child: Container(
                  alignment:Alignment(0, 0),
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('立即阅读',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
  /// 收藏评分
  Widget _bookVote() {
    const TextStyle titleStyle = TextStyle(
      fontSize: 20,
      color: Colors.black87,
      fontWeight: FontWeight.bold
    );
    final TextStyle subTitleStyle = TextStyle(
      fontSize: 14,
      color: Colors.black87.withOpacity(0.8),
      fontWeight: FontWeight.w400
    );
    return Container(
      height: 70,
      color: Colors.white,
      alignment: Alignment(0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _bookInfo.bookVote['Score'].toString(),
                style: titleStyle,
              ),
              Text('评分', style: subTitleStyle)
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_bookInfo.bookVote['TotalScore'].toString(),
                style: titleStyle,),
              Text('总分', style: subTitleStyle,)
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_bookInfo.bookVote['VoterCount'].toString(),
                style: titleStyle,),
              Text('收藏', style: subTitleStyle)
            ],
          ),
        ],
      ),
    );
  }
  /// 描述
  Widget _bookDesc() {
    final width = MediaQuery.of(context).size.width;
    final String descEllipss = _bookInfo.desc.length > 43 ? _bookInfo.desc.substring(0, 43) + '...' : _bookInfo.desc;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMore = !_isMore;
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            // Text(
            //   _bookInfo.desc,
            //   maxLines: 2,
            //   textAlign: TextAlign.justify,
            //   overflow: TextOverflow.ellipsis,
            // ),
            Container(
              width: width - 30,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _isMore ? _bookInfo.desc : descEllipss,
                      style: TextStyle(
                        color: Colors.black54
                      )
                    ),
                    !_isMore ? TextSpan(
                      style: TextStyle(
                        color: Colors.blue
                      ),
                      text: '展开'
                    ) : TextSpan()
                  ]
                ),
              ),
            )
          ],
        )
      ),
    );
  }
  Widget _bookCell({
    String title,
    List<Widget> children,
    @required Function onTap
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87.withOpacity(.8),
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: children,
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.black54,
              )
            ],
          ),
        ),
      )
    );
  }
}