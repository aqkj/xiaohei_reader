/**
 * 书api
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 14:15:04
 */
import 'package:intimate_couple/utils/request.dart';
import 'dart:convert';
class Api {
  static const baseUrl = 'https://quapp.1122dh.com';
  static const searchApi = 'https://sou.jiaston.com/search.aspx';
  static const genderApi = 'https://quapp.1122dh.com/v5/base';
  static const storeSexBannerApi = 'https://quapp.1122dh.com/v5/base';
  static const categoryApi = 'https://quapp.1122dh.com/BookCategory';
  static const listApi = 'https://quapp.1122dh.com/shudan';
  static const rankApi = 'https://quapp.1122dh.com/top';
  static const infoApi = 'https://quapp.1122dh.com/info';
  static const commentApi = 'http://changyan.sohu.com/api/2/topic/load';
  static const listDetailApi = 'https://quapp.1122dh.com/shudan/detail';
  static const categoryRankApi = 'https://quapp.1122dh.com/Categories';
  static const chaptersApi = 'https://quapp.1122dh.com/book';
  static const chapterApi = 'https://quapp.1122dh.com/book';
}
/// 获取性别数据
Future<Map<String, dynamic>> getGenderData(String gender) async {
  final result = await request(
    url: '${Api.genderApi}/$gender.html',
    method: 'get',
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取性别banner
Future<Map<String, dynamic>> getGenderBanner(String gender) async {
  final result = await request(
    url: Api.storeSexBannerApi + '/banner_$gender.html',
    method: 'get'
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取排行榜数据
/// gender性别
/// kind种类[最热, '推荐', '完结', '收藏', '新书', '评分']
/// kind种类['hot', 'commend', 'over', 'collect', 'new', 'vote']
/// time为周榜，月榜，总榜
/// time为'week', 'month', 'total'
/// page第几页
Future<Map<String, dynamic>> getRankData(String gender, String kind, String time, int page) async {
  final result = await request(
    url: '${Api.rankApi}/$gender/top/$kind/$time/$page.html',
    method: 'get'
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取其他小说网站的数据
Future<Map<String, dynamic>> getRankMoreData(String gender, String kind, int page) async {
  final result = await request(
    url: '${Api.rankApi}/$gender/more/$kind/$page.html',
    method: 'get'
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取分类信息
Future<Map<String, dynamic>> getCategory() async {
  final result = await request(
    url: '${Api.categoryApi}.html',
    method: 'get'
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取分类数据
Future<Map> getCategoryRankData({
  String categoryId,
  String kind,
  int curPage
}) async {
  var result = await request(
    url: '${Api.categoryRankApi}/$categoryId/$kind/$curPage.html',
    method: 'get'
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取详情
Future<Map> getInfoData(int bookId) async {
  final result = await request(
    url: '${Api.infoApi}/$bookId.html',
    method: 'get'
  );
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}
/// 获取章节列表
Future<Map> getChaptersData(int bookId) async {
  final result = await request(
    url: '${Api.chaptersApi}/$bookId/',
    method: 'get'
  );
  final data = result.data.toString().replaceAll(',]', ']');
  return json.decode(data);
}
/// 获取章节详情
Future<Map> getChapterData(int bookId, String chapterId) async {
  final result = await request(
    url: '${Api.chapterApi}/$bookId/$chapterId.html/',
    method: 'get'
  );
  final data = result.data.toString().replaceAll(',]', ']');
  return json.decode(data);
}
/// 搜索小说
Future<Map> searchBook(String key, int page) async {
  var result = await request(
    url: Api.searchApi,
    method: 'get',
    params: {
      'siteid': 'app2',
      'key': key,
      'page': page,
    });
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}