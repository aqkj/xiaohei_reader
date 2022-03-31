/**
 * 章节模型
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/09 20:20:14
 */
import 'package:intimate_couple/components/sorptionview_flutter/adsorptiondatabin.dart';
class Chapter extends AdsorptionData {
  final String id;
  final String name;
  final bool isHeader;
  /// 下一章的id
  final String nid;
  /// 上一章的id
  final String pid;
  /// 当前章节id
  final String cid;
  /// 当前章节名称
  final String cname;
  final String content;
  Chapter({
    this.id,
    this.name,
    this.isHeader,
    this.cid,
    this.pid,
    this.nid,
    this.cname,
    this.content
  });
  /// 转化为map 
  static Chapter fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    final Chapter chapter = new Chapter(
      id: map['id'].toString() ?? '',
      name: map['name'] ?? '',
      isHeader: map['isHeader'] ?? false,
      cid: map['cid'].toString() ?? '',
      nid: map['nid'].toString() ?? '',
      pid: map['pid'].toString() ?? '',
      cname: map['cname'] ?? '',
      content: map['content'] ?? ''
    );
    return chapter;
  }
}