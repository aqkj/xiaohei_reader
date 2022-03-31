/**
 * 页面加载
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/09 11:36:46
 */
import 'package:flutter/material.dart';

class PageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      child: CircularProgressIndicator(
        // value: 0.3,
        valueColor: AlwaysStoppedAnimation(
          Colors.red
        ),
      ),
    );
  }
}