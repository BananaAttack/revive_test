import 'dart:convert';
import 'package:revive_test/service/http_request.dart';
import 'package:revive_test/config/apis.dart';

/**
 * 安全认证与登录注册 8000
 */
class LoginAndSecurityApi {
  // 账号密码登录
  static loginByName(Map<String, dynamic> params) async {
    await HttpRequest.request(baseUrl + apiUrl["loginByName"],
            method: "post", params: params)
        .then((res) {
      // TODO: 没写完整
      print(res);
    });
  }

  // 手机号登录
  static loginByPhone(Map<String, dynamic> params) async {
    await HttpRequest.request(baseUrl + apiUrl["loginByPhone"],
            method: "post", params: params)
        .then((res) async {
      print(res);
      String token = res['data'];
      // token 存入本地
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
      // 设置登录状态
      await prefs.setBool('is_login', true);
      // 请求用户信息
      await UserApi.getUserInfo();
    });
  }

  // 发送短信验证码
  static sendCode(Map<String, dynamic> params) async {
    await HttpRequest.request(baseUrl + apiUrl["sendCode"],
            method: "post", params: params)
        .then((res) {
      print(res);
    });
  }
}

/**
* 用户模块 8004
*/
class UserApi {
  // 获取单个用户的详细信息
  static getUserInfo() async {
    await HttpRequest.request(baseUrl + apiUrl["getUserInfo"], method: "get")
        .then((res) async {
      // 持久化：将个人信息存入本地
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("user_info", json.encode(res['data']));
    });
  }

  // 修改用户个人信息
  static editUserInfo(Map<String, dynamic> params) async {
    await HttpRequest.request(baseUrl + apiUrl["editUserInfo"],
            method: "put", params: params)
        .then((res) {
      // TODO: 没写完整
      print(res);
    });
  }
}
