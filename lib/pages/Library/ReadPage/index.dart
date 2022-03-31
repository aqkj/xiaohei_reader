/**
 * 阅读
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/09 23:09:30
 */
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:intimate_couple/utils/events.dart';
import 'package:intimate_couple/utils/tts.dart';
import 'package:intimate_couple/model/book.dart';
import 'package:intimate_couple/sqlite/book.dart';
import 'package:intimate_couple/apis/book.dart';
import 'package:intimate_couple/model/chapter.dart';
import 'package:intimate_couple/utils/utils.dart';
import 'package:intimate_couple/components/PageLoading.dart';
import 'package:intimate_couple/pages/Library/Detail/Catalog.dart';
class ReadPage extends StatefulWidget {
  final Book book;
  final String chapterId;
  final int chapterPage;
  ReadPage({
    this.book,
    this.chapterId,
    this.chapterPage
  });
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<ReadPage> {
  bool _isShowSystemUI = false;
  Chapter _info;
  Chapter _prevInfo;
  Chapter _nextInfo;
  /// 是否在书架内
  bool _isInBookShelf = false;
  /// 当前页面分页配置
  List<Map<String, int>> _pageConfig = [];
  List<Map<String, int>> _prevConfig = [];
  List<Map<String, int>> _nextConfig = [];
  PageController _pageController;
  int _currentPage = 1;
  /// 页面文本大小
  double _pageTextSize = 18;
  /// padding
  double _pagePadding = 20;
  /// 从第一句开始播放
  int _ttsStartIndex = 0;
  /// 是否读取
  bool _isStartRead = false;
  /// 夜间模式
  bool _isMoonLight = false;
  TTS _tts = TTS();
  // List _currentContentArr = [];
  Map _currentContentMap = {};
  // double _systemUiTop = 0;
  /// 切换显示系统ui
  void _toggleSystemUIOverlays() {
    _isShowSystemUI = !_isShowSystemUI;
    _isShowSystemUI ? SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]) :
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
  Future<void> _getChapterInfo(String chapterId, [int page]) async{
    try {
      final result = await getChapterData(widget.book.id, chapterId);
      if (result != null && result['data'] != null) {
        _info = Chapter.fromMap(result['data']);
        _pageConfig = _getPageOffset(_info.content);
        print('哈哈哈' + _pageConfig.length.toString());
        for (var i = 0; i < _pageConfig.length; i++) {
          String content = _info.content.substring(_pageConfig[i]['start'], _pageConfig[i]['end']);
          _currentContentMap[i + 1] = ReaderPageAgent.parseContent(content);
        }
        setState(() {
          _currentPage = page ?? 1;
        });
        /// 判断当前是第一章,获取上一章数据,并且有上一张的id
        if (_info.pid != '-1') {
          final result = await getChapterData(widget.book.id, _info.pid);
          if (result != null && result['data'] != null) {
            _prevInfo = Chapter.fromMap(result['data']);
            _prevConfig = _getPageOffset(_prevInfo.content);
            String content = _prevInfo.content.substring(_prevConfig[_prevConfig.length - 1]['start'], _prevConfig[_prevConfig.length - 1]['end']);
            _currentContentMap[0] = ReaderPageAgent.parseContent(content);
            print('哈哈哈_prevConfig' + _currentContentMap[0].toString());
            setState(() {
            });
          }
        }
        /// 判断当前是最后一张,获取下一章数据,并且有下一张的id
        if (_info.nid != '-1') {
          final result = await getChapterData(widget.book.id, _info.nid);
          if (result != null && result['data'] != null) {
            _nextInfo = Chapter.fromMap(result['data']);
            _nextConfig = _getPageOffset(_nextInfo.content);
            String content = _nextInfo.content.substring(_nextConfig[0]['start'], _nextConfig[0]['end']);
            _currentContentMap[_pageConfig.length + 1] = ReaderPageAgent.parseContent(content);
            setState(() {
            });
          }
        }
        print(_pageConfig);
      }
    } catch (e) {
      print(e);
    }
  }
  // 获取上一页文章
  Future<void> _getChapterInfoById(String id) async{
    try {
      final result = await getChapterData(widget.book.id, id);
      return result;
    } catch (e) {
      print(e);
    }
  }
  /// 获取每页分段
  List<Map<String, int>> _getPageOffset(content) {
    final size = MediaQuery.of(context).size;
    return ReaderPageAgent.getPageOffsets(
      content,
      size.height - (_pagePadding * 2) - 20,
      size.width - (_pagePadding * 2),
      _pageTextSize
    );
  }
  /// 播放内容
  spackContent() {
    /// 播放内容
    _tts.speakContent(
      _currentContentMap[_currentPage],
      _ttsStartIndex,
      /// 播放完毕触发
      completionHandler: () {
        // setState(() {
        //   _currentPage += 1;
        // });
        _pageController.jumpToPage(
          _currentPage + 1
        );
        /// 延迟500秒再播放
        Future.delayed(Duration(
          milliseconds: 500
        )).then((value) {
          setState(() {
            _ttsStartIndex = 0;
          });
          spackContent();
        });
      },
      /// 单词播放完毕
      startHandler: (int index) {
        setState(() {
          _ttsStartIndex = index;
        });
      }
    );
  }
  /// 取消时触发
  Future<bool> onWillPop() {
    // 判断是否在书架内
    if (_isInBookShelf) {
      /// 更新图书
      eventBus.fire(UpdateBook(
        id: widget.book.id,
        values: {
          'HistoryChapterId': _info.cid,
          'HistoryPage': _currentPage
        }
      ));
      return Future.value(true);
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('是否要加入书签?'),
            actions: <Widget>[
              FlatButton(
                child: Text('不用了'),
                onPressed: () {
                  // Navigator.of(context).pop()
                  Navigator.pop(context, true);
                },
              ),
              RaisedButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('加入书架'),
                onPressed: () {
                  widget.book.historyChapterId = _info.cid;
                  widget.book.historyChapterPage = _currentPage;
                  eventBus.fire(InsertBook(
                    book: widget.book
                  ));
                  // BookSqlite().insertBook(widget.book);
                  // eventBus.fire(event)
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        }
      );
    }
  }
  @override
  void initState() {
    if (widget.chapterPage != null) {
      _currentPage = widget.chapterPage;
    }
    BookSqlite().queryById<int>(widget.book.id).then((Book book) {
      /// 查找是否存在，存在的话则更新位置
      if (book != null) {
        _isInBookShelf = true;
      }
    });
    _pageController = new PageController(
      initialPage: _currentPage
    );
    _pageController.addListener(() {
      final page = (_pageController.page);
      var nextArtilePage = _pageConfig.length + (_prevConfig != null ? 1 : 0);
      print(page);
      print('大于next' + (page >= nextArtilePage).toString());
      print('小于prev' + (_prevConfig != null && page <= 0).toString());
      /// 下一页
      if (page >= nextArtilePage) {
        _prevConfig = _pageConfig;
        _prevInfo = _info;
        _pageConfig = _nextConfig;
        if (_prevConfig.length > 0) {
          String content = _prevInfo.content.substring(_prevConfig[_prevConfig.length - 1]['start'], _prevConfig[_prevConfig.length - 1]['end']);
          _currentContentMap[0] = ReaderPageAgent.parseContent(content);
        }
        _info = _nextInfo;
        for (var i = 0; i < _pageConfig.length; i++) {
          String content = _info.content.substring(_pageConfig[i]['start'], _pageConfig[i]['end']);
          _currentContentMap[i + 1] = ReaderPageAgent.parseContent(content);
        }
        _nextConfig = [];
        _nextInfo = null;
        /// 跳转最后一页
        // _currentPage = 1;
        /// 跳转到上一页最后的位置
        _pageController.jumpToPage(1);
        _getChapterInfoById(_info.nid).then((dynamic result) {
          if (result != null && result['data'] != null) {
            _nextInfo = Chapter.fromMap(result['data']);
            _nextConfig = _getPageOffset(_nextInfo.content);
            String content = _nextInfo.content.substring(_nextConfig[0]['start'], _nextConfig[0]['end']);
            _currentContentMap[_pageConfig.length + 1] = ReaderPageAgent.parseContent(content);
            setState(() {
            });
          }
        });
        setState(() {});
      /// 上一页
      } else if (_prevConfig != null && page <= 0 && _info.pid != '-1') {
        _nextConfig = _pageConfig;
        _nextInfo = _info;
        _pageConfig = _prevConfig;
        if (_nextConfig.length > 0) {
          String content = _nextInfo.content.substring(_nextConfig[0]['start'], _nextConfig[0]['end']);
          _currentContentMap[_pageConfig.length + 1] = ReaderPageAgent.parseContent(content);
        }
        _info = _prevInfo;
        for (var i = 0; i < _pageConfig.length; i++) {
          String content = _info.content.substring(_pageConfig[i]['start'], _pageConfig[i]['end']);
          _currentContentMap[i + 1] = ReaderPageAgent.parseContent(content);
        }
        _prevConfig = [];
        _prevInfo = null;
        /// 跳转最后一页
        // _currentPage = _pageConfig.length;
        _pageController.jumpToPage(_pageConfig.length);
        _getChapterInfoById(_info.pid).then((dynamic result) {
          if (result != null && result['data'] != null) {
            _prevInfo = Chapter.fromMap(result['data']);
            _prevConfig = _getPageOffset(_prevInfo.content);
            String content = _prevInfo.content.substring(_prevConfig[_prevConfig.length - 1]['start'], _prevConfig[_prevConfig.length - 1]['end']);
            _currentContentMap[0] = ReaderPageAgent.parseContent(content);
            setState(() {
            });
          }
        });
        setState(() {});
      }
    });
    _getChapterInfo(widget.chapterId, _currentPage);
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _pageController.dispose();
    _tts.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final iconColor = _isMoonLight ? Colors.white.withOpacity(.6) : Colors.brown;
    final materialColor = _isMoonLight ? Color(0xff292929): Color(0xffd8bf9c);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: GestureDetector(
          onTapUp: (detail) {
            final size = MediaQuery.of(context).size;
            final width = size.width;
            // final height = size.height;
            /// 获取左偏移
            final double left = (width / 2) - 60;
            /// 获取右偏移
            final double right = (width / 2) + 60;
            // final double top = (size.height / 2) - 100;
            // /// 底部偏移
            // final double bottom = (size.height / 2) + 100;
            // detail.globalPosition.dx;
            /// 点击左边
            if (detail.globalPosition.dx < left && !_isShowSystemUI) {
              _pageController.animateToPage(
                _currentPage - 1,
                curve: Curves.linear,
                duration: Duration(
                  milliseconds: 300
                )
              );
            } else if (detail.globalPosition.dx > right && !_isShowSystemUI) {
              /// 点击右边
              _pageController.animateToPage(
                _currentPage + 1,
                curve: Curves.linear,
                duration: Duration(
                  milliseconds: 300
                )
              );
            } else {
              /// 点击中间
              _toggleSystemUIOverlays();
            }
            debugPrint(MediaQuery.of(context).size.toString() + detail.globalPosition.dx.toString());
          },
          child: Stack(
            children: <Widget>[
              _pageConfig.length == 0 ? PageLoading() : PageView(
                controller: _pageController,
                onPageChanged: (int index) {
                  print('change');
                  /// 判断ui是否打开,打开的话关闭
                  if (_isShowSystemUI) {
                    _toggleSystemUIOverlays();
                  }
                  /// 修改当前index
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: <Widget>[
                  _prevPageContent(),
                  ..._currentPageContent(),
                  _nextPageContent()
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 150),
                top: _isShowSystemUI ? 0 : -80,
                left: 0,
                right: 0,
                height: 80,
                child: Material(
                  color: materialColor,
                  child: Container(
                    padding:EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          splashColor: Color(0xffaf997c),
                          onPressed: () {
                            onWillPop().then((bool value) {
                              if (value != null && value) {
                                Navigator.of(context).pop();
                              }
                            });
                            // Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: iconColor,
                          ),
                        ),
                        IconButton(
                          splashColor: Color(0xffaf997c),
                          onPressed: () {
                            if (_isStartRead) {
                              _tts.stop();
                              setState(() {
                                _isStartRead = false;
                                _ttsStartIndex = 0;
                              });
                            } else {
                              spackContent();
                              setState(() {
                                _isStartRead = true;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.headset,
                            color: iconColor,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 150),
                bottom: _isShowSystemUI ? 0 : -70,
                left: 0,
                right: 0,
                height: 70,
                child: Material(
                  color: materialColor,
                  child: Container(
                    padding:EdgeInsets.symmetric(horizontal: 20),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: _isMoonLight ? Colors.white.withOpacity(.6) : Colors.brown,
                        fontSize: 12
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Catalog(
                                      book: widget.book,
                                      chapterId: _info.cid
                                    );
                                  }
                                )
                              ).then((value) {
                                if (value != null) {
                                  _getChapterInfo(value);
                                  _pageController.jumpToPage(1);
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.format_list_bulleted,
                                  size: 24,
                                  color: iconColor,
                                ),
                                Text(
                                  '目录'
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMoonLight = !_isMoonLight;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  !_isMoonLight ? Icons.brightness_4 : Icons.brightness_low,
                                  size: 24,
                                  color: iconColor,
                                ),
                                Text(
                                  _isMoonLight ? '日间' : '夜间'
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.text_format,
                                size: 24,
                                  color: iconColor,
                              ),
                              Text(
                                '设置'
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
  /// 当前页面
  Iterable<Widget> _currentPageContent() {
    return _pageConfig.map((page) {
      return _textPage(
        _info.content.substring(page['start'], page['end']),
        index: _pageConfig.indexOf(page) + 1
      );
    });
  }
  /// 上一页内容
  Widget _prevPageContent() {
    return _prevConfig.length > 0 ? _textPage(
      _prevInfo.content.substring(
        _prevConfig[_prevConfig.length - 1]['start'],
        _prevConfig[_prevConfig.length - 1]['end']
      ),
      index: 0
    ) : Container(
      alignment: Alignment(0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// 首页显示标题
          Text(
            _info.name,
            style: TextStyle(
              fontSize: 30,
              color: Colors.black87
            ),
          )
        ],
      ),
    );
  }
  /// 下一页内容
  Widget _nextPageContent() {
    return _textPage(
      _nextConfig.length > 0 ?
        _nextInfo.content.substring(_nextConfig[0]['start'], _nextConfig[0]['end']) :
        '',
      index: _pageConfig.length + 1
    );
  }
  /// 文本页面
  Widget _textPage(String content, { int index }) {
    // final List<String> contentArr = content.split(RegExp('[。|!|！|?!？]'));
    final newContentArr = _currentContentMap[index] ?? [];
    // int contentLength = 0;
    // /// 分割句子
    // for (var i = 0; i < contentArr.length; i++) {
    //   int endIndex = contentLength + contentArr[i].length + (i == contentArr.length - 1 ? 0 : 1);
    //   newContentArr.add(content.substring(
    //     contentLength,
    //     endIndex
    //   ));
    //   contentLength = endIndex;
    // }
    // /// 判断当前选中
    // // if (index == _currentPage) {
    // //   _currentContentArr = contentArr;
    // // }
    // _currentContentMap[index] = contentArr;
    print('${index}newContentArr: ${newContentArr.length}');
    return Container(
      padding: EdgeInsets.all(_pagePadding),
      decoration: BoxDecoration(
        color: _isMoonLight ? Color(0xff333333) : null,
        image: _isMoonLight ? null : DecorationImage(
          image: AssetImage(
            'static/images/read_bg.png',
          ),
          fit: BoxFit.cover
        )
      ),
      child: Text.rich(
        TextSpan(
          children: [
            ...newContentArr.map((value) {
              return TextSpan(
                text: value,
                style: TextStyle(
                  color: _isStartRead &&
                    index == _currentPage &&
                    _ttsStartIndex == newContentArr.indexOf(value) ?
                    Colors.white : _isMoonLight ? Colors.white.withOpacity(.8) : Colors.black87,
                  backgroundColor: _isStartRead &&
                    index == _currentPage &&
                    _ttsStartIndex == newContentArr.indexOf(value) ?
                    Colors.brown :
                    Colors.transparent
                )
              );
            }).toList()
          ]
        ),
        style: TextStyle(
          fontSize: _pageTextSize,
          color: Colors.black87
        ),
      ),
      // child: Text(
      //   content,
      //   style: TextStyle(
      //     fontSize: _pageTextSize,
      //     color: Colors.black87
      //   ),
      // ),
    );
  }
}