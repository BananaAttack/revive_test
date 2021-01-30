import "package:dio/dio.dart";
import 'dart:async';
import 'package:city_alliance/config/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String BASEURL = baseUrl;

class HTTPConfig {
  static const baseURL = BASEURL;
  static const timeout = 5000;
  static const contentType = Headers.formUrlEncodedContentType;
}

class HttpRequest {
  static final BaseOptions options = BaseOptions(
      baseUrl: HTTPConfig.baseURL,
      connectTimeout: HTTPConfig.timeout,
      contentType: HTTPConfig.contentType);
  static final Dio dio = Dio(options);

  // 默认的请求方法是get
  static Future<T> request<T>(String url,
      {String method = 'get',
      Map<String, dynamic> params,
      Interceptor inter}) async {
    // 1.请求的单独配置
    final options = Options(method: method);

    // 2.添加第一个拦截器
    Interceptor dInter =
        InterceptorsWrapper(onRequest: (RequestOptions options) {
      // 1.在进行任何网络请求的时候, 可以添加一个loading显示
      // 2.很多页面的访问必须要求携带Token,那么就可以在这里判断是有Token
      // 3.对参数进行一些处理,比如序列化处理等

      // 判断是否有token
      dio.lock();
      Future<dynamic> future = Future(() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs.getString("user_token");
      });
      return future.then((value) {
        print("token:" + value.toString());
        options.headers["Authorization"] = value;
        return options;
      }).whenComplete(() => dio.unlock()); // unlock the dio
    }, onResponse: (Response response) {
      print("拦截了响应");
      return response;
    }, onError: (DioError error) {
      print("拦截了错误");
      return error;
    });
    List<Interceptor> inters = [dInter];
    if (inter != null) {
      inters.add(inter);
    }
    dio.interceptors.addAll(inters);

    // 3.发送网络请求
    try {
      Response response =
          await dio.request<T>(url, queryParameters: params, options: options);
      return response.data;
    } on DioError catch (e) {
      return Future.error(e);
    }
  }
}

// TODO: IOS请求：http问题
