import 'package:intimate_couple/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui show window;
/// 获取完全的图片url
String getCompleteImgUrl(String url) {
  if (url.contains(Config.IMAGE_BASE_URL) ||
      url.contains(Config.IMAGE_BASE_URL2) ||
      url.contains(Config.IMAGE_BASE_URL3))
    return url;
  else
    return Config.IMAGE_BASE_URL2 + url;
}
// double adaptivePx(double px) {
//   const width = MediaQuery.of(context).
//   return 750;
// }
class ReaderPageAgent {
  static List<Map<String, int>> getPageOffsets(String content, double height, double width, double fontSize) {
    String tempStr = content;
    List<Map<String, int>> pageConfig = [];
    int last = 0;
    while (true) {
      Map<String, int> offset = {};
      offset['start'] = last;
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(text: tempStr, style: TextStyle(fontSize: fontSize));
      textPainter.layout(maxWidth: width);
      var end = textPainter.getPositionForOffset(Offset(width, height)).offset;

      if (end == 0) {
        break;
      }
      tempStr = tempStr.substring(end, tempStr.length);
      offset['end'] = last + end;
      last = last + end;
      pageConfig.add(offset);
    }
    return pageConfig;
  }
  /// 转换内容
  static List<dynamic> parseContent(String content) {
    final List<String> contentArr = content.split(RegExp('[。|!|！|?!？]'));
    final newContentArr = [];
    int contentLength = 0;
    /// 分割句子
    for (var i = 0; i < contentArr.length; i++) {
      int endIndex = contentLength + contentArr[i].length + (i == contentArr.length - 1 ? 0 : 1);
      newContentArr.add(content.substring(
        contentLength,
        endIndex
      ));
      contentLength = endIndex;
    }
    return newContentArr;
  }
}

class Screen {
  static double get width {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.width;
  }
  
  static double get height {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.size.height;
  }

  static double get scale {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.devicePixelRatio;
  }

  static double get textScaleFactor {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.textScaleFactor;
  }

  static double get navigationBarHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top + kToolbarHeight;
  }

  static double get topSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.top;
  }

  static double get bottomSafeHeight {
    MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);
    return mediaQuery.padding.bottom;
  }

  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
