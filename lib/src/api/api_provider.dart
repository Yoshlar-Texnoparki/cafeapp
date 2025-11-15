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

  getReqHeader() {
    String token = CacheService.getToken();
    if (token == "") {
      return {
        "Accept": "application/json",
      };
    } else {
      return {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
    }
  }

  Future<HttpResult> postRequest(url, body) async {
    if (kDebugMode) {
      print(url);
      print(body);
    }

    final dynamic headers = await getReqHeader();
    try {
      http.Response response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: body,
      )
          .timeout(durationTimeout);
      return result(response);
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
  Future<HttpResult> patchRequest(url, body) async {
    if (kDebugMode) {
      print(url);
      print(body);
    }

    final dynamic headers = await getReqHeader();
    try {
      http.Response response = await http
          .patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      )
          .timeout(durationTimeout);
      return result(response);
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


  Future<HttpResult> getRequest(String url) async {
    final headers = await getReqHeader();

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
          final newHeaders = await getReqHeader();
          response = await http
              .get(Uri.parse(url), headers: newHeaders)
              .timeout(durationTimeout);
        } else {
          print("❌ Token yangilash muvaffaqiyatsiz bo‘ldi.");
        }
      }
      return result(response);
    } on TimeoutException catch (_) {
      return HttpResult(isSuccess: false, status: -1, result: "Timeout");
    } on SocketException catch (_) {
      return HttpResult(isSuccess: false, status: -1, result: "No Internet");
    }
  }
  HttpResult result(http.Response response) {
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

  Future<HttpResult> login(Map data)async{
    String url = "${baseUrl}auth/access";
    return await postRequest(url, data);
  }
}