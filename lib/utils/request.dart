/**
 * 请求封装
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 14:08:23
 */
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio dio = new Dio(
  BaseOptions(
    connectTimeout: 10000,
    receiveTimeout: 10000
  )
);
/// 获取数据请求
Future<Response> request({ RequestOptions options, String url, String method, data, Map<String, dynamic> params }) async{
  debugPrint('**********发起请求*********');
  debugPrint('options: ' + options.toString());
  debugPrint('url: ' + url);
  debugPrint('method: ' + method);
  debugPrint('params: ' + params.toString());
  debugPrint('data: ' + data.toString());
  Response response = await dio.request(
    url,
    data: data,
    queryParameters: params,
    options: RequestOptions(
      method: method,
    )
  );
  debugPrint('response: ' + response.toString());
  debugPrint('**********结束请求*********');
  return response;
}