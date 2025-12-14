import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/utils/cache.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider{
  Duration durationTimeout = const Duration(seconds: 30);
  String baseUrl = "https://cafe.geeks-soft.uz/";

  _getReqHeader() {
    String token = CacheService.getToken();
    if (token == "") {
      return {
        "Content-Type": "application/json",
      };
    } else {
      return {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };
    }
  }

  Future<HttpResult> _postRequest(url, body) async {
    if (kDebugMode) {
      print(url);
      print(body);
    }

    final dynamic headers = await _getReqHeader();
    try {
      http.Response response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: body,
      )
          .timeout(durationTimeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }
  Future<HttpResult> _putRequest(url, body) async {
    if (kDebugMode) {
      print(url);
      print(body);
    }

    final dynamic headers = await _getReqHeader();
    try {
      http.Response response = await http
          .put(
        Uri.parse(url),
        headers: headers,
        body: body,
      )
          .timeout(durationTimeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }
  Future<HttpResult> _patchRequest(url, body) async {
    if (kDebugMode) {
      print(url);
      print(body);
    }

    final dynamic headers = await _getReqHeader();
    try {
      http.Response response = await http
          .patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      )
          .timeout(durationTimeout);
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    } on SocketException catch (_) {
      return HttpResult(
        isSuccess: false,
        status: -1,
        result: null,
      );
    }
  }


  Future<HttpResult> _getRequest(String url) async {
    final headers = await _getReqHeader();

    if (kDebugMode) {
      print("🔹 REQUEST URL: $url");
      print("🔹 REQUEST HEADERS: $headers");
    }

    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(durationTimeout);

      if (response.statusCode == 401 || _isTokenInvalid(response)) {
        print("⚠️ Token eskirgan, refresh qilinmoqda...");
        bool refreshed = await _refreshToken();

        if (refreshed) {
          final newHeaders = await _getReqHeader();
          response = await http
              .get(Uri.parse(url), headers: newHeaders)
              .timeout(durationTimeout);
        } else {
          print("❌ Token yangilash muvaffaqiyatsiz bo‘ldi.");
        }
      }
      return _result(response);
    } on TimeoutException catch (_) {
      return HttpResult(isSuccess: false, status: -1, result: "Timeout");
    } on SocketException catch (_) {
      return HttpResult(isSuccess: false, status: -1, result: "No Internet");
    }
  }
  HttpResult _result(http.Response response) {
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return HttpResult(
        isSuccess: true,
        status: response.statusCode,
        result: json.decode(utf8.decode(response.bodyBytes)),
      );
    } else {
      try {
        return HttpResult(
          isSuccess: false,
          status: response.statusCode,
          result: json.decode(utf8.decode(response.bodyBytes)),
        );
      } catch (_) {
        return HttpResult(
          isSuccess: false,
          status: response.statusCode,
          result: response.body,
        );
      }
    }
  }
  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refresh_token");
      if (refreshToken == null) return false;
      final response = await http.post(
        Uri.parse("${baseUrl}api/token/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );
      print("refreshToken: $refreshToken");
      print("response: ${response.body}");
      print("response: ${response.request}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data["access"];
        if (newAccess != null) {
          CacheService.saveToken(newAccess);
          await prefs.setString("access", newAccess);
          return true;
        }
      }
      print("⚠️ Token yangilashda xato: ${response.body}");
      return false;
    } catch (e) {
      print("❌ _refreshToken xato: $e");
      return false;
    }
  }
  bool _isTokenInvalid(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map &&
          body.containsKey("code") &&
          body["code"] == "token_not_valid") {
        return true;
      }
    } catch (_) {}
    return false;
  }
  Future<HttpResult> login(data)async{
    String url = "${baseUrl}auth/access";
    return await _postRequest(url, json.encode(data));
  }

  Future<HttpResult> account()async{
    String url = "${baseUrl}auth/me";
    return await _getRequest(url,);
  }
  Future<HttpResult> hallCategory()async{
    String url = "${baseUrl}api/halls/";
    return await _getRequest(url,);
  }
  Future<HttpResult> places()async{
    String url = "${baseUrl}api/places/";
    return await _getRequest(url,);
  }
  Future<HttpResult> allFoods()async{
    String url = "${baseUrl}api/foods/";
    return await _getRequest(url,);
  }
  Future<HttpResult> foodDetail(int id)async{
    String url = "${baseUrl}api/foods/$id";
    return await _getRequest(url,);
  }
  Future<HttpResult> allCategories()async{
    String url = "${baseUrl}api/categories/";
    return await _getRequest(url,);
  }
  Future<HttpResult> categoriesId(int id)async{
    String url = "${baseUrl}api/categories/$id";
    return await _getRequest(url,);
  }
  Future<HttpResult> addOrder(data)async{
    String url = "${baseUrl}api/orders/";
    return await _postRequest(url,data);
  }

  Future<HttpResult> getAOrderId(int id)async{
    String url = "${baseUrl}api/orders/";
    if(id == 0){
      url = "${baseUrl}api/orders/";
    }else{
      url = "${baseUrl}api/orders/$id";
    }
    return await _getRequest(url);
  }
  Future<HttpResult> updateOrder(data,id)async{
    String url = "${baseUrl}api/orders/$id";
    return await _putRequest(url,data);
  }
}